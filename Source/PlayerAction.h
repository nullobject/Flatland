//
//  PlayerAction.h
//  Flatland
//
//  Created by Josh Bassett on 2/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;

// Represents an action submitted by a player.
@interface PlayerAction : NSObject

@property (nonatomic, readonly, strong) NSDictionary *options;
@property (nonatomic, readonly) CGFloat cost;

- (id)initWithOptions:(NSDictionary *)options;

- (void)applyToPlayer:(Player *)player;

@end
