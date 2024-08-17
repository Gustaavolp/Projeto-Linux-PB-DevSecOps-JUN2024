# Projeto-Linux-PB-DevSecOps-JUN2024

Projeto referente a Sprint 4 do Programa de bolsas - DevSecOps - JUN 2024
 
## Passo a Passo na AWS

### Gerando uma chave pública para acesso ao ambiente


#### Navegue até o serviço de EC2:

1. No console da AWS, vá em **Serviços** → **Computação** → **EC2**.
2. No menu lateral, localize a seção **Rede e segurança** e clique em **Pares de chaves**.

#### Criar um novo par de chaves:


1. Clique em **Criar par de chaves**.
2. Preencha os campos:
   - **Nome**: `projeto-linux`
   - **Tipo de par de chaves**: `RSA`
   - **Formato de arquivo de chave privada**: `.pem`

   ##### Adicionar tags:

    - **Name**: `PB - JUN 2024`
    - **CostCenter**: `C092000024`
    - **Project**: `PB - JUN 2024`

### Criando uma instância EC2 com Amazon Linux 2

#### No serviço EC2
   - No menu lateral, localize a seção **Instâncias** e clique em **Instâncias**.

#### Criando uma nova Instancia:


1. Clique em **Executar instâncias**.

2. Preencha os campos:

      ##### Adicionar tags:
   - **Name**: `PB - JUN 2024`
   - **CostCenter**: `C092000024`
   - **Project**: `PB - JUN 2024`

    ##### Adicionando o tipo de recurso as tags:
   - **Tipos de recurso**: `Instâncias e Volumes`


3. Selecionando a imagem do sistema operacional
   - **Imagem**: `Amazon Linux 2`

4. Selecionando o tipo de instância
   - **Tipo**: `t3.small`

5. Selecionando o par de chaves
   - **Par de chaves**: `projeto-linux`

6. Configurando a rede
   - **VPC**: `Selecione uma VPC com rota para a internet`
   - **Sub-rede**: `Selecione uma Sub-rede com rota para a internet`
   - **Atribuir IP público automaticamente**: `Desabilitar`
   - **Firewall**: `Criar grupo de segurança`
   - **Nome do grupo de segurança**: `projeto-linux`
   - **Descrição**: `Public access: (22/TCP, 111/TCP and UDP, 2049/TCP/UDP, 80/TCP, 443/TCP)`
   - **Regras do grupo de segurança de entrada**: `Padrão`

 - Por quetões de cronologia da atividade, iremos configurar as **Regras** do **Grupo de Segurança** depois

7. Configurando o armazenamento
   - **Tamanho do volume**: `16GB`
   - **Tipo do volume**: `gp2`

### Gerando um Elastic IP e anexando à instância EC2:
#### No serviço EC2
   - No menu lateral, localize a seção **Rede e segurança** e clique em **IPs elásticos**.

#### Alocando um Elastic IP:

1. Clique em **Alocar endereço IP elástico**.

2. Preencha os campos:
   - **Conjunto de endereços IPv4 públicos**: `Conjunto de endereços IPv4 da Amazon`
   - **Grupo de borda de rede**: `us-east-1`

    ##### Adicionar tags:
   - **Name**: `PB - JUN 2024`
   - **CostCenter**: `C092000024`
   - **Project**: `PB - JUN 2024`

#### Anexando o Elastic IP à instância EC2:
   - No menu lateral, localize a seção **Rede e segurança** e clique em **IPs elásticos**.
   1. Selecione o IP elático que foi alocado

   2. Clique em **Ações** → **Associar endereço IP elástico**

      - **Tipo de recurso**: `Instância`
      - **Instância**: `Selecione a instância criada anteriormente`
      - **Endereço IP privado**: `Selecione seu endereço IP alocado anteriomente`

