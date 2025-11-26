# Ambiente Docker Local

Repositório com pequenos serviços containerizados (Redis, Postgres, MinIO e Jenkins) para uso durante o desenvolvimento. O script `start-docker.sh` instala o Docker em sistemas baseados em Fedora, cria a network compartilhada `shared-network` e sobe automáticamente todos os projetos que possuírem um arquivo `docker-compose*`.

## Pré-requisitos
- Fedora/RHEL com `dnf`
- Usuário com acesso `sudo`

## Como usar
1. Conceda permissão de execução: `chmod +x start-docker.sh`
2. Execute o script: `./start-docker.sh`
3. Para subir apenas um serviço: `cd redis && docker compose up -d` (substitua `redis` pelo serviço desejado)

## Estrutura
- `redis/`, `postgres/`, `minio/`: pilhas ativas com `docker-compose.yml`
- `jenkins.dsb/`: diretório ignorado pelo script (extensão `.dsb` desabilita o projeto)
- `start-docker.sh`: instalação do Docker e orquestração dos serviços
