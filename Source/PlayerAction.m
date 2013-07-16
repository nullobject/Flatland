//
//  PlayerAction.m
//  Flatland
//
//  Created by Josh Bassett on 2/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"
#import "PlayerAction.h"

@implementation PlayerAction

- (CGFloat)cost {
  return 0;
}

- (id)initWithOptions:(NSDictionary *)options {
  if (self = [super init]) {
    _options = options;
  }

  return self;
}

- (void)applyToPlayer:(Player *)player {
  // Update the entity energy.
  player.energy += self.cost;
}

@end
