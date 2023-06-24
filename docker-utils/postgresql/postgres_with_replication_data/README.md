## Replicação de banco de dados com o PostgreSQL

Primeiramente, devemos criar um container do postgres no docker com o comando docker-compose a seguir:

```.docker
version: "3.7"

services:
  postgres:
    image: postgres
    container_name: postgres
    user: root
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      PG_DATA: "/var/lib/postgresql/data"
      POSTGRES_DB: postgres
    ports:
      - "5432:5432"
    volumes:
      - C:\containers\postgresql\main:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - dev-network

  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin4
    user: root
    environment:
      PGADMIN_DEFAULT_EMAIL: ${PGADMIN_EMAIL}
      PGADMIN_DEFAULT_PASSWORD: ${PGADMIN_PASSWORD}
    ports:
      - "16543:80"
    depends_on:
      - postgres
    networks:
      - dev-network

networks:
  dev-network:
    driver: bridge
```

Nesse comando, estamos subindo um container do **PostgreSQL** e um container para o **PGAdmin**. Agora, devemos criar um usuário de replicação de dados que será utilizado pelas instâncias de replicação, esse usuário ficará observando os arquivos WAL *(arquivos de backup de um banco postgresql)* e ficará aplicando essas alterações a instância de replicação.

Primeiramente, devemos subir os containers:


```.cmd
docker-compose up -d
```

E na sequencia, vamos conectar na instância do nosso container Docker:

```.cmd
docker exec -it postgres bash
```

Conectar no banco de dados do Postgres que está no nosso container:

```.cmd
psql -U postgres
```

E criar o usuário responsável pela replicação dos dados:

```.sql
CREATE ROLE user_replica WITH
	LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	REPLICATION
	CONNECTION LIMIT -1
	PASSWORD 'password';
COMMENT ON ROLE user_replica IS 'This user is responsible to streaming and apply replication data on databases';
```

Após isso, devemos reiniciar o Postgres com o seguinte comando:

```.cmd
/etc/init.d/posgresql restart
```

Após a criação do usuário responsável pela replicação e backup do banco de dados, devemos definir algumas configurações no arquivo **pg_hba.conf**. Esse arquivo é como se fosse um “firewall” que indica se um usuário pode ou não conectar no postgres e também informa em quais bases de dados esse usuário consegue conectar.

Aproximadamente na linha 99 deste arquivo, nós iremos informar que um usuário chamado **user_replica** pode acessar todas as bases de dados, a partir de qualquer endereço de IP e que deve usar uma senha, informamos isso a partir do scram-sha-256. 

```.txt
# Allow replication connections from localhost, by a user with the
# replication privilege.
local      replication          all                                trust
host       replication          all             127.0.0.1/32       trust
host       replication          all             ::1/128            trust
host       replication          user_replica    0.0.0.0/0          scram-sha-256

host       all                  all             all                scram-sha-256
```

Após isso, devemos criar um slot de replicação de dados, faremos isso, conectando novamente na instância do postgres:

```.cmd
docker exec -it postgres bash
```

Conectando no banco de dados:

```.cmd
psql -U postgres
```

E rodando o comando:

```.sql
SELECT pg_create_physical_replication_slot('slot_replication_main');
```

O slot de replicação é um espaço onde o Postgres vai armazenar os arquivos de WAL e garantir que esses arquivos fiquem disponíveis para que as réplicas possam igualar os seus bancos ao banco de dados principal. Para isso, devemos configurar o arquivo **postgres.conf**, neste arquivo, nós iremos habilitar as configurações de replicação. Devemos realizar uma alteração aproximadamente na linha 200 deste arquivo:

```.conf
#------------------------------------------------------------------------------
# WRITE-AHEAD LOG
#------------------------------------------------------------------------------

# - Settings -

wal_level = logical			# minimal, replica, or logical
					        # (change requires restart)
#fsync = on				    # flush data to disk for crash safety
					        # (turning this off can cause
					        # unrecoverable data corruption)
#synchronous_commit = on	# synchronization level;
					        # off, local, remote_write, remote_apply, or on
#wal_sync_method = fsync	# the default is the first option
					        # supported by the operating system:
					        #   open_datasync
					        #   fdatasync (default on Linux and FreeBSD)
					        #   fsync
					        #   fsync_writethrough
					        #   open_sync
#full_page_writes = on		# recover from partial page writes
#wal_log_hints = off		# also do full page writes of non-critical updates
					        # (change requires restart)
wal_compression = on		# enables compression of full-page writes;
```

Devemos alterar também a configuração de replicação, no mesmo arquivo:

```.conf
#------------------------------------------------------------------------------
# REPLICATION
#------------------------------------------------------------------------------

# - Sending Servers -

# Set these on the primary and on any standby that will send replication data.

max_wal_senders = 10	           # max number of walsender processes
				                   # (change requires restart)
max_replication_slots = 10	       # max number of replication slots
				                   # (change requires restart)
#wal_keep_size = 0		           # in megabytes; 0 disables
#max_slot_wal_keep_size = -1       # in megabytes; -1 disables
#wal_sender_timeout = 60s	       # in milliseconds; 0 disables
#track_commit_timestamp = off      # collect timestamp of transaction commit
				                   # (change requires restart)
```

