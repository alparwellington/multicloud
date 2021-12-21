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
        if [ $user != "usuarios" ]
        then
        	aws iam delete-login-profile --user-name $user
            aws iam remove-user-from-group --group-name $group --user-name $user
            aws iam delete-user --user-name $user
        fi
	fi
done < $INPUT


IFS=$OLDIFS
