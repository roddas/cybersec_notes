# Política para Infraestrutura
path "kv/homologacao/maquinas/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/producao/maquinas/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/usuarios/infra/{{identity.entity.name}}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
  capabilities = ["create", "update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}
