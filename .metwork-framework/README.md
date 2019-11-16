## Features

This repository holds an opinionated centos (version 7) docker image to be used as a 
base docker image. Some inspiration sources are given at the end of this file.

Features:

- Updated image (at build time)
- Reasonable size (< 100 MB on the docker hub), reasonable number of layers (8) with a squashed Dockerfile
- Don't add too many packages by installing just what's needed
- Don't break the upstream system
- Init system and multiple processes launcher/supervisor ([S6](http://skarnet.org/software/s6/overview.html))
- (optional) complete cron/anacron daemon ([cronie](https://fedorahosted.org/cronie/))
- (optional) SSH server

## Usage and configuration

Not really usefull (because it's mainly a base image to use in the `FROM` keyword) but you can play with it with (for example):

    docker run -i -t metwork-framework/centos7-opinionated:latest bash

Available environnement variables:

- `DCO_CRONIE_START` (if "1" (default) then start the cron daemon)
- `DCO_SSHD_START` (if "0" (default) then do not start the sshd daemon)

If you set `DCO_SSHD_START=1`, you can also use following environnement variables:

- `DCO_SSHD_FORCE_RSA_HOST_KEY`
- `DCO_SSHD_FORCE_RSA_HOST_PUB_KEY`
- `DCO_SSHD_FORCE_ECDSA_HOST_KEY`
- `DCO_SSHD_FORCE_ECDSA_HOST_PUB_KEY`
- `DCO_SSHD_FORCE_ED25519_HOST_KEY`
- `DCO_SSHD_FORCE_ED25519_HOST_PUB_KEY`

to force sshd host keys.

You can also use:

- `DCO_SSHD_ADD_ROOT_AUTHORIZED_KEY` to add the given public key to `/root/.ssh/authorized_keys`
- `DCO_FORCE_ROOT_PASSWORD` to force the root password 

If you prefer, you can also use a volume mounted in `/force` in the container with:

- `/force/root_password` (instead of `DCO_FORCE_ROOT_PASSWORD`)
- `/force/ssh_host_rsa_key`
- `/force/ssh_host_rsa_key.pub`
- `/force/ssh_host_ed25519_key`
- `/force/ssh_host_ed25519_key.pub`
- `/force/ssh_host_ecdsa_key`
- `/force/ssh_host_ecdsa_key.pub` (instead of corresponding `DCO_SSHD_FORCE_*_KEY`)
- `/force/root_authorized_keys` (the content of this file will be appended to `/root/.ssh/authorized_keys`)

## FAQ

### How to override this image to add your service on top of it ?

When you start this image with the default "entrypoint" (`/init`), it launch the S6 process supervisor (see links at the end) 
provided by the [s6-overlay](https://github.com/just-containers/s6-overlay).

First, it executes `/etc/cont-init.d/*` initialization (short) tasks. Then, it launchs `/etc/services/*/run` script. This script
must execute your daemon in a long-lived way and will have to deal with signals. If this "run script" exits, it will be automatically 
restarted. An easy way to write a such script is to use the "exec" bash builtin with the "foreground mode" startup command of your service.

For example:

```bash
#!/bin/sh

exec /sbin/rsyslogd -n
```

Because of "exec", the script will be replaced by the launched command. So you won't have to deal with signals by yourself.

So a complete example to override this image with a new service on top of it can be:

```
$ find my_image

my_image/
my_image/Dockerfile
my_image/root
my_image/root/etc
my_image/root/etc/cont-init.d
my_image/root/etc/cont-init.d/my_initialization_script
my_image/root/etc/services.d
my_image/root/etc/services.d/myapp
my_image/root/etc/services.d/myapp/run
```

With `my_image/Dockerfile` like:

```
FROM metwor-framework/centos7-opinionated

COPY root /
```

And that's all ! Your custom service will be executed as well as sshd, cron services provides by the base image.

## Can I use CMD with the init entrypoint ?

Yes, quotted from the [s6-overlay](https://github.com/just-containers/s6-overlay) README:

> Using CMD is a really convenient way to take advantage of the s6-overlay. 
> Your CMD can be given at build-time in the Dockerfile, or at runtime on the command line, either way is fine - it will be run under the s6 supervisor, and when it fails or exits, the container will exit. You can even run interactive programs under the s6 supervisor!

Please consult [s6-overlay](https://github.com/just-containers/s6-overlay) REAME for examples and more details.

## (some) Inspiration sources

- [the-5-most-important-things-ive-learned-from-using-docker](http://blog.tutum.co/2014/10/28/the-5-most-important-things-ive-learned-from-using-docker/)
- [docker-and-s6-my-new-favorite-process-supervisor](http://blog.tutum.co/2014/12/02/docker-and-s6-my-new-favorite-process-supervisor/)
- [baseimage-docker](http://phusion.github.io/baseimage-docker/)
- [s6-overlay](https://github.com/just-containers/s6-overlay)
- [s6](http://skarnet.org/software/s6/overview.html)
- [cronie](https://fedorahosted.org/cronie/)
