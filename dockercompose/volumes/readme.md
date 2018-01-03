
# Docker Compose Volumes

- https://docs.docker.com/compose/compose-file/#volume-configuration-reference

# Volume configuration reference

While it is possible to declare volumes on the file as part of the service
declaration, this section allows you to create named volumes (without relying
on volumes_from) that can be reused across multiple services, and are easily
retrieved and inspected using the docker command line or API. See the docker
volume subcommand documentation for more information.

See Use volumes and Volume Plugins for general information on volumes.

Here’s an example of a two-service setup where a database’s data directory is
shared with another service as a volume so that it can be periodically backed
up:

```
	version: "3"

	services:
	  db:
	    image: postgres
	    volumes:
	      - data:/var/lib/postgresql/data
	  backup:
	    image: nginx
	    volumes:
	      - data:/var/lib/backup/data

	volumes:
	  data:
```

An entry under the top-level volumes key can be empty, in which case it will
use the default driver configured by the Engine (in most cases, this is the
local driver). Optionally, you can configure it with the following keys:

## driver

Specify which volume driver should be used for this volume. Defaults to
whatever driver the Docker Engine has been configured to use, which in most
cases is local. If the driver is not available, the Engine will return an
error when docker-compose up tries to create the volume.

	 driver: foobar

## driver_opts

Specify a list of options as key-value pairs to pass to the driver for this
volume. Those options are driver-dependent - consult the driver’s
documentation for more information. Optional.

	 driver_opts:
	   foo: "bar"
	   baz: 1

## external

If set to true, specifies that this volume has been created outside of
Compose. docker-compose up will not attempt to create it, and will raise an
error if it doesn’t exist.

external cannot be used in conjunction with other volume configuration keys
(driver, driver_opts).

	In the example below, instead of attempting to create a volume called
	[projectname]_data, Compose will look for an existing volume simply called
	data and mount it into the db service’s containers.

```
version: '2'

services:
  db:
    image: postgres
    volumes:
      - data:/var/lib/postgresql/data

volumes:
  data:
    external: true
```

You can also specify the name of the volume separately from the name used to
refer to it within the Compose file:

```
volumes:
  data:
    external:
      name: actual-name-of-volume
```


## external volumes and docker stacks


External volumes are always created with docker stack deploy

External volumes that do not exist will be created if you use docker stack
deploy to launch the app in swarm mode (instead of docker compose up). In
swarm mode, a volume is automatically created when it is defined by a service.
As service tasks are scheduled on new nodes, swarmkit creates the volume on
the local node. To learn more, see moby/moby#29976.





