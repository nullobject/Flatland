//
//  Bullet.h
//  Flatland
//
//  Created by Josh Bassett on 4/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bullet : SKSpriteNode

@property (nonatomic, readonly, strong) NSUUID *uuid;

// Initializes a new bullet.
- (Bullet *)initWithEntity:(NSUUID *)uuid;

@end
