//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "Player.h"

@implementation Player {
  PlayerAction *_action;
}

- (Player *)initWithUUID:(NSUUID *)uuid {
  if (self = [super init]) {
    _uuid   = uuid;
    _deaths = 0;
    _kills  = 0;
  }

  return self;
}

- (void)enqueueAction:(PlayerAction *)action error:(GameError **)error {
  if (_state != PlayerStateAlive && action.type != PlayerActionTypeSpawn) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerNotSpawned
                                      userInfo:nil];
    return;
  } else if (_state == PlayerStateAlive && action.type == PlayerActionTypeSpawn) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerAlreadySpawned
                                      userInfo:nil];
    return;
  } else if (_state == PlayerStateAlive && action.cost + self.entity.energy < 0) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerInsufficientEnergy
                                      userInfo:nil];
    return;
  }

  _action = action;
}

- (void)tick {
  // Default to the idle action (if the player is alive).
  if (_state == PlayerStateAlive && !_action) {
    _action = [PlayerAction playerActionWithType:PlayerActionTypeIdle andOptions:nil];
  }

  // Apply the action.
  [_action applyToPlayer:self];

  // Clear the current action.
  _action = nil;

  // Increment the entity age.
  _entity.age += 1;
}

#pragma mark - Actions

- (void)spawn {
  NSAssert(_state == PlayerStateDead, @"Player has already spawned");
  NSLog(@"Spawning player %@ in %f seconds.", [self.uuid UUIDString], kSpawnDelay);
  _state = PlayerStateSpawning;
  [NSTimer scheduledTimerWithTimeInterval:kSpawnDelay
                                   target:self
                                 selector:@selector(didSpawn)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)suicide {
  NSAssert(_state == PlayerStateAlive, @"Player has not spawned");
  NSLog(@"Killing player %@.", [self.uuid UUIDString]);
  [self didDie];
}

- (void)idle {
  NSAssert(_state == PlayerStateAlive, @"Player has not spawned");
  NSLog(@"Idling player %@.", [self.uuid UUIDString]);
  [_entity idle];
}

- (void)moveBy:(CGFloat)amount {
  NSAssert(_state == PlayerStateAlive, @"Player has not spawned");
  NSLog(@"Moving player %@ by %f.", [self.uuid UUIDString], amount);
  [_entity moveBy:amount];
}

- (void)turnBy:(CGFloat)amount {
  NSAssert(_state == PlayerStateAlive, @"Player has not spawned");
  NSLog(@"Turning player %@ by %f.", [self.uuid UUIDString], amount);
  [_entity turnBy:amount];
}

- (void)attack {
  NSAssert(_state == PlayerStateAlive, @"Player has not spawned");
  NSLog(@"Player attacking %@ .", [self.uuid UUIDString]);
  [_entity attack];
}

#pragma mark - EntityDelegate

- (void)didKill:(Entity *)entity {
  [self didKill];
}

- (void)wasKilledBy:(Entity *)entity {
  [self didDie];
}

#pragma mark - Serializable

- (NSDictionary *)asJSON {
  id entity = _entity ? [_entity asJSON] : [NSNull null];

  return @{@"id":     [_uuid UUIDString],
           @"state":  [Player playerStateAsString:self.state],
           @"entity": entity,
           @"deaths": [NSNumber numberWithUnsignedInteger:self.deaths],
           @"kills":  [NSNumber numberWithUnsignedInteger:self.kills]};
}

#pragma mark - Private

+ (NSString *)playerStateAsString:(PlayerState) state {
  switch (state) {
    case PlayerStateSpawning: return @"spawning";
    case PlayerStateAlive:    return @"alive";
    default:                  return @"dead";
  }
}

- (void)didSpawn {
  _entity = [[Entity alloc] initWithUUID:[NSUUID UUID]];

  _entity.delegate = self;
  _entity.position = CGPointMake(RANDOM() * 500, RANDOM() * 500);

  NSLog(@"Player %@ spawned at (%f, %f).", [self.uuid UUIDString], _entity.position.x, _entity.position.y);

  _state = PlayerStateAlive;

  if ([_delegate respondsToSelector:@selector(playerDidSpawn:)]) {
    [_delegate playerDidSpawn:self];
  }
}

- (void)didDie {
  _state = PlayerStateDead;
  _deaths += 1;
  [_entity removeFromParent];
  _entity = nil;
}

- (void)didKill {
  _kills += 1;
}

@end
