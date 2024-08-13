#!/bin/bash -x
# Variáveis
HOST="10.10.0.74" USER="enzo" PASSWORD="babyshark"
#FILE="arquivo-01"
#FILE2="arquivo-02"
FILE3="arquivo-03"
# Sequência de comandos a ser executada
#incluir=$(cat "$FILE")
#incluir=$(cat "$FILE2")
incluir2=$(cat "$FILE3")
# Executar comandos usando sshpass e ssh
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USER@$HOST" "$incluir2"
