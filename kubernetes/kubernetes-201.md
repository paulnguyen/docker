

	  _  __     _                          _            
	 | |/ /    | |                        | |           
	 | ' /_   _| |__   ___ _ __ _ __   ___| |_ ___  ___ 
	 |  <| | | | '_ \ / _ \ '__| '_ \ / _ \ __/ _ \/ __|
	 | . \ |_| | |_) |  __/ |  | | | |  __/ ||  __/\__ \
	 |_|\_\__,_|_.__/ \___|_|  |_| |_|\___|\__\___||___/
	                                                    
                                                                                        

# Kubernetes 201 

* https://kubernetes-v1-4.github.io/docs/user-guide/

# Labels

Having already learned about Pods and how to create them, you may be struck by
an urge to create many, many Pods. Please do! But eventually you will need a
system to organize these Pods into groups. The system for achieving this in
Kubernetes is Labels. Labels are key-value pairs that are attached to each
object in Kubernetes. Label selectors can be passed along with a RESTful list
request to the apiserver to retrieve a list of objects which match that label
selector.

To add a label, add a labels section under metadata in the Pod definition:

```
 labels:
    app: nginx
```

For example, here is the nginx Pod definition with labels 

## pod-labels.yaml

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
```

## Create the labeled Pod

	kubectl create -f pod-labels.yaml

## List all Pods with the label app=nginx

	kubectl get pods -l app=nginx

## Delete the Pod by label:

	kubectl delete pod -l app=nginx

For more information, see Labels. They are a core concept used by two
additional Kubernetes building blocks: Deployments and Services.

* https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/


# Deployments





