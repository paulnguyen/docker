



	  ____             _                ____      _     ____  _             _           _ 
	 |  _ \  ___   ___| | _____ _ __   / ___| ___| |_  / ___|| |_ __ _ _ __| |_ ___  __| |
	 | | | |/ _ \ / __| |/ / _ \ '__| | |  _ / _ \ __| \___ \| __/ _` | '__| __/ _ \/ _` |
	 | |_| | (_) | (__|   <  __/ |    | |_| |  __/ |_   ___) | || (_| | |  | ||  __/ (_| |
	 |____/ \___/ \___|_|\_\___|_|     \____|\___|\__| |____/ \__\__,_|_|   \__\___|\__,_|
	                                                                                      



# Resources

https://docs.docker.com/get-started/


# Get Started, Part 3: Services

## Introduction

In part 3, we scale our application and enable load-balancing. To do this, we
must go one level up in the hierarchy of a distributed application: the
service.

    Stack
    Services (you are here)
    Container (covered in part 2)


## About services

Services are really just “containers in production.” A service only runs one
image, but it codifies the way that image runs—what ports it should use, how
many replicas of the container should run so the service has the capacity it
needs, and so on. Scaling a service changes the number of container instances
running that piece of software, assigning more computing resources to the
service in the process.


## Docker Compose YAML File

A docker-compose.yml file is a YAML file that defines how Docker containers
should behave in production.

	version: "3"
	services:
	  web:
	    # replace username/repo:tag with your name and image details
	    image: paulnguyen/get-started:part2
	    deploy:
	      replicas: 5
	      resources:
	        limits:
	          cpus: "0.1"
	          memory: 50M
	      restart_policy:
	        condition: on-failure
	    ports:
	      - "80:80"
	    networks:
	      - webnet
	networks:
	  webnet:

## This docker-compose.yml file tells Docker to do the following:

1. Pull the image we uploaded in step 2 from the registry.

2. Run 5 instances of that image as a service called web, limiting each one to
   use, at most, 10% of the CPU (across all cores), and 50MB of RAM.

3. Immediately restart containers if one fails.

4. Map port 80 on the host to web’s port 80.

5. Instruct web’s containers to share port 80 via a load-balanced network
   called webnet. (Internally, the containers themselves will publish to web’s
   port 80 at an ephemeral port.)

6. Define the webnet network with the default settings (which is a load-
   balanced overlay network).


## Run your new load-balanced app

	Before we can use the docker stack deploy command we’ll first run:

		docker swarm init

	Now let’s run it. You have to give your app a name. Here, it is set to getstartedlab:


## Scale the app

	You can scale the app by changing the replicas value in docker-compose.yml,
	saving the change, and re-running the docker stack deploy command:

		docker stack deploy -c docker-compose.yml getstartedlab

	Docker will do an in-place update, no need to tear the stack down first or
	kill any containers.

	Now, re-run docker container ls -q to see the deployed instances
	reconfigured. If you scaled up the replicas, more tasks, and hence, more
	containers, are started.

## Commands

	To recap, while typing docker run is simple enough, the true implementation of
	a container in production is running it as a service. Services codify a
	container’s behavior in a Compose file, and this file can be used to scale,
	limit, and redeploy our app. Changes to the service can be applied in place,
	as it runs, using the same command that launched the service: docker stack
	deploy.

Some commands to explore at this stage:

docker stack ls                                            # List stacks or apps
docker stack deploy -c <composefile> <appname>  # Run the specified Compose file
docker service ls                 # List running services associated with an app
docker service ps <service>                  # List tasks associated with an app
docker inspect <task or container>                   # Inspect task or container
docker container ls -q                                      # List container IDs
docker stack rm <appname>                             # Tear down an application
docker swarm leave --force      # Take down a single node swarm from the manager





