storage "raft" {
   path    = ".vault/data"
   node_id = "node1"
}

listener "tcp" {
   address     = "0.0.0.0:8200"
   tls_disable = false
   tls_cert_file = "/opt/vault/tls/tls.crt" 
   tls_key_file = "/opt/vault/tls/tls.key" 
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
disable_mlock = true
ui = true
