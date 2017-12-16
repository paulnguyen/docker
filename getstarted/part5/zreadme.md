



	  ____             _                ____      _     ____  _             _           _ 
	 |  _ \  ___   ___| | _____ _ __   / ___| ___| |_  / ___|| |_ __ _ _ __| |_ ___  __| |
	 | | | |/ _ \ / __| |/ / _ \ '__| | |  _ / _ \ __| \___ \| __/ _` | '__| __/ _ \/ _` |
	 | |_| | (_) | (__|   <  __/ |    | |_| |  __/ |_   ___) | || (_| | |  | ||  __/ (_| |
	 |____/ \___/ \___|_|\_\___|_|     \____|\___|\__| |____/ \__\__,_|_|   \__\___|\__,_|
	                                                                                      



# Resources

https://docs.docker.com/get-started/


# Get Started, Part 5: Stacks

Introduction

In part 4, you learned how to set up a swarm, which is a cluster of machines
running Docker, and deployed an application to it, with containers running in
concert on multiple machines.

Here in part 5, you’ll reach the top of the hierarchy of distributed
applications: the stack. A stack is a group of interrelated services that
share dependencies, and can be orchestrated and scaled together. A single
stack is capable of defining and coordinating the functionality of an entire
application (though very complex applications may want to use multiple
stacks).

Some good news is, you have technically been working with stacks since part 3,
when you created a Compose file and used docker stack deploy. But that was a
single service stack running on a single host, which is not usually what takes
place in production. Here, you will take what you’ve learned, make multiple
services relate to each other, and run them on multiple machines.

You’re doing great, this is the home stretch!


# docker-compose.yml (Web + Visualizer)

	version: "3"
	services:
	  web:
	    image: paulnguyen/get-started:part2
	    deploy:
	      replicas: 5
	      restart_policy:
	        condition: on-failure
	      resources:
	        limits:
	          cpus: "0.1"
	          memory: 50M
	    ports:
	      - "80:80"
	    networks:
	      - webnet
	  visualizer:
	    image: dockersamples/visualizer:stable
	    ports:
	      - "8080:8080"
	    volumes:
	      - "/var/run/docker.sock:/var/run/docker.sock"
	    deploy:
	      placement:
	        constraints: [node.role == manager]
	    networks:
	      - webnet
	networks:
	  webnet:


The only thing new here is the peer service to web, named visualizer. You’ll
see two new things here: a volumes key, giving the visualizer access to the
host’s socket file for Docker, and a placement key, ensuring that this service
only ever runs on a swarm manager – never a worker. That’s because this
container, built from an open source project created by Docker, displays
Docker services running on a swarm in a diagram.

We’ll talk more about placement constraints and volumes in a moment.


# docker-compose.yml (Web + Visualizer + Redis)

	version: "3"
	services:
	  web:
	    image: upaulnguyen/get-started:part2
	    deploy:
	      replicas: 5
	      restart_policy:
	        condition: on-failure
	      resources:
	        limits:
	          cpus: "0.1"
	          memory: 50M
	    ports:
	      - "80:80"
	    networks:
	      - webnet
	  visualizer:
	    image: dockersamples/visualizer:stable
	    ports:
	      - "8080:8080"
	    volumes:
	      - "/var/run/docker.sock:/var/run/docker.sock"
	    deploy:
	      placement:
	        constraints: [node.role == manager]
	    networks:
	      - webnet
	  redis:
	    image: redis
	    ports:
	      - "6379:6379"
	    volumes:
	      - /home/docker/data:/data
	    deploy:
	      placement:
	        constraints: [node.role == manager]
	    command: redis-server --appendonly yes
	    networks:
	      - webnet
	networks:
	  webnet:



Redis has an official image in the Docker library and has been granted the
short image name of just redis, so no username/repo notation here. The Redis
port, 6379, has been pre-configured by Redis to be exposed from the container
to the host, and here in our Compose file we expose it from the host to the
world, so you can actually enter the IP for any of your nodes into Redis
Desktop Manager and manage this Redis instance, if you so choose.

Most importantly, there are a couple of things in the redis specification that
make data persist between deployments of this stack:

    redis always runs on the manager, so it’s always using the same
    filesystem.
    
    redis accesses an arbitrary directory in the host’s file system as /data
    inside the container, which is where Redis stores data.

Together, this is creating a “source of truth” in your host’s physical
filesystem for the Redis data. Without this, Redis would store its data in
/data inside the container’s filesystem, which would get wiped out if that
container were ever redeployed.

This source of truth has two components:

    The placement constraint you put on the Redis service, ensuring that it
    always uses the same host.

    The volume you created that lets the container access ./data (on the host)
    as /data (inside the Redis container). While containers come and go, the
    files stored on ./data on the specified host will persist, enabling
    continuity.

You are ready to deploy your new Redis-using stack.

