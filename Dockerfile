FROM alpine:3.17.0
MAINTAINER crossRT <crossRT@gmail.com>
LABEL maintainer="crossRT"
LABEL description="This container image includes useful tools for jenkins, argocd and kubernetes setup."

COPY --from=k8s.gcr.io/kustomize/kustomize:v4.5.7 /app/kustomize /usr/bin/kustomize

RUN apk add --no-cache git openssh-client

RUN addgroup -S jenkins --gid 1000 && adduser -S jenkins -G jenkins -u 1000

USER jenkins
