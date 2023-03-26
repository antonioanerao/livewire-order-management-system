#!/bin/bash

# Faz uma cópia do arquivo docker-compose.example.yml
if [ -f "docker-compose.yml" ]; then
  echo "O arquivo docker-compose.yml já existe"
else
  cp docker-compose.example.yml docker-compose.yml
  echo "docker-compose.yml is created"
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
  docker volume create --driver local --opt type=none --opt device=$(pwd)/laravel --opt o=bind laravel > /dev/null 2>&1;
  echo "O volume laravel foi criado"
fi

echo ""

docker-compose up -d