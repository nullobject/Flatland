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
    _uuid = uuid;
  }

  return self;
}

- (void)enqueueAction:(PlayerAction *)action error:(GameError **)error {
  if (_state != PlayerStateAlive && action.type != PlayerActionTypeSpawn) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerNotSpawned
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
  if (_state != PlayerStateAlive && !_action) {
    return;
  } else if (!_action) {
    _action = [PlayerAction playerActionWithType:PlayerActionTypeIdle andOptions:nil];
  }

  CGFloat amount = [(NSNumber *)[_action.options objectForKey:@"amount"] floatValue];

  switch (_action.type) {
    case PlayerActionTypeSpawn:
      [self spawn];
      break;
    case PlayerActionTypeIdle:
      [self idle];
      break;
    case PlayerActionTypeMove:
      [self moveBy:amount];
      break;
    case PlayerActionTypeTurn:
      [self turnBy:amount];
      break;
  }

  // Update the entity energy.
  _entity.energy += _action.cost;

  // Increment the entity age.
  _entity.age += 1;

  // Clear the current action.
  _action = nil;
}

#pragma mark - Serializable

- (NSDictionary *)asJSON {
  id entity = _entity ? [_entity asJSON] : [NSNull null];

  return @{@"id":     [_uuid UUIDString],
           @"state":  [self playerStateAsString:self.state],
           @"entity": entity};
}

#pragma mark - Private

- (NSString *)playerStateAsString:(PlayerState) state {
  switch (state) {
    case PlayerStateSpawning: return @"spawning";
    case PlayerStateAlive:    return @"alive";
    default:                  return @"dead";
  }
}

- (void)didSpawn {
  _entity = [[Entity alloc] initWithUUID:[NSUUID UUID]];
  _entity.position = CGPointMake(RANDOM() * 500, RANDOM() * 500);

  _state = PlayerStateAlive;

  NSLog(@"Player %@ spawned at (%f, %f).", [self.uuid UUIDString], _entity.position.x, _entity.position.y);

  if ([_delegate respondsToSelector:@selector(playerDidSpawn:)]) {
    [_delegate playerDidSpawn:self];
  }
}

#pragma mark - Actions

- (void)spawn {
  NSAssert(_state == PlayerStateDead, @"Player is already alive");
  _state = PlayerStateSpawning;
  NSLog(@"Spawning player %@ in %f seconds.", [self.uuid UUIDString], kSpawnDelay);
  [NSTimer scheduledTimerWithTimeInterval:kSpawnDelay
                                   target:self
                                 selector:@selector(didSpawn)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)idle {
  NSAssert(_state == PlayerStateAlive, @"Player is not alive");
  NSLog(@"Idling player %@.", [self.uuid UUIDString]);
  [_entity idle];
}

- (void)moveBy:(CGFloat)amount {
  NSAssert(_state == PlayerStateAlive, @"Player is not alive");
  NSLog(@"Moving player %@ by %f.", [self.uuid UUIDString], amount);
  [_entity moveBy:amount];
}

- (void)turnBy:(CGFloat)amount {
  NSAssert(_state == PlayerStateAlive, @"Player is not alive");
  NSLog(@"Turning player %@ by %f.", [self.uuid UUIDString], amount);
  [_entity turnBy:amount];
}

@end
