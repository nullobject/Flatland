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
    NSString *bundleName    = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKeyPath:(NSString *)kCFBundleNameKey];
    NSString *bundleVersion = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKeyPath:(NSString *)kCFBundleVersionKey];
    NSString *copyright     = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKeyPath:@"NSHumanReadableCopyright"];

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
}

#pragma mark - ServerDelegate

- (void)server:(Server *)server didReceiveAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid {
  GameError *error;
  BOOL result = [_world enqueueAction:action
                            forPlayer:uuid
                           completion:^{ [_server respondToPlayer:uuid withWorld:_world]; }
                                error:&error];
  if (!result) {
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
  _battleScene = [[BattleScene alloc] initWithWorld:_world size:CGSizeMake(1024, 768)];

  // Set the scale mode to scale to fit the window.
  _battleScene.scaleMode = SKSceneScaleModeAspectFit;

  // Added the world node to the battle scene.
  [_battleScene addChild:_world.worldNode];
}

- (void)startTimer {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  _timer = [GCDTimer timerOnQueue:queue];
  NSNumber *interval = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKeyPath:@"Interval"];

  [_timer scheduleBlock:^{
    [self tick];
  } afterInterval:[interval doubleValue] repeat:YES];
}

@end
