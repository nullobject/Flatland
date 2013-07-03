//
//  PlayerAction.m
//  Flatland
//
//  Created by Josh Bassett on 2/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "Player.h"
#import "PlayerAction.h"

@implementation PlayerAction

- (CGFloat)cost {
  CGFloat amount = [(NSNumber *)[_options objectForKey:@"amount"] floatValue];
  CGFloat absAmount = ABS(NORMALIZE(amount));

  switch (_type) {
    case PlayerActionTypeIdle:   return  10;
    case PlayerActionTypeMove:   return -20 * absAmount;
    case PlayerActionTypeTurn:   return -20 * absAmount;
    case PlayerActionTypeAttack: return -20;
    default:                     return   0;
  }
}

- (id)initWithType:(PlayerActionType)type andOptions:(NSDictionary *)options {
  if (self = [super init]) {
    _type = type;
    _options = options;
  }

  return self;
}

- (void)applyToPlayer:(Player *)player {
  CGFloat amount = [(NSNumber *)[_options objectForKey:@"amount"] floatValue];

  switch (_type) {
    case PlayerActionTypeSpawn:
      [player spawn];
      break;
    case PlayerActionTypeSuicide:
      [player suicide];
      break;
    case PlayerActionTypeIdle:
      [player idle];
      break;
    case PlayerActionTypeMove:
      [player moveBy:amount];
      break;
    case PlayerActionTypeTurn:
      [player turnBy:amount];
      break;
    case PlayerActionTypeAttack:
      [player attack];
      break;
  }

  // Update the entity energy.
  player.entity.energy += self.cost;
}

+ (id)playerActionWithType:(PlayerActionType)type andOptions:(NSDictionary *)options {
  return [[self alloc] initWithType:type andOptions:options];
}

@end
