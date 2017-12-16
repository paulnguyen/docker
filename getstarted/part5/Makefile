
init:
	docker swarm init

run:
	docker stack deploy -c docker-compose.yml getstartedlab

ps:
	docker stack ps getstartedlab

services:
	docker service ls

stacks:
	docker stack ls

images:
	docker images

tasks:
	docker service ps getstartedlab_web

containers:
	docker container ls 

visualizer:
	curl http://localhost:8080

test:
	curl -4 http://localhost 

down:
	docker stack rm getstartedlab

leave:
	docker swarm leave --force


	
