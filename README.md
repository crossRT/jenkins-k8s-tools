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

## Jenkinsfile example
```
pipeline {
    agent any

    stages {

        stage('Build') {
            // build your project
        }
        
        stage('Update manifest') {
            // use the image for this stage
            agent {
                docker {
                    image 'crossrt/jenkins-k8s-tools:latest'
                }
            }
            
            steps {
                // pull your deployment repo
                git credentialsId: 'jenkins-server-ssh', poll: false, url: "$DEPLOYMENT_REPO_URI", branch: "$DEPLOYMENT_REPO_BRANCH"

                // change directory to locate the kustomization.yaml
                dir("base") {
                    // `kustomize` will be available here
                    sh 'kustomize edit set image $IMAGE_TAG:$GIT_COMMIT'
                }

                // after you update kustomization.yaml, you will need to push it back to your repository
                // so here we passing the SSH key into the container through ssh-agent.
                sshagent (credentials: ['jenkins-server-ssh']) {
                    // do what every git stuff here you want
                    sh 'git config user.email "jenkins@example.com"'
                    sh 'git config user.name "Jenkins"'
                    sh 'git branch --set-upstream-to origin/$DEPLOYMENT_REPO_BRANCH'
                    sh 'git config --global core.sshCommand "ssh -o StrictHostKeyChecking=accept-new"'

                    // lastly, commit and push your deployment repo
                    sh 'git commit -am "$REPO_NAME updated: $GIT_COMMIT" && git push || echo "no changes"'
                }
            }
        }
    }
}

```