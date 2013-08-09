//
//  AttackPlayerTests.m
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AcceptanceTestCase.h"
#import "Core.h"
#import "NSArray+FP.h"

/* The assets are all facing Y down, so offset by pi half to get into X right facing. */
#define APA_POLAR_ADJUST(x) x + (M_PI * 0.5f)

@interface AttackPlayerTests : AcceptanceTestCase
@end

@implementation AttackPlayerTests

- (void)testAttackPlayer {
  NSUUID *uuid = [NSUUID UUID];

  [self performAsyncTestWithBlock:^(BOOL *stop) {
    [self doAction:@"spawn" forPlayer:uuid parameters:nil completion:^(NSDictionary *response) {
      [self doAction:@"attack" forPlayer:uuid parameters:@{@"amount": @1} completion:^(NSDictionary *response) {
        NSDictionary *player = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
          return [[uuid UUIDString] isEqualToString:[player objectForKey:@"id"]];
        }];

        expect([player objectForKey:@"state"]).to.equal(@"attacking");
        expect([player objectForKey:@"energy"]).to.equal(80);

        *stop = YES;
      }];
    }];
  } timeout:5];
}

CGFloat AngleBetweenVectors(CGVector a, CGVector b) {
  CGFloat dx = b.dx - a.dx;
  CGFloat dy = b.dy - a.dy;
  return atan2f(dy, dx);
}

//CGDictionaryRef CGVectorCreateDictionaryRepresentaiton(CGVector vector) {
//
//}

BOOL CGVectorMakeWithDictionaryRepresentation(CFDictionaryRef dictionaryRef, CGVector *vector) {
  CFNumberRef dxRef = CFDictionaryGetValue(dictionaryRef, CFSTR("x"));
  CFNumberRef dyRef = CFDictionaryGetValue(dictionaryRef, CFSTR("y"));

  CGFloat dx, dy;

  CFNumberGetValue(dxRef, kCFNumberCGFloatType, &dx);
  CFNumberGetValue(dyRef, kCFNumberCGFloatType, &dy);

  vector->dx = dx;
  vector->dy = dy;

  return YES;
}

- (void)testShootPlayer {
  NSUUID *uuid1 = [NSUUID UUID];
  NSUUID *uuid2 = [NSUUID UUID];
  NSDictionary *response;

  response = [self doSyncAction:@"spawn" forPlayer:uuid1 parameters:nil timeout:5];
  NSDictionary *player1 = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
    return [[uuid1 UUIDString] isEqualToString:[player objectForKey:@"id"]];
  }];

  response = [self doSyncAction:@"spawn" forPlayer:uuid2 parameters:nil timeout:5];
  NSDictionary *player2 = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
    return [[uuid2 UUIDString] isEqualToString:[player objectForKey:@"id"]];
  }];

  CGVector a, b;

  CGVectorMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)[player1 objectForKey:@"position"], &a);
  CGVectorMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)[player2 objectForKey:@"position"], &b);

  CGFloat angle = APA_POLAR_ADJUST(AngleBetweenVectors(a, b));
  CGFloat amount = angle / M_TAU;

  NSLog(@"%f %f", angle, amount);

  [self doSyncAction:@"turn" forPlayer:uuid2 parameters:@{@"amount": [NSNumber numberWithFloat:amount]} timeout:3];

  BOOL alive = YES;

  while (alive) {
    response = [self doSyncAction:@"attack" forPlayer:uuid2 parameters:@{@"amount": @1} timeout:3];

    if ([response objectForKey:@"error"]) {
      [self doSyncAction:@"rest" forPlayer:uuid2 parameters:@{@"amount": @1} timeout:3];
    } else {
      player1 = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
        return [[uuid1 UUIDString] isEqualToString:[player objectForKey:@"id"]];
      }];

      alive = [[player1 objectForKey:@"health"] floatValue] > 0;
    }
  }
}

- (void)testAttackPlayerWhenPlayerIsDead {
  NSUUID *uuid = [NSUUID UUID];

  [self performAsyncTestWithBlock:^(BOOL *stop) {
    [self doAction:@"attack" forPlayer:uuid parameters:@{@"amount": @1} completion:^(NSDictionary *response) {
      expect([response objectForKey:@"code"]).to.equal(4);
      expect([response objectForKey:@"error"]).to.equal(@"Player has not spawned");

      *stop = YES;
    }];
  } timeout:5];
}

@end
