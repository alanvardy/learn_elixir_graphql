# LearnElixirGraphql

Assignment for learning GraphQL with Absinthe, Phoenix, and Ecto

## Setting up

Start up postgres with docker-compose

```bash
docker-compose up -d
```

Run test suite and other checks

```bash
mix check
```

## Start 2 nodes in development

In one terminal

```bash
iex --sname node_a@localhost -S mix phx.server
```

In another terminal

```bash
PORT=4001 iex --sname node_b@localhost -S mix phx.server
```
