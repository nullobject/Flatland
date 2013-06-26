//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "Player.h"

// Player spawn delay in seconds.
const NSTimeInterval kSpawnDelay = 3.0;

@implementation Player

- (Player *)initWithUUID:(NSUUID *)uuid {
  if (self = [super init]) {
    _uuid = uuid;
  }

  return self;
}

- (void)idle {
  if (_state != PlayerStateAlive) return;
  [_entity idle];
}

- (void)spawn {
  if (_state != PlayerStateDead) return;
  _state = PlayerStateSpawning;
  NSLog(@"Spawning player %@ in %f seconds.", [self.uuid UUIDString], kSpawnDelay);
  [NSTimer scheduledTimerWithTimeInterval:kSpawnDelay
                                   target:self
                                 selector:@selector(didSpawn)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)moveBy:(CGFloat)amount {
  if (_state != PlayerStateAlive) return;
  NSLog(@"Moving player %@ by %f.", [self.uuid UUIDString], amount);
  [_entity moveBy:amount];
}

- (void)turnBy:(CGFloat)amount {
  if (_state != PlayerStateAlive) return;
  NSLog(@"Turning player %@ by %f.", [self.uuid UUIDString], amount);
  [_entity turnBy:amount];
}

#pragma mark - Serializable methods

- (NSDictionary *)asJSON {
  id entity = [NSNull null];

  if (_entity) {
    entity = [_entity asJSON];
  }

  return @{@"id":     [_uuid UUIDString],
           @"state":  [self playerStateAsString:self.state],
           @"entity": entity};
}

#pragma mark - Private methods

- (NSString *)playerStateAsString:(PlayerState) state {
  switch (state) {
    case PlayerStateSpawning: return @"spawning";
    case PlayerStateAlive:    return @"alive";
    default:                  return @"dead";
  }
}

- (void)didSpawn {
  _entity = [[Entity alloc] init];
  _entity.position = CGPointMake(RANDOM() * 500, RANDOM() * 500);

  _state = PlayerStateAlive;

  NSLog(@"Player %@ spawned at (%f, %f).", [self.uuid UUIDString], _entity.position.x, _entity.position.y);

  if ([_delegate respondsToSelector:@selector(playerDidSpawn:)]) {
    [_delegate playerDidSpawn:self];
  }
}

@end
