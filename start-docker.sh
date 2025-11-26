#!/bin/bash

# -------------------
# Docker Installation and Configuration
# -------------------
echo -e "${BLUE}Instalando Docker Engine...${NC}"

    # Install required packages
    sudo dnf -y install dnf-plugins-core 

    # Add Docker repository
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

    # Install Docker components
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Start and enable Docker service
    sudo systemctl enable --now docker

    # Configure user permissions
    echo -e "${BLUE}Configurando permissões do usuário para Docker...${NC}"

    # Create docker group if it doesn't exist
    if ! getent group docker > /dev/null; then
      sudo groupadd docker 
      echo -e "${GREEN}Grupo docker criado${NC}"
    fi

    # Add user to docker group
    if ! groups $USER | grep -q '\bdocker\b'; then
      sudo usermod -aG docker $USER
      echo -e "${GREEN}Usuário $USER adicionado ao grupo docker${NC}"
    else
      echo -e "${GREEN}Usuário $USER já está no grupo docker${NC}"
    fi

    # Apply group changes immediately without logout
    echo -e "${YELLOW}Ativando mudanças de grupo...${NC}"
    newgrp docker <<EOF
    echo -e "${GREEN}Configuração do Docker concluída!${NC}"
    EOF

    # Verify installation
    echo -e "${BLUE}Verificando instalação...${NC}"
    docker run --rm hello-world && echo -e "${GREEN}Docker instalado e configurado com sucesso!${NC}" || echo -e "${RED}Erro na verificação do Docker${NC}"

    pause

# -------------------
# Existing Docker Network and Container Management
# -------------------
BASE_DIR="$HOME/Docker"
NETWORK_NAME="shared-network"

echo "Criando docker network: $NETWORK_NAME"
docker network create "$NETWORK_NAME" 2>/dev/null || echo "Rede já existe, seguindo..."

echo "Procurando projetos em $BASE_DIR..."
for dir in "$BASE_DIR"/*/; do
  [ -d "$dir" ] || continue

    # Extrai apenas o nome da pasta
    folder_name=$(basename "$dir")

    # Ignora pastas terminadas com .dsb
    if [[ "$folder_name" == *.dsb ]]; then
      echo "Ignorando repositório desabilitado: $folder_name"
      continue
    fi

    echo "--------------------------------------"
    echo "Entrando na pasta: $dir"

    # Verifica arquivos possíveis de compose
    if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ] \
      || [ -f "$dir/compose.yml" ] || [ -f "$dir/compose.yaml" ]; then

    echo "Arquivo docker-compose encontrado. Subindo containers..."
    (cd "$dir" && docker compose up -d)

  else
    echo "Nenhum arquivo docker-compose encontrado. Pulando..."
    fi
  done

  echo "Finalizado!"
