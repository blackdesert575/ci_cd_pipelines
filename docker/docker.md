# doceker tools

## Dockerfile.mysql57

* [How to set password with debconf-set-selections](https://github.com/docker-library/mysql/blob/9678ed1d27794ae9529c43b4411e30f981ce39ea/template/Dockerfile.debian)
* [debconf-show mysql-server-5.7](https://unix.stackexchange.com/questions/457388/how-to-find-out-the-variable-names-for-debconf-set-selections)

```shell
docker build -f Dockerfile.mysql57 -t local:2204 .
docker run -it --name test local:2204
```

## provisioning

* ansible

```shell
docker build -f Dockerfile.devops -t devops:v0.1 .
docker run -it --name devops devops:v0.1
```

## docker compose-file spec...etc

* [compose-file/build/#using-build-and-image](https://docs.docker.com/reference/compose-file/build/#using-build-and-image)
* [environment-variables/variable-interpolation/#env-file](https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/#env-file)