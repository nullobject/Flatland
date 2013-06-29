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

`PUT /action/spawn`

### Idle

Idles the player. The player restores 10 energy points for idling.

For example:

`PUT /action/idle`

### Move

Moves the player by the given amount, where amount is a value between -1.0 and
1.0. The player uses 20 energy points for moving.

For example:

`PUT /action/move`

    {"amount": 0.5}

### Turn

Turns the player by the given amount, where amount is a value between -1.0 and
1.0. The player uses 20 energy points for turning.

For example:

`PUT /action/turn`

    {"amount": 0.5}
