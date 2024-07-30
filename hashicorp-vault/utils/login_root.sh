#!/bin/bash

vault login $(grep 'Initial Root Token:' vault_init.txt | awk '{print $NF}')