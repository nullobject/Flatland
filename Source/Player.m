//
//  Player.m
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BulletNode.h"
#import "Core.h"
#import "NSDictionary+Point.h"
#import "Player.h"
#import "PlayerIdleAction.h"
#import "World.h"

// Player spawn delay in seconds.
#define kSpawnDelay 3.0

@interface Player ()

@property (nonatomic) PlayerState state;
@property (nonatomic) CGFloat     health;
@property (nonatomic) CGFloat     energy;
@property (nonatomic) NSUInteger  kills;

@end

@implementation Player {
  // The enqueued player action.
  PlayerAction *_action;
}

- (Player *)initWithUUID:(NSUUID *)uuid {
  if (self = [super init]) {
    _uuid   = uuid;
    _state  = PlayerStateDead;
    _deaths = 0;
    _kills  = 0;
    _age    = 0;
    _energy = 0;
    _health = 0;
  }

  return self;
}

- (BOOL)enqueueAction:(PlayerAction *)action error:(GameError **)error {
  BOOL result = ([action validateForPlayer:self error:error]);

  if (result) {
    _action = action;
  }

  return result;
}

- (void)tick {
  // Default to the idle action (if the player is alive).
  if (!_action && self.isAlive) {
    _action = [[PlayerIdleAction alloc] init];
  }

  // Apply the action.
  [_action applyToPlayer:self];

  // Subtract the action cost.
  _energy = CLAMP(_energy - _action.cost, 0.0f, 100.0f);

  // Clear the current action.
  _action = nil;

  // Increment the entity age.
  _age += 1;
}

- (CGPoint)position {
  return _playerNode.position;
}

- (CGFloat)rotation {
  return _playerNode.zRotation;
}

- (CGPoint)velocity {
  return _playerNode.physicsBody.velocity;
}

- (CGFloat)angularVelocity {
  return _playerNode.physicsBody.angularVelocity;
}

- (BOOL)isAlive {
  return (_state != PlayerStateDead && _state != PlayerStateSpawning);
}

- (BOOL)isDead {
  return (_state == PlayerStateDead);
}

- (BOOL)isSpawning {
  return (_state == PlayerStateSpawning);
}

- (void)idle {
  _state = PlayerStateIdle;
  NSLog(@"Player idling %@.", [_uuid UUIDString]);
}

- (void)spawn {
  NSAssert(self.isDead, @"Player is alive");
  _state = PlayerStateSpawning;
  [NSTimer scheduledTimerWithTimeInterval:kSpawnDelay
                                   target:self
                                 selector:@selector(didSpawn)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)die {
  NSAssert(self.isAlive, @"Player is dead");

  _deaths += 1;
  _state = PlayerStateDead;

  // Notify the world that the player died.
  [_world playerDidDie:self];

  _playerNode = nil;

  NSLog(@"Player died %@.", [_uuid UUIDString]);
}

- (void)attack {
  NSAssert(self.isAlive, @"Player is dead");
  _state = PlayerStateAttacking;
  BulletNode *bullet = [[BulletNode alloc] initWithPlayer:self];
  [_playerNode.scene addChild:bullet];
  NSLog(@"Player attacking %@ .", [_uuid UUIDString]);
}

- (void)moveByX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration {
  NSAssert(self.isAlive, @"Player is dead");
  _state = PlayerStateMoving;
  SKAction *action = [SKAction moveByX:x y:y duration:duration];
  [_playerNode runAction:action];
  NSLog(@"Player moving %@ to (%f, %f).", [_uuid UUIDString], x, y);
}

- (void)rotateByAngle:(CGFloat)angle duration:(NSTimeInterval)duration {
  NSAssert(self.isAlive, @"Player is dead");
  _state = PlayerStateTurning;
  SKAction *action = [SKAction rotateByAngle:angle duration:duration];
  [_playerNode runAction:action];
  NSLog(@"Player turning %@ by %f.", [_uuid UUIDString], angle);
}

#pragma mark - PlayerDelegate

- (void)wasShotByPlayer:(Player *)player {
  // An entity can't shoot themselves.
  if (player == self) return;

  // Apply damage.
  _health = MAX(_health - 10.0f, 0.0f);

  // Check if the player died.
  if (_health == 0.0f) {
    [self die];

    // Increment the kills for the killer.
    player.kills += 1;
  }
}

#pragma mark - Serializable

- (NSDictionary *)asJSON {
  return @{@"id":              [_uuid UUIDString],
           @"state":           [Player playerStateAsString:_state],
           @"deaths":          [NSNumber numberWithUnsignedInteger:_deaths],
           @"kills":           [NSNumber numberWithUnsignedInteger:_kills],
           @"age":             [NSNumber numberWithUnsignedInteger:_age],
           @"energy":          [NSNumber numberWithFloat:_energy],
           @"health":          [NSNumber numberWithFloat:_health],
           @"position":        [NSDictionary dictionaryWithPoint:self.position],
           @"rotation":        [NSNumber numberWithFloat:self.rotation],
           @"velocity":        [NSDictionary dictionaryWithPoint:self.velocity],
           @"angularVelocity": [NSNumber numberWithFloat:self.angularVelocity]};
}

#pragma mark - Private

+ (NSString *)playerStateAsString:(PlayerState) state {
  switch (state) {
    case PlayerStateSpawning:  return @"spawning";
    case PlayerStateIdle:      return @"idle";
    case PlayerStateAttacking: return @"attacking";
    case PlayerStateMoving:    return @"moving";
    case PlayerStateTurning:   return @"turning";
    default:                   return @"dead";
  }
}

- (void)didSpawn {
  _playerNode = [[PlayerNode alloc] initWithPlayer:self];
  _playerNode.position = CGPointMake(RANDOM() * 500, RANDOM() * 500);

  _state  = PlayerStateIdle;
  _health = 100.0f;
  _energy = 100.0f;

  // Notify the world that the player spawned.
  [_world playerDidSpawn:self];

  NSLog(@"Player %@ spawned at (%f, %f).", [self.uuid UUIDString], self.position.x, self.position.y);
}

@end
