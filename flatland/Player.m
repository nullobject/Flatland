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

- (Player *)initWithUUID:(NSUUID *)UUID {
  if (self = [super init]) {
    _UUID = UUID;
  }

  return self;
}

- (void)idle {
  if (_state != PlayerStateAlive) return;
  [_entity idle:1];
}

- (void)spawn {
  if (_state != PlayerStateDead) return;

  NSLog(@"Spawning player %@", [self.UUID UUIDString]);

//  _state = PlayerStateSpawning;
  _state = PlayerStateAlive;
  _entity = [[Entity alloc] init];
  _entity.position = CGPointMake(RANDOM() * 500, RANDOM() * 500);
}

- (void)move {
  if (_state != PlayerStateAlive) return;
  [_entity move:1];
}

- (void)turn {
  if (_state != PlayerStateAlive) return;
  [_entity turn:1];
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

  if (self.entity) {
    entity = [self.entity asJSON];
  }

  return @{@"id":     [self.UUID UUIDString],
           @"state":  [self playerStateAsString:self.state],
           @"entity": entity};
}

@end
