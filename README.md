# Basic Docker skeleton with PHP, Node and MariaDB

Simple Docker skeleton for my projects with access to private repositories 

1. [Download](https://github.com/elcuro/docker-php-skeleton/archive/refs/heads/master.zip) this repository 
2. Extract to the your project root
3. Add `auth.json` to `.dockerignore` and to `.gitignore`
4. Add your [Github token](https://github.com/settings/tokens) to `auth.json`
5. Build images `make build`
6. Run containers `make up`
7. Install dependencies `make vendor`
8. Add dumped SQL to the `.docker/mariadb/dump.sql`
9. Set image and container names in the `docker-compose.yml`
10. Update Makefile to your need

#### Inspiration and more info
- [Access to private repositories from Docker](https://dunglas.dev/2022/08/securely-access-private-git-repositories-and-composer-packages-in-docker-builds/) by Kévin Dunglas
- [Symfony Docker](https://github.com/dunglas/symfony-docker)