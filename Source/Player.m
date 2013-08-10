//
//  Player.m
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BulletNode.h"
#import "Core.h"
#import "GCDTimer.h"
#import "Player.h"
#import "World.h"

// The damage applied when a player is shot (in energy units).
#define kBulletDamage 20.0

@interface Player ()

@property (nonatomic) PlayerNode  *playerNode;
@property (nonatomic) PlayerState state;
@property (nonatomic) CGFloat     health;
@property (nonatomic) CGFloat     energy;
@property (nonatomic) NSUInteger  kills;

@end

@implementation Player

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

- (BOOL)applyAction:(PlayerAction *)action completion:(void (^)(void))block error:(GameError **)error {
  BOOL result = ([action validateForPlayer:self error:error]);

  if (result) {
    // Apply the action.
    [action applyToPlayer:self completion:block];

    // Subtract the action cost.
    self.energy = CLAMP(_energy - action.cost, 0.0f, 100.0f);
  }

  return result;
}

- (void)tick {
  // Increment the entity age.
  _age += 1;
}

- (CGPoint)position {
  return _playerNode.position;
}

- (CGFloat)rotation {
  return _playerNode.zRotation;
}

- (CGVector)velocity {
  return _playerNode.physicsBody.velocity;
}

- (CGFloat)angularVelocity {
  return _playerNode.physicsBody.angularVelocity;
}

- (BOOL)isAlive {
  return (_state != PlayerStateDead);
}

#pragma mark - Actions

- (void)spawn:(NSTimeInterval)duration completion:(void (^)(void))block {
  NSAssert(!self.isAlive, @"Player is alive");

  GCDTimer *timer = [GCDTimer timerOnMainQueue];
  [timer scheduleBlock:^{
    [self didSpawn];
    block();
  } afterInterval:duration];
}

- (void)rest:(NSTimeInterval)duration completion:(void (^)(void))block {
  NSAssert(self.isAlive, @"Player is dead");

  _state = PlayerStateResting;

  GCDTimer *timer = [GCDTimer timerOnMainQueue];
  [timer scheduleBlock:block afterInterval:duration];

  NSLog(@"Player resting %@.", [_uuid UUIDString]);
}

- (void)attack:(NSTimeInterval)duration completion:(void (^)(void))block {
  NSAssert(self.isAlive, @"Player is dead");

  _state = PlayerStateAttacking;

  BulletNode *bullet = [[BulletNode alloc] initWithPlayer:self];
  [_world player:self didShootBullet:bullet];

  GCDTimer *timer = [GCDTimer timerOnMainQueue];
  [timer scheduleBlock:block afterInterval:duration];

  NSLog(@"Player attacking %@ .", [_uuid UUIDString]);
}

- (void)moveByX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration completion:(void (^)(void))block {
  NSAssert(self.isAlive, @"Player is dead");

  _state = PlayerStateMoving;

  SKAction *action = [SKAction moveByX:x y:y duration:duration];
  [_playerNode runAction:action completion:block];

  NSLog(@"Player moving %@ to (%f, %f).", [_uuid UUIDString], x, y);
}

- (void)rotateByAngle:(CGFloat)angle duration:(NSTimeInterval)duration completion:(void (^)(void))block {
  NSAssert(self.isAlive, @"Player is dead");

  _state = PlayerStateTurning;

  SKAction *action = [SKAction rotateByAngle:angle duration:duration];
  [_playerNode runAction:action completion:block];

  NSLog(@"Player turning %@ by %f.", [_uuid UUIDString], angle);
}

- (void)suicide:(NSTimeInterval)duration completion:(void (^)(void))block {
  NSAssert(self.isAlive, @"Player is dead");

  [self didDie];

  GCDTimer *timer = [GCDTimer timerOnMainQueue];
  [timer scheduleBlock:block afterInterval:duration];
}

#pragma mark - Callbacks

- (void)didDie {
  _deaths += 1;
  _state = PlayerStateDead;

  // Notify the world that the player died.
  [_world playerDidDie:self];

  _playerNode = nil;

  NSLog(@"Player died %@.", [_uuid UUIDString]);
}

- (void)didSpawn {
  _playerNode = [[PlayerNode alloc] initWithPlayer:self];
  _playerNode.position = CGPointMake(RANDOM() * 500, RANDOM() * 500);

  _state  = PlayerStateResting;
  self.health = 100.0f;
  self.energy = 100.0f;

  // Notify the world that the player spawned.
  [_world playerDidSpawn:self];

  NSLog(@"Player %@ spawned at (%f, %f).", [self.uuid UUIDString], self.position.x, self.position.y);
}

- (void)wasShotByPlayer:(Player *)player {
  // An entity can't shoot themselves.
  if (player == self) return;

  // Apply damage.
  self.health = MAX(_health - kBulletDamage, 0.0f);

  // Check if the player died.
  if (_health == 0.0f) {
    [self didDie];

    // Increment the kills for the shooter.
    player.kills += 1;
  }
}

#pragma mark - Serializable

- (NSDictionary *)asJSON {
  return @{@"id":              [_uuid UUIDString],
           @"state":           [Player playerStateAsString:_state],
           @"age":             [NSNumber numberWithUnsignedInteger:_age],
           @"energy":          [NSNumber numberWithFloat:_energy],
           @"health":          [NSNumber numberWithFloat:_health],
           @"deaths":          [NSNumber numberWithUnsignedInteger:_deaths],
           @"kills":           [NSNumber numberWithUnsignedInteger:_kills],
           @"position":        (__bridge NSDictionary *)PointCreateDictionaryRepresentation(self.position),
           @"rotation":        [NSNumber numberWithFloat:self.rotation],
           @"velocity":        (__bridge NSDictionary *)VectorCreateDictionaryRepresentation(self.velocity),
           @"angularVelocity": [NSNumber numberWithFloat:self.angularVelocity]};
}

#pragma mark - Private

+ (NSString *)playerStateAsString:(PlayerState) state {
  switch (state) {
    case PlayerStateAttacking: return @"attacking";
    case PlayerStateMoving:    return @"moving";
    case PlayerStateResting:   return @"resting";
    case PlayerStateTurning:   return @"turning";
    default:                   return @"dead";
  }
}

@end
