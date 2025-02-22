#!/bin/bash
if [[ "$GITEA_PASSWORD" && "$LDAP_BIND_CREDENTIAL" && "$USER_PASSWORD" ]] && [[ ! -e .initialized ]]; then
    GITEA_URL="http://localhost:3000"
    while true; do
        STATUS_CODE=$(curl -LI "$GITEA_URL" -o /dev/null -w '%{http_code}\n' -s)
        if [ "$STATUS_CODE" = "200" ]; then
            break
        fi
        sleep 1
    done

    if su-exec "$USER" gitea admin user create --admin --username gitea --password "$GITEA_PASSWORD" --email me@localhost >/tmp/init.log; then
        su-exec "$USER" gitea admin auth add-ldap \
            --name ldap \
            --security-protocol unencrypted \
            --host ldap \
            --port 389 \
            --user-search-base "ou=users,dc=example,dc=org" \
            --user-filter "(&(objectClass=inetOrgPerson)(uid=%s))" \
            --email-attribute mail \
            --bind-dn cn=admin,dc=example,dc=org \
            --bind-password "$LDAP_BIND_CREDENTIAL"
        AUTHORIZATION="$(echo -n "demo:$USER_PASSWORD" | base64)"

        DEFAULT_CURL_PARAMETERS=(-H "Authorization: Basic $AUTHORIZATION" -H Content-Type:application/json -H accept:application/json)

        curl -f -X POST "$GITEA_URL/api/v1/orgs" "${DEFAULT_CURL_PARAMETERS[@]}" \
            --data '{"name": "org", "username": "home"}'
        curl -f -X POST "$GITEA_URL/api/v1/org/home/repos" "${DEFAULT_CURL_PARAMETERS[@]}" \
            -d '{"name":"test", "description": "Test repository"}'
        curl -f -X POST "$GITEA_URL/api/v1/org/home/repos" "${DEFAULT_CURL_PARAMETERS[@]}" \
            -d '{"name":"test2", "description": "Second test repository"}'

        git config --global user.email "me@localhost"
        git config --global user.name "Prename Surname"

        ssh-keygen -f "$HOME/.ssh/id_rsa" -N ''
        PUBLIC_SSH_KEY="$(cat "$HOME/.ssh/id_rsa.pub")"

        # editorconfig-checker-disable
        cat >"$HOME/.ssh/config" <<EOF
Host localhost
  StrictHostKeyChecking=no
EOF
        # editorconfig-checker-enable

        for repo in "test" "test2"; do
            curl -f -X POST "$GITEA_URL/api/v1/repos/home/$repo/keys" "${DEFAULT_CURL_PARAMETERS[@]}" \
                -d "{\"title\":\"bla\", \"key\": \"$PUBLIC_SSH_KEY\"}"

            git clone ssh://git@localhost:2222/home/$repo /tmp/$repo

            pushd "$PWD" || exit
            cd "/tmp/$repo" || exit
            cat >Jenkinsfile <<EOF
pipeline {
    agent { label "fedora" }

    stages {
        stage("Build") {
            steps {
                sh "echo Hello World! This is repo $repo"
            }
        }
    }
}
EOF
            git add Jenkinsfile
            git commit -m "initial commit"
            git push
            popd || exit
        done

        while ! curl -f http://jenkins:4040/; do
            sleep 1
        done

        curl -f -X POST "$GITEA_URL/api/v1/orgs/home/hooks" "${DEFAULT_CURL_PARAMETERS[@]}" \
            -d "{\"active\": true, \"type\": \"gitea\", \"config\": \
                { \"url\": \"http://jenkins:4040/gitea-webhook/post\", \"content_type\": \"json\" } }"
    fi

    echo 'Waiting for Keycloak to get ready.' >>/tmp/init.log
    while ! curl -f "$KEYCLOAK_URL"; do
        sleep 1
    done

    su-exec "$USER" gitea admin auth add-oauth --name keycloak --provider openidConnect --key gitea --secret "$KEYCLOAK_GITEA_SECRET" --auto-discover-url "$KEYCLOAK_URL/realms/ci/.well-known/openid-configuration"
    echo 'Initialized everything.' >>/tmp/init.log
fi

touch .initialized

# forward requests to Keycloak (the well-known URL provides localhost:8080
# as endpoint, but we have to use keycloak:8080 instead)
socat TCP-LISTEN:8080,bind=localhost,fork TCP:keycloak:8080
