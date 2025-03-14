# Misc notes

## DNS Lookup

To perform a DNS lookup, open the terminal and type:
```
dnsrecon -d [site]
```


## Kubernetes

Criar um cluster com 3 servidores e 3 agentes e configurar o port bind para o load balancer
```
k3d cluster create meucluster --servers 3 --agents 3 -p "30000:30000@loadbalancer"
```

Aplicar modificações e acompanhar as mudanças
```
kubectl apply -f deployment.yaml && watch 'kubectl get po'
```

Voltar a última versão
```
kubectl rollout undo deploy meudeployment && watch 'kubectl get deploy,rs,po'
```

## PARA FAZER DEPLOY LOCAL

1 - Criar o cluster:
```
k3d cluster create meucluster --servers 3 --agents 3 -p "30000:30000@loadbalancer"
```

2 - Criar a imagem Docker (já deve estar publicada em algum Docker Regisry)
```
docker  build -t roddascabral/conversao-temperatura:v1 . --push
```
3 - Criar o manifesto
```
kubectl api-resources # para saber quais versões utilizar
``` 
