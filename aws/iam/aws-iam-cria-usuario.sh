#!/bin/bash
# Proposito: Automatiza a criação de usuários na AWS
# Utilizacao: ./aws-iam-cria-usuario.sh <formato arquivo entrada .csv>
# Formato do arquivo de entrada: usuarios,grupo,senha
# Autor: Jean Rodrigues
# ------------------------------------------

INPUT=$1
OLDIFS=$IFS

IFS=;

[ ! -f $INPUT ] && { echo "$INPUT arquivo nao encontrado"; exit 99; }


while IFS=; read -r linha || [[ -n "$linha" ]]
do
    if [ $linha != 'usuarios;grupo;senha' ] 
    then
        user="$(cut -d';' -f1 <<<"$linha")"
        group="$(cut -d';' -f2 <<<"$linha")"
        pwd="$(cut -d';' -f3 <<<"$linha")"
        if [ $user != "usuarios" ]
        then
            aws iam create-user --user-name  $user
            aws iam add-user-to-group --user-name $user --group-name $group
            sleep 1
            aws iam create-login-profile --password-reset-required --user-name $user --password "JAbIK]U7!0)PW"
        fi
	fi
done < $INPUT


IFS=$OLDIFS
