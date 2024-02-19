# doceker tools

Dockerfile.mysql57

* [How to set password with debconf-set-selections](https://github.com/docker-library/mysql/blob/9678ed1d27794ae9529c43b4411e30f981ce39ea/template/Dockerfile.debian)

```shell
docker build -f Dockerfile.mysql57 -t local:2204 .
docker run -it --name test local:2204
```