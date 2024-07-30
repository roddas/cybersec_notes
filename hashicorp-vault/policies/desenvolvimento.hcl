path "kv/homologacao/maquinas/desenvolvimento/*" {
  capabilities = ["read", "list"]
}

path "kv/producao/maquinas/desenvolvimento/*" {
  capabilities = ["read", "list"]
}

path "kv/usuarios/desenvolvimento/{{identity.entity.name}}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
  capabilities = ["create", "update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}