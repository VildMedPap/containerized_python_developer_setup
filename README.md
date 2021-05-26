# Containerized Python developer setup

## Usage

### For production

Build:

```shell
docker build -t mypythonapp:prod .
```

Run:

```shell
docker run --rm --name pythonapp mypythonapp:prod
```

### For development

Build:

```shell
docker build -t mypythonapp:dev --target dev .
```

Run:

```shell
docker run --rm --volume ${PWD}:/app --publish 8888:8888 --name pythonapp mypythonapp:dev
```