As configurações a seguir serão válidas apenas para a instância de replicação do banco de dados, porém, como a réplica do banco de dados vai ser uma cópia exata da instância principal, já aplicamos as alterações neste mesmo arquivo, e quando a réplica for criada, essas alterações serão automaticamente aplicadas à instância de replicação. As alterações abaixo ficam no nodo Standby Servers aproximadamente na linha 328.

```.conf
# - Standby Servers -

# These settings are ignored on a primary server.

primary_conninfo = 'host=postgres port=5432 user=user_replica password=password'	 # connection string to sending server
primary_slot_name = 'slot_replication_main'                                          # replication slot on sending server
#promote_trigger_file = ''		                                                     # file name whose presence ends recovery
hot_standby = on			                                                         # "off" disallows queries during recovery
					                                                                 # (change requires restart)
#max_standby_archive_delay = 30s	                                                 # max delay before canceling queries
					                                                                 # when reading WAL from archive;
					                                                                 # -1 allows indefinite delay
#max_standby_streaming_delay = 30s	                                                 # max delay before canceling queries
					                                                                 # when reading streaming WAL;
					                                                                 # -1 allows indefinite delay
#wal_receiver_create_temp_slot = off	                                             # create temp slot if primary_slot_name
					                                                                 # is not set
#wal_receiver_status_interval = 10s	                                                 # send replies at least this often
					                                                                 # 0 disables
hot_standby_feedback = true	                                                         # send info from standby to prevent
					                                                                 # query conflicts
#wal_receiver_timeout = 60s		                                                     # time that receiver waits for
					                                                                 # communication from primary
					                                                                 # in milliseconds; 0 disables
#wal_retrieve_retry_interval = 5s	                                                 # time to wait before retrying to
					                                                                 # retrieve WAL after a failed attempt
#recovery_min_apply_delay = 0		                                                 # minimum delay for applying changes during recovery

```

Nessas configurações, estamos informando:

* **primary_conninfo** - temos a string de conexão do banco de dados principal. Para que a instância de replicação possa se conectar com a instância principal do banco de dados.
* **primary_slot_name** - o slot de replicação que criamos anteriormente.
* **hot_standby** - desabilita as queries durante o modo de recovery dos arquivos
* **hot_standby_feedback** - envia informações de recuperação para evitar conflitos de queries

Após isso, devemos parar os containers e recriá los com os comandos:

```.cmd
docker-compose down

docker-compose up -d --force-recreate
```

Após isso, os containers serão recriados, e com isso, devemos agora, replicar o nosso servidor principal. Para isso, iremos criar um novo serviço no arquivo docker-compose que será o container onde ficará a nossa instância de replicação:

Mas primeiramente, devemos parar os containers que estão rodando:

```.cmd
docker-compose down
```

Alteramos o arquivo docker-compose:


```.docker
    networks:
      - dev-network

  replica:
    image: postgres
    container_name: replica
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      PG_DATA: "/tmp"
      POSTGRES_DB: postgres
    ports:
      - "5434:5432"
    depends_on:
      - postgres
    volumes:
      - C:\containers\postgresql\replica:/var/lib/postgresql/data
    networks:
      - dev-network

  pgadmin:
    image: dpage/pgadmin4
```

Nesse container de replicação, adicionando um volume diferente: **C:\containers\postgresql\replica**. Vamos recriar os containers:

```.cmd
docker-compose up -d --force-recreate
```

Agora, devemos conectar em nosso container que está com a instância de replicação:

```.cmd
docker exec -it replica bash
```

E na sequência, devemos rodar o comando que irá criar um backup do postgresql que está na instância principal.

```.cmd
pg_basebackup -h postgres -U user_replica -D /var/lib/postgresql/data/replication -v -P -X s -c fast
```

Neste comando, estamos fazendo:
* **-h**      - host onde está a instância do nosso banco de dados principal
* **-U**      - usuário que irá realizar essa cópia
* **-D**      - pasta onde serão colocados os arquivos que devem ser copiados do servidor principal. No nosso exemplo será a pasta **replication** que está dentro da pasta **replica** *(que é a pasta onde estão os arquivos do container onde está rodando a instância de réplica que criamos)*
* **-v**      - “verbose” para podermos ver o que está acontecendo durante o backup
* **-P**      - “progress” para podermos visualizar o progresso
* **-X s**    - Tipo de stream que será realizado
* **-c fast** - Forçar um checkpoint e realizar o backup da forma mais rápida possível

Quando o backup concluir, devemos parar os containers com o comando:

```.cmd
docker-compose down
```

E irmos na pasta **replica**. Dentro dela teremos a pasta **replication** que foi criada pelo pg_backup rodado anteriormente, devemos mover todo o conteúdo desta pasta, para a pasta replica ***substituindo assim o seu conteúdo original por pelo conteúdo que estava dentro da pasta replication***. Por fim, devemos criar na raiz da pasta replica, um arquivo chamado **standby.signal**, sem nada dentro, apenas o arquivo vazio sem conteúdo. Este arquivo que irá indicar que essa instância deve ficar em stand by apenas copiando o conteúdo da instância do server main a cada update. Agora basta recriarmos os containers e a partir desse momento teremos uma instância principal e uma instância de réplica.

```.cmd
docker-compose up -d --force-recreate
```