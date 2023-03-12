![Build status](https://github.com/denisandreenko/fire/actions/workflows/ci.yaml/badge.svg?branch=main&event=push)

# Fire
🔥🔥 FIRE 🔥🔥 is a p2p portfolio tracker which collects data from statements of supported p2p platforms and shows analytics of the entire portfolio  

## Env
- APP_ROOT={Path_to_root_dir};
- FIRE_ENV={production/staging/development}

## Migrations
Install 'migrate' lib: <br>
```make migrate-setup```

Creating a new migration: <br>
```migrate create -ext sql -dir migrations -seq initialize_schema```

Run migrations: <br>
```make migrate-up```

```make migrate-down```

## Run
```make docker-compose-up```

## Debug mode
```make docker-compose-dev-up```

## Jenkins
Plugins:
- 'git' - to download project from GitHub
- 'pipeline' - for creating and running CI/CD pipelines
- 'blue ocean' - modern Jenkins UI (access via <jenkins-url>/blue)
- 'ssh build agents' - allows to launch agents over SSH, using a Java implementation of the SSH protocol


# TODO
- Swagger
- CI/CD pipelines (merge to main branch after CI passes, build image and put to the registry, deploy it on a cloud platform)
- Safe DB credentials (github CI, Makefile, configs)
- Add helper service, that handles user downloads (gRPC transcport)