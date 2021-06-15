# autojenkins

[![GitHub Super-Linter](https://github.com/tropicalwave/autojenkins/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)

## Introduction

This is a test project to get used to the mechanisms of an automated
Jenkins installation using Podman, Gitea, LDAP and Keycloak.

## Quickstart

```bash
./prepare_test
podman-compose up -d
```

## Overview

After starting the environment, three services will be accessible:

1. *Keycloak* on <http://localhost:8080>
2. *Jenkins* on <http://localhost:4040>
3. *Gitea* on <http://localhost:3000>

Two Gitea repositories will be configured automatically. After an
initial repository scan on Jenkins (needs to be triggered manually),
these repositories will run a Jenkinsfile pipeline after every commit.

The following users are available (with auto-generated passwords shown
after the initial execution of `./prepare_test`):

1. User `admin` on Keycloak (administrator)
2. User `gitea` on Gitea (administrator)
3. User `demo` on Gitea and Jenkins (using Keycloak SSO)
