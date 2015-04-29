
Project Cluster
============

```
cluster create <ip> [, <ip>]*
cluster status
cluster list services
cluster list running
cluster remove <service>
cluster add <service>
cluster bootstrap <ip>
cluster destroy
```


App deployment
--------------

Each application is responsible for creating docker containers for each of their components. This library will handle stitching together and configuring those containers, using a combination of unit descriptions and environment variables.


Since the app creates docker containers, they should also be responsible for adding them to he app registry. This is done by exporting the containers to s3. These slugs are created using

```
docker save <name> > <name>-<last-tag>-<sha1>.image.docker
```

The archive will be reinflated during deployment via

```
cat <some>.image.docker | docker import - <name>:<last-tag>-<sha1>
```


Notes
-----------

Launching a cluster requires bootstraping nodes with cloud-config. Need to update cloudconfig with new discovery url.


User config data is kept in ~/.project-cluster
Service definitions are kept in ./lib/services
Other assets are kept in ./lib


```
docker exec -it <contid> bash
docker run -p 8080:80 4443:443 -i nginx-rp:latest
```


