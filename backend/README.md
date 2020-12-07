# DHBW Mastermind
<p align="center">
  <sub>Made with ❤️ by <a href="https://github.com/derbl4ck">derbl4ck</a></sub>
</p>

## ❯ Table of Contents

- [Getting Started](#-getting-started)
- [Authentication](#-authentication)
- [Docker](#-docker)
- [Further Documentations](#-further-documentation)

![divider](./readme/divider.png)

## ❯ Getting Started

### Step 1: Set up the Development Environment

You need to set up your development environment before you can do anything.

Install [Node.js and NPM](https://nodejs.org/en/download/)

- on OSX use [homebrew](http://brew.sh) `brew install node`
- on Windows use [chocolatey](https://chocolatey.org/) `choco install nodejs`

Install yarn globally

```bash
yarn install yarn -g
```

Install a MongoDB database.

```
docker run -v /my/own/datadir:/data/db --name MastermindDB \
    -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
    -e MONGO_INITDB_ROOT_PASSWORD=secret \
    -p 27017:27017 \
    mongo
```

> If you work with a mac, I recommend to use homebrew for the installation.

### Step 2: Change Settings

Fork or download this project. Add your database connection information in the `.env` file.

```bash
yarn run presetup
```

> This installs all dependencies with yarn. Your development environment is now ready to use.

### Step 3: Serve your Mastermind

Go to the project dir and start your Mastermind with this yarn script.

```bash
yarn start start:prod
```

![divider](./readme/divider.png)

## ❯ Authentication
 
This application uses JSON Web Token (JWT) to handle authentication. The token is passed with each request using the `Authorization` header with `Token` scheme. The JWT authentication middleware handles the validation and authentication of the token.

![divider](./readme/divider.png)

## ❯ Docker

### Install Docker

Before you start, make sure you have a recent version of [Docker](https://docs.docker.com/engine/installation/) installed

### Build Docker image

```shell
docker build -t <your-image-name> .
```

### Run Docker image in container and map port

The port which runs your application inside Docker container is either configured as `APP_PORT` property in your `.env` configuration file or passed to Docker container via environment variable `APP_PORT`. Default port is `3000`.

#### Run image in detached mode

```shell
docker run -d -p <port-on-host>:<port-inside-docker-container> <your-image-name>
```

#### Run image in foreground mode

```shell
docker run -i -t -p <port-on-host>:<port-inside-docker-container> <your-image-name>
```

### Stop Docker container

#### Detached mode

```shell
docker stop <container-id>
```

You can get a list of all running Docker container and its ids by following command

```shell
docker images
```

#### Foreground mode

Go to console and press <CTRL> + C at any time.

### Docker environment variables

There are several options to configure your app inside a Docker container

#### project .env file

You can use `.env` file in project root folder which will be copied inside Docker image. If you want to change a property inside `.env` you have to rebuild your Docker image.

#### run options

You can also change app configuration by passing environment variables via `docker run` option `-e` or `--env`.

```shell
docker run --env TYPEORM_HOST=localhost -e TYPEORM_PORT=27017
```

#### environment file

Last but not least you can pass a config file to `docker run`.

```shell
docker run --env-file ./readme/env.list
```

`env.list` example:

```
# this is a comment
TYPEORM_CONNECTION=mongodb
TYPEORM_HOST=localhost
TYPEORM_PORT=27017
```

![divider](./readme/divider.png)

## ❯ Further Documentations

| Name & Link                       | Description                       |
| --------------------------------- | --------------------------------- |
| [Express](https://expressjs.com/) | Express is a minimal and flexible Node.js web application framework that provides a robust set of features for web and mobile applications. |
| [TypeORM](http://typeorm.io/#/) | TypeORM is highly influenced by other ORMs, such as Hibernate, Doctrine and Entity Framework. |
| [swagger Documentation](http://swagger.io/) | API Tool to describe and document your api. |
