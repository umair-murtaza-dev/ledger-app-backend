#  ledger

## Setup

If this is your first time setting up the project, you should do the following after cloning the repository:

### Setup docker
Install docker in your machine if not installed before (https://docs.docker.com/install/)

To setup project do following command to setup docker project:
```bash
docker-compose up --build
```

### Setting up credentials
If `config/master.key` does not exist then create a file and add a secret hash inside.
Take all credential details from config/credentials.example.yml and save in actual credential file.
To edit credential file use following command:
```bash
docker-compose run --rm -e EDITOR=nano app bin/rails credentials:edit
```

### Setup DB and run migrations

```bash
docker-compose run app rake db:create
docker-compose run app rake db:migrate
docker-compose run app rails db:migrate RAILS_ENV=test
```

## Run application

To run the application:

```bash
docker-compose up
```

The app server should be running on (http://127.0.0.1:7004)

## Rails Console

To enter Rails console, run the following:

```bash
script/console
```
## Machine

To enter access machine:

```bash
script/machine
```
## Debugging

### `byebug`

`byebug` is running remotely in the development environment. If you want to
debug the web server, you can connect remotely to byebug by running:

```bash
script/debug
```

## Troubleshooting

If you face this issue, run the following commands:

```bash
rm tmp/pids/server.pid
docker-compose up -d
```

### Important Notes

Do not use `update_all` or `update_column` If you really need to use that then update updated_at too.

## Infrastructure / development flow

### Note

**Currently, TerraformCloud and ArgoCD require IO team member manual approval, to deploy and provision.**

### Staging

- Applications urls:
    - API: <https://ledger-api.staging.dev..com/status>
    - Mailcatcher: <https://ledger-mailcatcher.staging.dev..com/>
    - Frontend (`staging-ledger-web` repo): <https://ledger.staging.dev..com/>
- AWS account: `development-`
- Kubernetes:
    - cluster: `-dev-cluster`
    - namespace: `staging-ledger`
- SonarQube project: <https://sonar.dev..com/dashboard?id=%3A-ledger>
- TerraformCloud:
    - ledger shared: <https://app.terraform.io/app/-com/workspaces/-ledger-shared>
    - ledger api: <https://app.terraform.io/app/-com/workspaces/-ledger-staging>
- Helm Chart Repo:
    - repo: `-helm-charts`
    - path: `marketplace/ledger/`
- ArgoCD project: <https://argocd.dev..com/applications/staging-ledger>

### Diagram

![ledgerFlow](docs/img/ledger-ci-cd-flow.png)
