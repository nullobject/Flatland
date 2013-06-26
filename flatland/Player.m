//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"

#define RANDOM() (arc4random() / (float)(0xffffffffu))

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

  NSLog(@"Spawning player %@", [self.uuid UUIDString]);

  _entity = [[Entity alloc] init];
  _entity.position = CGPointMake(RANDOM() * 500, RANDOM() * 500);
//  _state = PlayerStateSpawning;
  _state = PlayerStateAlive;
}

- (void)moveBy:(CGFloat)amount {
  if (_state != PlayerStateAlive) return;
  [_entity moveBy:amount];
}

- (void)turnBy:(CGFloat)amount {
  if (_state != PlayerStateAlive) return;
  [_entity turnBy:amount];
}

- (NSString *)playerStateAsString:(PlayerState) state {
  switch (state) {
    case PlayerStateSpawning: return @"spawning";
    case PlayerStateAlive:    return @"alive";
    default:                  return @"dead";
  }
}

- (NSDictionary *)asJSON {
  id entity = [NSNull null];

  if (_entity) {
    entity = [_entity asJSON];
  }

  return @{@"id":     [_uuid UUIDString],
           @"state":  [self playerStateAsString:self.state],
           @"entity": entity};
}

@end
