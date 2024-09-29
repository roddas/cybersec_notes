path "kv/homologacao/maquinas/produto/*" {
  capabilities = ["read", "list"]
}

path "kv/producao/maquinas/produto/*" {
  capabilities = ["read", "list"]
}

path "kv/usuarios/produto/{{identity.entity.name}}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
  capabilities = ["create", "update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}