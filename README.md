# flatland-cocoa

## API

All requests must include the `X-Player` header. The server will respond with the world view for the player.

    {
      player: {...}
    }

### Spawning

`/spawn`: Spawns the player.

### Idling (AKA do nothing)

`/idle`: Idles the player.

### Moving

`/move`: Moves the player by the given amount, where amount is a value between -1.0 and 1.0.

    {"amount": 0.5}

### Turning

`/turn`: Turns the player by the given amount, where amount is a value between -1.0 and 1.0.


    {"amount": 0.5}
