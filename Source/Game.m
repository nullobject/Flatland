//
//  Game.m
//  Flatland
//
//  Created by Josh Bassett on 24/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Game.h"
#import "GameError.h"
#import "GCDTimer.h"
#import "NSBundle+InfoDictionaryKeyPath.h"
#import "Player.h"

@implementation Game {
  Server *_server;
  GCDTimer *_timer;
}

- (id)init {
  if (self = [super init]) {
    NSString *bundleName    = [[NSBundle mainBundle] objectForInfoDictionaryKeyPath:(NSString *)kCFBundleNameKey];
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKeyPath:(NSString *)kCFBundleVersionKey];
    NSString *copyright     = [[NSBundle mainBundle] objectForInfoDictionaryKeyPath:@"NSHumanReadableCopyright"];

    NSLog(@"%@ (%@)", bundleName, bundleVersion);
    NSLog(@"%@", copyright);

    [self setupServer];
    [self setupWorld];
    [self setupBattleScene];
    [self startTimer];
  }

  return self;
}

- (void)startServer {
  NSError *error;

	if (![_server start:&error]) {
		NSLog(@"Error starting server: %@", error);
	}
}

- (void)tick {
  NSLog(@"Game#tick");

  [_world tick];

  [_world.players enumerateKeysAndObjectsUsingBlock:^(NSUUID *uuid, Player *player, BOOL *stop) {
    [_server respondToPlayer:uuid withWorld:_world];
  }];
}

#pragma mark - ServerDelegate

- (void)server:(Server *)server didReceiveAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid {
  GameError *error;
  if (![_world enqueueAction:action forPlayer:uuid error:&error]) {
    [_server respondToPlayer:uuid withError:error];
  }
}

#pragma mark - Private

- (void)setupServer {
  _server = [[Server alloc] init];
  _server.delegate = self;
}

- (void)setupWorld {
  _world = [[World alloc] init];
}

- (void)setupBattleScene {
  _battleScene = [BattleScene sceneWithSize:CGSizeMake(1024, 768)];

  // Set the scale mode to scale to fit the window.
  _battleScene.scaleMode = SKSceneScaleModeAspectFit;

  // Added the world node to the battle scene.
  [_battleScene addChild:_world.worldNode];
}

- (void)startTimer {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  _timer = [GCDTimer timerOnQueue:queue];
  NSNumber *interval = [[NSBundle mainBundle] objectForInfoDictionaryKeyPath:@"Interval"];

  [_timer scheduleBlock:^{
    [self tick];
  } afterInterval:[interval doubleValue] repeat:YES];
}

@end
