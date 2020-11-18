# autojenkins

This is a test project to get used to the mechanisms of an automated
Jenkins installation using Podman, Gitea and Keycloak.

## Quickstart

```
# ./prepare_test
# podman-compose up -d
```

## Overview

After starting the environment, three services will be accessible:

1. *Keycloak* on http://localhost:8080
2. *Jenkins* on http://localhost:4040
3. *Gitea* on http://localhost:3000

Two Gitea repositories will be configured automatically. After an
initial repository scan on Jenkins, these repositories will run a
Jenkinsfile pipeline after every commit.

The following users are available (with auto-generated passwords shown
after the initial execution of `./prepare_test`):

1. User `admin` on Keycloak (administrator)
2. User `gitea` on Gitea (administrator)
3. User `demo` on Gitea and Jenkins (using Keycloak SSO)

Note: SSO on Gitea only works after a restart of Gitea or manual
confirmation of SSO settings in the administration frontend, see
[this bug report](https://github.com/go-gitea/gitea/issues/8356).
The preferred way to handle this is the execution of the following
commands after Gitea was accessible once:

```
podman-compose stop gitea
podman-compose start gitea
```
