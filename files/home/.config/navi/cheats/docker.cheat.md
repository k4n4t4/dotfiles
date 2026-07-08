% docker

# build image
docker build -t <new_image_name> .


# run container
docker run -it --name <new_container_name> <image_name>

# run temporary container
docker run -it --rm --name <new_container_name> <image_name>

# run container with volume
docker run -it --name <new_container_name> -v <host_path>:<container_path> <image_name>

# run temporary container with volume
docker run -it --rm --name <new_container_name> -v <host_path>:<container_path> <image_name>

# attach to running container
docker exec -it <container_name>

# attach to running container with shell
docker exec -it <container_name> <command>

# start container
docker start -ai <container_name>

# restart container
docker restart <container_name>


# list containers
docker ps -a

# list running containers
docker ps

# list images
docker images


# stop container
docker stop <container_name>


# remove container
docker rm <container_name>

# remove container forcefully
docker rm -f <container_name>

# remove all stopped containers
docker container prune


# remove image
docker rmi <image_name>

# remove image forcefully
docker rmi -f <image_name>

# remove all unused images
docker image prune


$ host_path: ls -1a
$ command: bash
$ engine: command -v docker >/dev/null 2>&1 && echo docker || echo podman
$ image_name: <engine> images --- --header-lines 1 --map "awk '{print \$3}'"
$ container_name: <engine> ps -a --- --header-lines 1 --map "awk '{print \$1}'"
