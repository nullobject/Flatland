# Flatland

Flatland is a multi-player game where each player is controller by actions sent
over HTTP.

## Actions

Every action costs the player a set amount of energy points.

All requests must include the `X-Player` header. The server will respond with
the world view for the player.

    {
      player: {...}
    }

### Spawn

Spawns the player in the world.

For example:

`curl -i -X PUT -H 'X-Player: 5108B670-3332-4172-862D-89BF68576ED6' -H 'Content-Type: application/json' -d '' http://localhost:8000/player/spawn`

### Rest

Rests the player for a given amount of time, where amount is a value between
-1.0 and 1.0. The player restores 10 energy points for each tick of the world
clock.

For example:

`curl -i -X PUT -H 'X-Player: 5108B670-3332-4172-862D-89BF68576ED6' -H 'Content-Type: application/json' -d '{"amount":1.0}' http://localhost:8000/player/rest`

### Move

Moves the player in the direction they are facing by a given amount, where
amount is a value between -1.0 and 1.0. The player uses 20 energy points for
moving.

For example:

`curl -i -X PUT -H 'X-Player: 5108B670-3332-4172-862D-89BF68576ED6' -H 'Content-Type: application/json' -d '{"amount":1.0}' http://localhost:8000/player/move`

### Turn

Turns the player by a given amount, where amount is a value between -1.0 and
1.0. The player uses 20 energy points for turning.

For example:

`curl -i -X PUT -H 'X-Player: 5108B670-3332-4172-862D-89BF68576ED6' -H 'Content-Type: application/json' -d '{"amount":1.0}' http://localhost:8000/player/turn`
