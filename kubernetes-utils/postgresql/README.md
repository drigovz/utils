# Configuração do PostgreSQL em um cluster Kubernetes
Para a configuração do PostgreSQL em ambiente de desenvolvimento em um cluster Kubernetes utilizando o Minikube, devemos primeiramente criar um recurso **secret** para o armazenamento de senhas e configurações confidenciais.

_secret.yaml_

```.yaml
apiVersion: v1
kind: Secret

metadata:
  name: postgres-secret
  namespace: default
  labels:
    app: postgres

data:
  POSTGRES_PASSWORD: YWRtaW4xMjM=
stringData: 
  POSTGRES_USER: admin
  POSTGRES_DB: postgresdb
```
Esse é um serviço do tipo NodePort que irá expor uma porta um serviço do nosso cluster para acesso externo.

Agora, devemos criar as configurações de volumes para armazenamentos de dados utilizados pelo PostgreSQL. Para isso, iremos criar um PersistentVolume e um PersistentVolumeClaim, por meio dos arquivos:

_persistent-volume.yaml_

```.yaml
apiVersion: v1
kind: PersistentVolume

metadata:
  namespace: default
  name: postgres-pv

spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/minikube/directory/structure/"
    type: DirectoryOrCreate
```

_persistent-volume-claim.yaml_

```.yaml
apiVersion: v1
kind: PersistentVolumeClaim

metadata:
  namespace: default
  name: postgres-pvc

spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

Já temos os recursos necessários para a utilização do Postgre, agora, vamos criar o arquivo YAML que irá subir as instâncias dos containers do Postgre por meio de Pods do Kubernetes

_deployment.yaml_

```.yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  namespace: default
  name: postgres-deployment

spec:
  selector:
    matchLabels:
      app: postgres
  replicas: 2
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:10.4
          imagePullPolicy: "IfNotPresent"
          ports:
            - containerPort: 5432
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: postgresdb
          resources:
            limits:
              memory: "512Mi"
              cpu: "500m"
          env:
            - name: POSTGRES_USER
              valueFrom:
                secretKeyRef:
                  key: POSTGRES_USER
                  name: postgres-secret
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: POSTGRES_PASSWORD
                  name: postgres-secret
      volumes:
        - name: postgresdb
          persistentVolumeClaim:
            claimName: postgres-pvc
```

Por fim, agora devemos criar um serviço do tipo **NodePort** que irá disponibilizar os nossos Pods como um serviço com o acesso externo ao nosso cluster liberado.

_service.yaml_

```.yaml
kind: Service
apiVersion: v1

metadata:
  namespace: default
  name: postgres-svc

spec:
  type: NodePort
  selector:
    app: postgres
  ports:
    - protocol: TCP
      port: 5432
      targetPort: 5432
```

Porém, para que tudo funcione corretamente, é necessário a disponibilização de uma porta que o nosso cluster irá deixar disponível para a realização desse acesso. Para isso, iremos utilizar o recurso __port-forward__ do Kubernetes.

### Port Forward
O port-forward é um recurso que permite que possamos acessar algum serviço que está rodando dentro do cluster do Minikube fora dele, na nossa máquina local. O port-forward (encaminhamento de porta do Kubernetes) é útil para desenvolvimento e depuração porque permite:

- Use suas ferramentas de desenvolvimento local e conecte-se a um serviço em execução no cluster Kubernetes/Minikube.
- Acesse um serviço em execução no cluster usando seu navegador local.
- Acesse logs e outros dados de diagnóstico de um cluster que executa o serviço.

Sempre que necessitarmos da criação de uma conexão local para teste e debug com o nosso cluster, devemos utilizar esse comando.

Agora, para podermos testar o acesso aos nossos Pods, podemos rodar o seguinte comando:

```.sh
kubectl port-forward service/postgres-svc 5432:5432 &
```

O comando kubectl port-forward faz uma solicitação específica para a API do Kubernetes e via API Server encapsula uma conexão HTTP com o cluster Kubernetes. A API Server se torna um Gateway temporário entre a porta 5432 da nossa máquina com a porta 5432 do cluster Kubernetes. 

No final do nosso comando utilizamos o prefixo &, esse caracter indica ao Kubelet que iremos rodar esse serviço em background, ou seja, assim que esse serviço começar a rodar, o terminal ficará livre para uso novamente (se não passarmos a opção &, o terminal fica atrelado ao processo).

Esse serviço agora está rodando em backgorund em nossa máquina. Para matar esse serviço, usamos:

- No Windows:
```
Get-Process -Id (Get-NetTCPConnection -LocalPort "5432").OwningProcess | Stop-Process
```
- No GNU/Linux:
```
ps -ef | grep port-forward 

kill -9 [PID]
```
### PG Admin
Podemos adicionar também um Pod para o PGAdmin em nosso cluster, e com isso, gerenciarmos os bancos de dados do Postgre diretamente por ele. Para isso, devemos primeiramente criar um secret com as informações de login para o PGAdmin.

_pgadmin-secret.yaml_

```.yaml
apiVersion: v1
kind: Secret

metadata:
  name: pgadmin-secret
  namespace: default
  labels:
    app: pgadmin

data:
  PGADMIN_DEFAULT_PASSWORD: YWRtaW4xMjM=
stringData: 
  PGADMIN_DEFAULT_EMAIL: email@teste.com
```
Em seguida, criamos o arquivo de deployment que irá criar os Pods do PGAdmin.

_pgadmin-deployment.yaml_

```.yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  namespace: default
  name: pgadmin-deployment

spec:
  selector:
    matchLabels:
      app: pgadmin
  replicas: 2
  template:
    metadata:
      labels:
        app: pgadmin
    spec:
      containers:
        - name: pgadmin
          image: dpage/pgadmin4
          imagePullPolicy: "IfNotPresent"
          ports:
            - containerPort: 16543
          resources:
            limits:
              memory: "512Mi"
              cpu: "500m"
          env:
            - name: PGADMIN_DEFAULT_EMAIL
              valueFrom:
                secretKeyRef:
                  key: PGADMIN_DEFAULT_EMAIL
                  name: pgadmin-secret
            - name: PGADMIN_DEFAULT_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: PGADMIN_DEFAULT_PASSWORD
                  name: pgadmin-secret
```
Com isso, basta rodarmos o comando:

```
kubectl port-forward service/pgadmin-svc 16543:80 &
```

Por fim basta acessarmos o PGAdmin via browser: http://localhost:16543/login. 
Para conectar o PGAdmin dentro do Minikube em um banco de dados PostgreSQL que está dentro do Minikube, usamos o nome do serviço que está associado aos Pods do Postgres nesse caso é o postgres-svc.