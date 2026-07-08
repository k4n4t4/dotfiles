% docker

# build image
docker build -t <image_name> .


# run container
docker run -it --name <new_container_name> <image_name>

# run temporary container
docker run -it --rm --name <new_container_name> <image_name>


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

$ engine: command -v docker >/dev/null 2>&1 && echo docker || echo podman
$ image_name: <engine> images --- --header-lines 1 --map "awk '{print \$3}'"
$ container_name: <engine> ps -a --- --header-lines 1 --map "awk '{print \$1}'"
