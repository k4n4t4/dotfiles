% docker cheat

# build image
docker build -t <image_name> .


# run container
docker run -it --name <container_name> <image_name>

# run temporary container
docker run -it --rm --name <container_name> <image_name>


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

$ engine: command -v docker >/dev/null 2>&1 && echo docker || echo podman
$ image_name: <engine> images | awk 'NR>1 {print $3}'
$ container_name: <engine> ps -a | awk 'NR>1 {print $1}'
