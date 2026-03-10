# pulumi_with_python3

## DIY python3 and pulumi tools with Dockerfile

* But you can simply use Dockerfile provided from [Docker hub/pulumi/pulumi-python](https://hub.docker.com/r/pulumi/pulumi-python)

```shell
#build
docker build -f Dockerfile.pulumi_with_python -t iac-pulumi-python3:latest .
#run
docker run -d --name iac-pulumi-python3 iac-pulumi-python3:latest
#exec
docker exec -it iac-pulumi-python3 bash
```