#!/bin/bash

regex=1234567890abcdefghijklmnopqrstuvxwyzABCDEFGHIJKLMNOPQRSTUVXWYZ
file=file.txt

while read -r line
do
    tmp=( $(echo $line | sed "s/PASS/$(makepasswd --chars 15 --string $regex)/") )
	user=${tmp[0]}
	password=${tmp[1]}
	group=${tmp[2]}

    vault delete auth/users-$group/users/$user

done < "$file"

rm vault_users.txt
# vault auth disable users-admin
# vault auth disable users-dev
# vault auth disable users-dados
# vault auth disable users-infra
# vault auth disable users



# https://developer.hashicorp.com/vault/tutorials/auth-methods/identity?variants=vault-deploy%3Aselfhosted