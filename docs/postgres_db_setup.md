**_This guide outlines the steps to set up Podman and a PostgreSQL container on an Alpine Linux system. Follow these instructions to ensure a smooth installation and configuration process._**

---

## Update the system

```
# apk update && apk upgrade
```

## Podman installation

You can run these commands in a script or line by line, up to you

```
# apk add podman
# rc-update add cgroups
# rc-service cgroups start
# modprobe tun
# echo tun >> /etc/modules
# echo $USER:100000:65536 > /etc/subuid
# echo $USER:100000:65536 > /etc/subgid
```

## Postgres container setup

1. Pulling the image from `docker.io`

   ```bash
   podman pull docker.io/library/postgres
   ```

2. Creating the container

   ```bash
   podman run -dt --name postgres_cont \
    -e POSTGRES_PASSWORD=admin \
    -v "/home/seth/postgres_cont:/var/lib/postgresql/data:Z" \
    -p 5432:5432 \
    postgres
   ```

3. Enter the container and create a database named `oxidized_airport`

   ```bash
   podman exec -it postgres_cont bash
   psql -U postgres
   ```

   ```sql
   CREATE DATABASE oxidized_airport;
   ```

## Set the OADBCS environment variable

On the client's system the OADBCS environment variable should be set to the connection string to the database, here is an example:

```
export OADBCS="postgres://postgres:admin@<ip.address>:5432/oxidized_airport"
```

On Linux you can add this line to the `/etc/environment` file and that should allow the app to connect to the database.

## Insert some data to test the app (optional)

Execute the queries in [generate_some_data](https://github.com/naseem-chettah/oxidized-airport/blob/main/docs/generate_some_data.sql) to generate some data.
