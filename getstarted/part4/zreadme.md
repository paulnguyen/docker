



	  ____             _                ____      _     ____  _             _           _ 
	 |  _ \  ___   ___| | _____ _ __   / ___| ___| |_  / ___|| |_ __ _ _ __| |_ ___  __| |
	 | | | |/ _ \ / __| |/ / _ \ '__| | |  _ / _ \ __| \___ \| __/ _` | '__| __/ _ \/ _` |
	 | |_| | (_) | (__|   <  __/ |    | |_| |  __/ |_   ___) | || (_| | |  | ||  __/ (_| |
	 |____/ \___/ \___|_|\_\___|_|     \____|\___|\__| |____/ \__\__,_|_|   \__\___|\__,_|
	                                                                                      



# Resources

https://docs.docker.com/get-started/


# Get Started, Part 4: Swarms

A swarm is a group of machines that are running Docker and joined into a
cluster. After that has happened, you continue to run the Docker commands
you’re used to, but now they are executed on a cluster by a swarm manager. The
machines in a swarm can be physical or virtual. After joining a swarm, they
are referred to as nodes.

Swarm managers can use several strategies to run containers, such as “emptiest
node” – which fills the least utilized machines with containers. Or “global”,
which ensures that each machine gets exactly one instance of the specified
container. You instruct the swarm manager to use these strategies in the
Compose file, just like the one you have already been using.

Swarm managers are the only machines in a swarm that can execute your
commands, or authorize other machines to join the swarm as workers. Workers
are just there to provide capacity and do not have the authority to tell any
other machine what it can and cannot do.

Up until now, you have been using Docker in a single-host mode on your local
machine. But Docker also can be switched into swarm mode, and that’s what
enables the use of swarms. Enabling swarm mode instantly makes the current
machine a swarm manager. From then on, Docker will run the commands you
execute on the swarm you’re managing, rather than just on the current machine.





