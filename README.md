Pre-requisites:
kubectl create secret generic regcred \
 --from-file=/home/markm/.docker/config.json

When in buildkitd pod;

```bash
buildctl --addr unix:///run/buildkit/buildkitd.sock build \
--frontend dockerfile.v0 \
--local context=. \
--local dockerfile=. \
--output type=image,name=docker.io/mjmammoth/devpod:v1.2,push=true
```
