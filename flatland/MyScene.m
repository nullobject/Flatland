//
//  MyScene.m
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

- (id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    self.backgroundColor = [SKColor colorWithRed:0.15f green:0.15f blue:0.3f alpha:1.0f];

//    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    
//    myLabel.text = @"Hello, World!";
//    myLabel.fontSize = 65;
//    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));
//    [self addChild:myLabel];

    self.physicsWorld.gravity = CGPointMake(0.0f, -9.8f);

    [self addCollisionWallAtWorldPoint:CGPointMake(0.0f, 0.0f) withWidth:self.frame.size.width height:1.0f];
    [self addCollisionWallAtWorldPoint:CGPointMake(0.0f, 0.0f) withWidth:1.0f height:self.frame.size.height];
    [self addCollisionWallAtWorldPoint:CGPointMake(0.0f, self.frame.size.height) withWidth:self.frame.size.width height:1.0f];
    [self addCollisionWallAtWorldPoint:CGPointMake(self.frame.size.width, 0.0f) withWidth:1.0f height:self.frame.size.height];
  }

  return self;
}

- (void)addCollisionWallAtWorldPoint:(CGPoint)worldPoint
                           withWidth:(CGFloat)width height:(CGFloat)height {
  CGRect rect = CGRectMake(0, 0, width, height);
  SKNode *wallNode = [SKNode node];
  wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
  wallNode.position = CGPointMake(worldPoint.x + rect.size.width * 0.5,
                                  worldPoint.y + rect.size.height * 0.5);
  wallNode.physicsBody.dynamic = NO;
  wallNode.physicsBody.friction = 1.0f;

  [self addChild:wallNode];
}

- (void)mouseDown:(NSEvent *)theEvent {
  CGPoint position = [theEvent locationInNode:self];
  [self addShip:position];
}

- (void)addShip:(CGPoint)position {
  SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
  
  sprite.position = position;
  sprite.scale = 0.25f;
  
  sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
  sprite.physicsBody.mass = 1.0f;
  sprite.physicsBody.restitution = 0.9f;

//  SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//  [sprite runAction:[SKAction repeatActionForever:action]];

  [self addChild:sprite];
}

- (void)update:(CFTimeInterval)currentTime {
  /* Called before each frame is rendered */
}

@end
