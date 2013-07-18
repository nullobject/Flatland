//
//  PlayerSuicideAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"
#import "PlayerSuicideAction.h"

@implementation PlayerSuicideAction

- (void)applyToPlayer:(Player *)player {
  [player die];
}

@end
