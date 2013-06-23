//
//  MyScene.h
//  flatland
//

//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WorldScene : SKScene

- (void)addShip:(CGPoint)position;
- (NSDictionary *)asJSON;
- (NSData *)toJSON;

@end