### Liberando as portas de comunicação para acesso público:
#### No serviço EC2
   - No menu lateral, localize a seção **Rede e segurança** e clique em **Security groups**.
   1. Selecione o Grupo de Segurança criado anteriomente: `projeto-linux`
   2. Clique em **Ações** → **Editar regras de entrada**
   3. Adicione as seguinte regras:

      | Porta | Protocolo | Origem | Descrição |
      | -- | -- | -- | -- |
      | 22 | TCP | 0.0.0.0/0 | SSH/22 - Public Access |
      | 111 | TCP | 0.0.0.0/0 | TCP/111 - Public Access |
      | 111 | UDP | 0.0.0.0/0 | UDP/111 - Public Access |
      | 2049 | TCP | 0.0.0.0/0 | TCP/2049 - Public Access |
      | 2049 | UDP | 0.0.0.0/0 | UDP/2049 - Public Access |
      | 80 | TCP | 0.0.0.0/0 | TCP/80 - Public Access |
      | 443 | TCP | 0.0.0.0/0 | TCP/443 - Public Access | 

### Criando um sistema de arquivos EFS

#### Navegue até o serviço de EFS:

1. No console da AWS, vá em **Serviços** → **Armazenamento** → **EFS**.
2. No menu lateral, localize e acesse na seção **Sistemas de arquivos**

#### Criar um sistema de arquivos:

1. Clique em **Criar sistema de arquivos**
2. Preencha os campos:
   - **Nome**: `projeto-linux`
   - **VPC**: `Selecione a mesma em que foi criado o Linux`

#### Configurando a rede do sistema de arquivos:

1. Selecione o EFS criado anteriormente
2. Clique em `Visualizar detalhes`
3. No menu inferior navegue até a seção `Rede`
4. Clique em `Gerenciar`
5. Troque o `Grupo de segurança` pelo criado anteriormente: `projeto-linux`

#### Configurando o sistema de arquivos:
#### No serviço EFS
1. Selecione o EFS criado anteriormente
2. Clique em `Visualizar detalhes`
3. Clique em `Anexar` → `Montar via IP`
4. Selecione a AZ que esta a instância EC2
5. Usaremos o código fornecido para montar o EFS na Instância EC2:
- **Usando o cliente do NFS:** `sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 10.0.141.106:/ efs`

## Passo a Passo no Linux:

### Acessando o ambiente Linux


#### Navegue até o serviço de EC2:

1.  No console da AWS, vá em  **Serviços**  →  **Computação**  →  **EC2**.
2.  No menu lateral, localize a seção  **Instâncias**  →  **Instâncias**.
3. Selecione a instância criada anteriormente
4. Clique em `Conectar`

- Por praticidade irei acessar via `EC2 Instance Connect`

### Configurando o ambiente Linux

 1. Fazendo update e upgrade no sistema:

        sudo yum update && sudo yum upgrade -y

 2. Conferindo se o NFS está instalado

        sudo yum install nfs-utils -y

 3. Criando um diretório para montar o EFS

        sudo mkdir efs

 4. Montando o EFS na pasta criada **( Código copiado no serviço EFS )**

        sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport IP do NFS:/ Diretório onde será montado

 5. Conferindo se o EFS foi montado

        df -h

 6. Criando um diretorio dentro do filesystem do EFS com meu nome

        sudo mkdir efs/Gustavo

 7. Instalando o Apache

        sudo yum install httpd -y
         
 8. Iniciando o  serviço do Apache

        sudo systemctl start httpd

### Criando o script de validação

 1. Criando o arquivo do script

        sudo nano check_apache.sh
    - Com o seguinte script:
   
          #!/bin/bash 
          STATUS=$(systemctl is-active httpd)
          TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
          if [ "$STATUS" = "active" ]; then
               echo "$TIMESTAMP Apache ONLINE - Tudo OK" >> /home/ec2-user/efs/Gustavo/apache_online.log
          else
               echo "$TIMESTAMP Apache OFFLINE - Verifique o serviço" >> /home/ec2-user/efs/Gustavo/apache_offline.log
          fi

2. Dando as permissões ao arquivo:

       sudo chmod 755 check_apache.sh
         
### Automatizando a execução do script com o Crontab

1. Editando o Crontab

       sudo crontab -e
   - Adicione o seguinte script:

         */5 * * * * /home/ec2-user/check_apache.sh
