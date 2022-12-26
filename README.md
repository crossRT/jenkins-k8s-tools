# jenkins-k8s-tools
This container image includes useful tools for jenkins, argocd and kubernetes setup.

[![Docker Pulls](https://img.shields.io/docker/pulls/crossrt/jenkins-k8s-tools)](https://hub.docker.com/r/crossrt/jenkins-k8s-tools)

## What's in the image:
- alpine:3.17.0
- kustomize:4.5.7
- git:2.38.2
- ssh-agent

## Why create this image?
I use Jenkins as continuous integration (CI), and ArgoCD as continuous deployment (CD) for most of my projects.
To practice GitOps, I need Jenkins to write the latest container image tag into single source of truth.
And then I need to commit what have been changed with a human readable message, and push it to remote via SSH protocol.

## To use the image once
```
docker run --rm -it --entrypoint sh crossrt/jenkins-k8s-tools
```
