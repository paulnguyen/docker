



	  ____             _                ____      _     ____  _             _           _ 
	 |  _ \  ___   ___| | _____ _ __   / ___| ___| |_  / ___|| |_ __ _ _ __| |_ ___  __| |
	 | | | |/ _ \ / __| |/ / _ \ '__| | |  _ / _ \ __| \___ \| __/ _` | '__| __/ _ \/ _` |
	 | |_| | (_) | (__|   <  __/ |    | |_| |  __/ |_   ___) | || (_| | |  | ||  __/ (_| |
	 |____/ \___/ \___|_|\_\___|_|     \____|\___|\__| |____/ \__\__,_|_|   \__\___|\__,_|
	                                                                                      



# Resources

https://docs.docker.com/get-started/


# Get Started, Part 1: Orientation and setup

	Containers can share a single kernel, and the only information that needs
	to be in a container image is the executable and its package dependencies,
	which never need to be installed on the host system. These processes run
	like native processes, and you can manage them individually by running
	commands like docker ps—just like you would run ps on Linux to see active
	processes. Finally, because they contain all their dependencies, there is
	no configuration entanglement; a containerized app “runs anywhere.”


# Get Started, Part 2: Containers

	Your new development environment

	In the past, if you were to start writing a Python app, your first order
	of business was to install a Python runtime onto your machine. But, that
	creates a situation where the environment on your machine has to be just
	so in order for your app to run as expected; ditto for the server that
	runs your app.

	With Docker, you can just grab a portable Python runtime as an image, no
	installation necessary. Then, your build can include the base Python image
	right alongside your app code, ensuring that your app, its dependencies,
	and the runtime, all travel together.

	These portable images are defined by something called a Dockerfile.

	Dockerfile:

		# Use an official Python runtime as a parent image
		FROM python:2.7-slim

		# Set the working directory to /app
		WORKDIR /app

		# Copy the current directory contents into the container at /app
		ADD . /app

		# Install any needed packages specified in requirements.txt
		RUN pip install --trusted-host pypi.python.org -r requirements.txt

		# Make port 80 available to the world outside this container
		EXPOSE 80

		# Define environment variable
		ENV NAME World

		# Run app.py when the container launches
		CMD ["python", "app.py"]


	Proxy servers can block connections to your web app once it’s up and
	running. If you are behind a proxy server, add the following lines to your
	Dockerfile, using the ENV command to specify the host and port for your
	proxy servers:

    # Set proxy server, replace host:port with values for your servers     
    ENV http_proxy host:port     
    ENV https_proxy host:port


	docker build -t friendlyname .  # Create image using this directory's Dockerfile
	docker run -p 4000:80 friendlyname  # Run "friendlyname" mapping port 4000 to 80
	docker run -d -p 4000:80 friendlyname         # Same thing, but in detached mode
	docker container ls                                # List all running containers
	docker container ls -a             # List all containers, even those not running
	docker container stop <hash>           # Gracefully stop the specified container
	docker container kill <hash>         # Force shutdown of the specified container
	docker container rm <hash>        # Remove specified container from this machine
	docker container rm $(docker container ls -a -q)         # Remove all containers
	docker image ls -a                             # List all images on this machine
	docker image rm <image id>            # Remove specified image from this machine
	docker image rm $(docker image ls -a -q)   # Remove all images from this machine
	docker login             # Log in this CLI session using your Docker credentials
	docker tag <image> username/repository:tag  # Tag <image> for upload to registry
	docker push username/repository:tag            # Upload tagged image to registry
	docker run username/repository:tag                   # Run image from a registry


# Get Started, Part 3: Services



# Get Started, Part 4: Swarms



# Get Started, Part 5: Stacks



# Get Started, Part 6: Deploy your app



# Get Started, Part 7: Docker Networking

https://docs.docker.com/engine/tutorials/networkingcontainers/




