# autojenkins

[![GitHub Super-Linter](https://github.com/tropicalwave/autojenkins/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)

## Introduction

This is a test project to get used to the mechanisms of Jenkins, Gitea,
LDAP and Keycloak using Podman.

## Quickstart

```bash
./prepare_test
podman-compose up -d
```

## Overview

![Architecture](/images/architecture.svg)

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

## Debugging

### Developing Keycloak themes

This project uses a customized Keycloak registration form. The interactive
development of Keycloak themes needs disabling Keycloak's themes cache. Attach
to the Keycloak container and execute the following commands to disable it:

```bash
/opt/jboss/keycloak/bin/jboss-cli.sh
connect
/subsystem=keycloak-server/theme=defaults/:write-attribute(name=cacheThemes,value=false)
/subsystem=keycloak-server/theme=defaults/:write-attribute(name=cacheTemplates,value=false)
/subsystem=keycloak-server/theme=defaults/:write-attribute(name=staticMaxAge,value=-1)
reload
```

### Checking LDAP users

Attach to LDAP container and execute the following command:
```bash
ldapsearch -b dc=example,dc=org -D cn=admin,dc=example,dc=org -w <ldap admin password>
```

### Move demo user from/to Jenkins admin group

By default, the user `demo` is able to administer Jenkins because of its membership
in the LDAP group `jenkins_admins`. By removing (or adding thereafter) this group
membership, one can change these admin permissions. This can be done either in Keycloak
or using these commands in the LDAP container:

```bash
# add user to group jenkins_admins
ldapmodify -x -D "cn=admin,dc=example,dc=org" -f /tmp/make-admin.ldif -w <ldap admin password>

# remove user from group jenkins_admins
ldapmodify -x -D "cn=admin,dc=example,dc=org" -f /tmp/revoke-admin.ldif -w <ldap admin password>
```

Hint: It might take up to one minute for Keycloak to synchronize this change from LDAP.

### Restrict user access to Jenkins

The Jenkins client uses a customized authentication flow. Before granting
access, it checks if the authenticating user is assigned to the role
`jenkins_users`. This role is mapped from the LDAP group with the same
name, so adding/removing users will appropriately change access permissions.
