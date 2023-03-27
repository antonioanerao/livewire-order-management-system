#!/bin/bash

# Faz uma cópia do arquivo docker-compose.example.yml
if [ -f "docker-compose.yml" ]; then
  echo "O arquivo docker-compose.yml já existe"
else
  cp docker-compose.example.yml docker-compose.yml
  echo "docker-compose.yml foi criado"
fi

# Cria um diretório para o laravel
if [ -d "laravel" ]; then
  echo "A pasta laravel já existe" ;
else
  mkdir -p laravel;
  echo "A pasta laravel foi criada"
fi

# Cria um volume para o laravel e direciona o conteúdo para o diretório laravel
if docker volume inspect laravel > /dev/null 2>&1; then
  echo "O volume laravel já existe"
else
  docker volume create --driver local --opt type=none --opt device="$(pwd)"/laravel --opt o=bind laravel > /dev/null 2>&1;
  echo "O volume laravel foi criado"
fi

echo ""

docker-compose up -d

# Rodar composer update
if [ -d "laravel/vendor" ]; then
  echo "O composer update já foi executado" ;
else
  docker exec -it webserver composer update
  echo "Composer Update executado"
fi

# Rodar npm install
if [ -d "laravel/node_modules" ]; then
  echo "O npm install já foi executado" ;
else
  docker exec -it webserver npm install
  echo "npm install executado executado"
fi

# Cria o arquivo .env
if [ -f "./laravel/.env" ]; then
  echo "O arquivo .env já existe"
else
  cp ./laravel/.env.example ./laravel/.env
  php laravel/artisan key:generate
  echo "Criado arquivo .env"
fi

# Ajusta as permissões para o projeto
sudo chown "$USER":www-data -R laravel/
sudo chgrp -R www-data laravel/storage laravel/bootstrap/cache
sudo chmod -R ug+rwx laravel/storage laravel/bootstrap/cache