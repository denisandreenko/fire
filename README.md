# Fire
🔥🔥 FIRE 🔥🔥 is a p2p portfolio tracker which collects data from statements of supported p2p platforms and shows analytics of the entire portfolio  

## Env
- APP_ROOT={Path_to_root_dir};
- FIRE_ENV={production/staging/development}

## Migrations
Creating a new migration: <br>
```migrate create -ext sql -dir migrations -seq initialize_schema```

Run migrations: <br>
```migrate -path migrations -database "postgres://{{user}}:{{password}}@{{host}}/{{dbname}}?sslmode=disable" up```

```migrate -path migrations -database "postgres://{{user}}:{{password}}@{{host}}/{{dbname}}?sslmode=disable" down```

## Run
```make docker-compose-up```

## Debug mode
Install dlv lib
```go get github.com/go-delve/delve/cmd/dlv```

Run
```make docker-compose-dev-up```

# TODO
- Swagger
- CI/CD pipelines
- Safe DB credentials