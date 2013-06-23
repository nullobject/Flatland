//
//  AppDelegate.m
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "AppDelegate.h"
#import "RoutingHTTPServer.h"
#import "WorldScene.h"

#define RANDOM() (arc4random() / (float)(0xffffffffu))

@implementation AppDelegate {
	RoutingHTTPServer *httpServer;
}

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  WorldScene *world = [WorldScene sceneWithSize:CGSizeMake(1024, 768)];

  // Set the scale mode to scale to fit the window.
  world.scaleMode = SKSceneScaleModeAspectFit;

  [self.skView presentScene:world];

  self.skView.showsFPS = YES;
  self.skView.showsNodeCount = YES;

  httpServer = [[RoutingHTTPServer alloc] init];
  [httpServer setPort:8000];
  [httpServer setDefaultHeader:@"Server" value:@"Flatland/1.0"];

	[httpServer get:@"/hello" withBlock:^(RouteRequest *request, RouteResponse *response) {
    [world addShip:CGPointMake(RANDOM() * 500, RANDOM() * 500)];
    [response setHeader:@"Content-Type" value:@"application/json"];
    [response respondWithData:[world toJSON]];
	}];

	[httpServer get:@"/hello/:name" withBlock:^(RouteRequest *request, RouteResponse *response) {
    [response setHeader:@"Content-Type" value:@"application/json"];
		[response respondWithString:[NSString stringWithFormat:@"{name:\"%@\"}\n", [request param:@"name"]]];
	}];

  NSError *error;

	if (![httpServer start:&error]) {
		NSLog(@"Error starting HTTP server: %@", error);
	}
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

@end
