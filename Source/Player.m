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
#import "World.h"

// Movement speed in metres per second.
#define kMovementSpeed 100.0

// Rotation speed in radians per second.
#define kRotationSpeed M_TAU

@interface Player ()

@property (nonatomic, readonly) BOOL isAlive;
@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGFloat rotation;
@property (nonatomic, readonly) CGPoint velocity;
@property (nonatomic, readonly) CGFloat angularVelocity;

@end

@implementation Player {
  // The enqueued player action.
  PlayerAction *_action;
}

- (Player *)initWithUUID:(NSUUID *)uuid {
  if (self = [super init]) {
    _uuid   = uuid;
    _state = PlayerStateDead;
    _deaths = 0;
    _kills  = 0;
    _age    = 0;
    _energy = 100.0f;
    _health = 100.0f;
  }

  return self;
}

- (void)enqueueAction:(PlayerAction *)action error:(GameError **)error {
  if (self.isDead && action.type != PlayerActionTypeSpawn) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerNotSpawned
                                      userInfo:nil];
    return;
  } else if (self.isAlive && action.type == PlayerActionTypeSpawn) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerAlreadySpawned
                                      userInfo:nil];
    return;
  } else if (self.isAlive && action.cost + _energy < 0) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerInsufficientEnergy
                                      userInfo:nil];
    return;
  }

  _action = action;
}

- (void)tick {
  // Default to the idle action (if the player is alive).
  if (self.isAlive && !_action) {
    _action = [PlayerAction playerActionWithType:PlayerActionTypeIdle andOptions:nil];
  }

  // Apply the action.
  [_action applyToPlayer:self];

  // Clear the current action.
  _action = nil;

  // Increment the entity age.
  _age += 1;
}

- (void)setEnergy:(CGFloat)energy {
  _energy = CLAMP(energy, 0.0f, 100.0f);
}

- (void)setHealth:(CGFloat)health {
  _health = CLAMP(health, 0.0f, 100.0f);
}

#pragma mark - Actions

- (void)spawn {
  NSAssert(self.isDead, @"Player has already spawned");
  NSLog(@"Spawning player %@ in %f seconds.", [self.uuid UUIDString], kSpawnDelay);
  _state = PlayerStateSpawning;
  [NSTimer scheduledTimerWithTimeInterval:kSpawnDelay
                                   target:self
                                 selector:@selector(didSpawn)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)suicide {
  NSAssert(self.isAlive, @"Player has not spawned");
  NSLog(@"Killing player %@.", [self.uuid UUIDString]);
  [self didDie];
}

- (void)idle {
  NSAssert(self.isAlive, @"Player has not spawned");
  NSLog(@"Idling player %@.", [self.uuid UUIDString]);
}

- (void)moveBy:(CGFloat)amount {
  NSAssert(self.isAlive, @"Player has not spawned");
  NSLog(@"Moving player %@ by %f.", [self.uuid UUIDString], amount);

  CGFloat clampedAmount = NORMALIZE(amount),
          x = -sinf(self.rotation) * clampedAmount * kMovementSpeed,
          y =  cosf(self.rotation) * clampedAmount * kMovementSpeed;

  // Calculate the time it takes to move the given amount.
  NSTimeInterval duration = (DISTANCE(x, y) * ABS(clampedAmount)) / kMovementSpeed;

  _state = PlayerStateMoving;

  [_playerNode runAction:[SKAction moveByX:x y:y duration:duration]];
}

- (void)turnBy:(CGFloat)amount {
  NSAssert(self.isAlive, @"Player has not spawned");
  NSLog(@"Turning player %@ by %f.", [self.uuid UUIDString], amount);

  CGFloat clampedAmount = NORMALIZE(amount),
          angle = clampedAmount * kRotationSpeed;

  // Calculate the time it takes to turn the given amount.
  NSTimeInterval duration = (M_TAU * ABS(clampedAmount)) / kRotationSpeed;

  _state = PlayerStateTurning;

  [_playerNode runAction:[SKAction rotateByAngle:angle duration:duration]];
}

- (void)attack {
  NSAssert(self.isAlive, @"Player has not spawned");
  NSLog(@"Player attacking %@ .", [self.uuid UUIDString]);

  BulletNode *bullet = [[BulletNode alloc] initWithPlayer:self];

  _state = PlayerStateAttacking;

  [_playerNode.scene addChild:bullet];
}

#pragma mark - EntityDelegate

- (void)wasShotByPlayer:(Player *)player {
  // An entity can't shoot themselves.
  if (player == self) return;

  // Apply damage.
  self.health -= 10.0f;

  // If the entity was killed then notify both the deceased and the shooter.
  if (_health == 0.0f) {
    [player didKillPlayer:self];
    [self wasKilledByPlayer:player];
  }
}

- (void)didKillPlayer:(Player *)entity {
  _kills += 1;
}

- (void)wasKilledByPlayer:(Player *)entity {
  [self didDie];
}

#pragma mark - Serializable

- (NSDictionary *)asJSON {
//  id entity = _playerNode ? [_playerNode asJSON] : [NSNull null];

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

- (BOOL)isAlive {
  return (_state != PlayerStateDead && _state != PlayerStateSpawning);
}

- (BOOL)isDead {
  return (_state == PlayerStateDead);
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

  NSLog(@"Player %@ spawned at (%f, %f).", [self.uuid UUIDString], _playerNode.position.x, _playerNode.position.y);

  _state = PlayerStateIdle;

  // Notify the world that the player spawned.
  [_world didSpawnPlayer:self];
}

- (void)didDie {
  _state = PlayerStateDead;
  _deaths += 1;
  [_playerNode removeFromParent];
  _playerNode = nil;
}

@end
