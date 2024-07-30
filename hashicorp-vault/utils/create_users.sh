#!/bin/bash

regex=1234567890abcdefghijklmnopqrstuvxwyzABCDEFGHIJKLMNOPQRSTUVXWYZ
file=file.txt

while read -r line
do
    tmp=( $(echo $line | sed "s/PASS/$(makepasswd --chars 15 --string $regex)/") )
	user=${tmp[0]}
	password=${tmp[1]}
	group=${tmp[2]}

    vault write auth/users-$group/users/$user password="$password" policies="$group"

    echo "$user $password $group" >> vault_users.txt
done < "$file"


# https://developer.hashicorp.com/vault/tutorials/auth-methods/identity?variants=vault-deploy%3Aselfhosted