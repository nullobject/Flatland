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
    _entity = [[Entity alloc] init];
    _entity.position = CGPointMake(RANDOM() * 500, RANDOM() * 500);
  }

  return self;
}

- (NSDictionary *)asJSON {
  NSDictionary *entity = [self.entity asJSON];

  return @{@"id":     [self.UUID UUIDString],
           @"entity": entity};
}

@end
