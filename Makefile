DOCKER_REPO=tnwhitwell/docker-sslh
IMAGE_NAME=${DOCKER_REPO}:latest

build:
	IMAGE_NAME=${IMAGE_NAME} bash hooks/build

push:
	IMAGE_NAME=${IMAGE_NAME} DOCKER_REPO=${DOCKER_REPO} bash hooks/post_push

update-pipeline:
	fly -t mine set-pipeline -c concourse/pipelines/update_submodule.yml -p docker-sslh

run-pipeline:
	fly -t mine trigger-job -j docker-sslh/update_submodule
