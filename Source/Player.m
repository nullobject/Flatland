//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "Player.h"

@implementation PlayerAction

- (id)initWithType:(PlayerActionType)type andOptions:(NSDictionary *)options {
  if (self = [super init]) {
    _type = type;
    _options = options;
  }

  return self;
}

+ (id)playerActionWithType:(PlayerActionType)type andOptions:(NSDictionary *)options {
  return [[self alloc] initWithType:type andOptions:options];
}

@end

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
//  } else if (action.cost > self.entity.energy) {
//    *error = [[GameError alloc] initWithDomain:GameErrorDomain
//                                          code:GameErrorPlayerInsufficientEnergy
//                                      userInfo:nil];
  }

  _action = action;
}

- (void)tick {
  if (!_action) return;

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
