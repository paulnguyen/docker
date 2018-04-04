
start:
	minikube start 

stop:
	minikube stop

list:
	kubectl get pods --all-namespaces

cluster:
	kubectl cluster-info

gui:
	minikube dashboard

nodes:
	kubectl get nodes

docker-env:
	minikube docker-env

docker-set:
	echo "eval $(minikube docker-env)"
	
docker-unset:
	echo "eval $(minikube docker-env -u)"

docker-images:
	docker images

list-deployments:
	kubectl get deployments

check-api:
	curl http://localhost:8001/api/v1/proxy/namespaces/default/pods/kubernetes-bootcamp/

proxy:
	kubectl proxy

help-list-resources:
	kubectl get --help

help-show-resource:
	kubectl describe --help

help-container-logs:
	kubectl logs --help

help-container-cmd:
	kubectl exec --help



