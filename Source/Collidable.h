//
//  Collidable.h
//  Flatland
//
//  Created by Josh Bassett on 8/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

@protocol Collidable <NSObject>

- (void)didCollideWith:(SKPhysicsBody *)body;

@end
