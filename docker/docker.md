# doceker tools

Dockerfile.mysql57

* [How to set password with debconf-set-selections](https://github.com/docker-library/mysql/blob/9678ed1d27794ae9529c43b4411e30f981ce39ea/template/Dockerfile.debian)
* [debconf-show mysql-server-5.7](https://unix.stackexchange.com/questions/457388/how-to-find-out-the-variable-names-for-debconf-set-selections)

```shell
docker build -f Dockerfile.mysql57 -t local:2204 .
docker run -it --name test local:2204

docker build -f Dockerfile.ansible -t devops:v0.1 .
docker run -it --name devops devops:v0.1
```