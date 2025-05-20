# Misc notes
## Useful tools
 * [git-dumper](https://github.com/arthaud/git-dumper)

## DNS Lookup

To perform a DNS lookup, open the terminal and type:
```
dnsrecon -d [site]
```
[
Living Off The Land Binaries, Scripts and Libraries](https://lolbas-project.github.io/)

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
k3d cluster create meucluster --servers 3 --agents 3 -p "8080:8080@loadbalancer"
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
  name: simulador
spec:
  replicas: 2
  selector:
    matchLabels:
      app: simulador
  template:
    metadata:
      labels:
        app: simulador
    spec:
      restartPolicy: Always
      containers:
      - name: simulador
        imagePullPolicy: IfNotPresent
        image: kubedevio/simulador-do-caos:v1
        ports:
        - containerPort: 3000
          name: simulador-port
        livenessProbe:
          httpGet:
            port: 3000
            path: /health # Implementar endpoint de healthcheck (conexão com os outros componentes da aplicação)
          initialDelaySeconds: 5 
          periodSeconds: 10
          failureThreshold: 3
          successThreshold: 1
          timeoutSeconds: 3
---
apiVersion: v1
kind: Service
metadata:
  name: simulador
spec:
  selector:
    app: simulador
  ports:
  - port: 8080 # Dentro do Cluster
    targetPort: simulador-port # Quando receber a requisição na 80, reencaminha para a porta do container
  type: LoadBalancer
```

