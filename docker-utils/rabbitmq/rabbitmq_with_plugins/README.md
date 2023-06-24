## RabbitMQ com plugins adicionais via Docker

Para uma implementação e utilização do RabbitMQ mais completa e complexa diretamente rodando no Docker, nós precisaremos de uma imagem do RabbitMQ customizada, contendo alguns plugins adicionais que nos auxiliarão e nos darão mais recursos disponíveis. Para isso, na raiz do projeto teremos uma pasta chamada .docker que irá conter os arquivos Dockerfile do projeto, no caso dessa edição do RabbitMQ, nós precisaremos de uma versão customizada da imagem do RabbitMQ, com alguns plugins adicionais instalados.

São eles:

* **rabbitmq_shovel** - É um plugin para que o RabbitMQ transfira as mensagens de uma fila para outra. Utilizamos isso para caso seja necessário reprocessar algumas mensagens, nós podermos ter essas mensagens em uma fila específica para o reprocessamento.
* **rabbitmq_shovel_management** - UI para gerenciamento do Shovel dentro do RabbitMQ Manager.
* **rabbitmq_delayed_message_exchange** - No RabbitMQ existe uma feature chamada Delayed Messages. Ela serve para caso o processamento das mensagens de uma fila falhe, podermos jogá-las novamente na fila, mas informando que ela deve ser processada novamente apenas em um período de tempo no qual formos definir na própria configuração da fila, ou seja, informamos que desejamos reprocessar essas mensagens, somente daqui a 5 minutos, por exemplo, e não automaticamente agora.
* **rabbitmq_consistent_hash_exchange** - Esse plugin irá fazer com que o RabbitMQ trate o valor da chave de roteamento de ligação (Routing Key) como uma prioridade, onde a troca direta realmente irá comparar seu valor com a chave de roteamento na mensagem.

Teremos então um arquivo final chamado rabbitmq.dockerfile, com a seguinte configuração:

```.dockerfile
FROM rabbitmq:3.11.16-management

RUN apt-get update
RUN apt-get install -y curl
RUN curl -L https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v3.12.0/rabbitmq_delayed_message_exchange-3.12.0.ez > $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-3.12.0.ez
RUN chown rabbitmq:rabbitmq $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-3.12.0.ez

RUN rabbitmq-plugins enable --offline rabbitmq_shovel
RUN rabbitmq-plugins enable --offline rabbitmq_shovel_management
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
RUN rabbitmq-plugins enable --offline rabbitmq_consistent_hash_exchange
```

Já na raiz do projeto, nós teremos o nosso arquivo do docker compose que irá subir de fato uma instância do RabbitMQ utilizando a imagem customizada que acabamos de criar.

```.dockerfile
version: "3.7"

services:
  rabbitmq:
    build:
      context: .
      dockerfile: ./.docker/rabbitmq.dockerfile
    container_name: rabbitmq
    user: root
    ports:
      - "5672:5672"
      - "15672:15672"
      - "25676:25676"
    networks:
      - dev-network
    volumes:
      - C:\containers\rabbitmq\data:/var/lib/rabbitmq/
      - C:\containers\rabbitmq\log:/var/log/rabbitmq
      - C:\containers\rabbitmq\mnesia:/var/lib/rabbitmq/mnesia
    environment:
      RABBITMQ_DEFAULT_USER: ${RABBITMQ_USERNAME}
      RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASSWORD}
      RABBITMQ_DEFAULT_VHOST: ${RABBITMQ_DEFAULT_VHOST}
    healthcheck:
      test: ["CMD", "rabbitmq-diagnostics", "-q", "ping"]
      interval: 5s
      timeout: 10s
      retries: 5

networks:
  dev-network:
    driver: bridge
```

Na raiz do projeto, também teremos um arquivo .env contendo informações do RabbitMQ, como:

```.env
RABBITMQ_USERNAME= Nome de usuário para o login no RabbitMQ
RABBITMQ_PASSWORD= Senha de usuário para o login no RabbitMQ
RABBITMQ_DEFAULT_VHOST= Nome do Virtual Host que criamos para a aplicação
```

Com isso, teremos a nossa instância do RabbitMQ pronta para uso, e podemos acessá-la através do endereço: **localhost:15672/#/**
