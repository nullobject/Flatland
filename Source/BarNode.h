//
//  BarNode.h
//  Flatland
//
//  Created by Josh Bassett on 11/08/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BarNode : SKShapeNode

@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat value;

- (BarNode *)initWithSize:(CGSize)size color:(SKColor *)color;

@end
