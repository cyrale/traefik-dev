# Use traefik for web development

For more information on Træfik, see [https://traefik.io/](https://traefik.io/)

## How to use

```bash
$ docker-compose up -d
```

In a browser you may open `http://localhost:8080` to access Træfik's dashboard and observe the following magic. For Windows users, replace `localhost` by your docker machine IP obtained from `docker-machine ip default`.

Now, create new services like that:

```yaml
version: '3'

services:
  web:
    image: emilevauge/whoami
    networks:
      - webgateway
      - default
    labels:
      - "traefik.enable=true"
      - "traefik.backend=whoami"
      - "traefik.frontend.rule=Host:whoami.docker.dev"
      - "traefik.docker.network=traefikforwebdev_webgateway"

networks:
  webgateway:
    external:
      name: traefikforwebdev_webgateway
```

For Linux users and maybe OSX users, setup dnsmasq like that:
```bash
$ sudo vim /etc/dnsmasq.d/01_docker
address=/docker.dev/127.0.0.1

$ sudo service dnsmasq restart
``` 

For all users without dnsmasq, insert the following line in your `/etc/hosts`:
```
192.168.99.100  whoami.docker.dev
```
Where `192.168.99.100` is your docker machine IP, it could be `127.0.0.1`
