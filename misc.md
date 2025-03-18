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
Aplicação simplems com load balancer
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubenews
spec:
  replicas: 2
  selector:
    matchLabels:
      app: kubenews
  template:
    metadata:
      labels:
        app: kubenews
    spec:
      containers:
      - name: kubenews
        image: roddascabral/aula-kube-news:v1
        ports:
        - containerPort: 8080
          name: kubenews-port
        env:
          - name: DB_USERNAME
            value: "pguser"
          - name: DB_HOST
            value: "postgres"
          - name: DB_PASSWORD
            value: "pgpass"
          - name: DB_DATABASE
            value: "pgdb"
---
apiVersion: v1
kind: Service
metadata:
  name: kubenews
spec:
  selector:
    app: kubenews
  ports:
  - port: 8080 # Dentro do Cluster
    targetPort: kubenews-port # Quando receber a requisição na 80, reencaminha para a porta do container
  type: LoadBalancer

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15.0
        ports:
        - containerPort: 5432
        env:
          - name: POSTGRES_USER
            value: "pguser"
          - name: POSTGRES_PASSWORD
            value: "pgpass"
          - name: POSTGRES_DB
            value: "pgdb"
---
apiVersion: v1
kind: Service
metadata:
  name: postgres
spec:
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
```

