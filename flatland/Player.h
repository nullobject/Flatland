//
//  Player.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Entity.h"
#import "Serializable.h"

typedef enum : uint8_t {
  PlayerStateDead,
  PlayerStateSpawning,
  PlayerStateAlive
} PlayerState;

@interface Player : NSObject <Serializable>

@property (nonatomic, strong) NSUUID *UUID;
@property (nonatomic, assign) PlayerState state;
@property (nonatomic, strong) Entity *entity;

- (Player *)initWithUUID:(NSUUID *)UUID;

// Commands.
- (void)idle;
- (void)spawn;
- (void)forward;
- (void)reverse;

@end
