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

@implementation AppDelegate {
	RoutingHTTPServer *httpServer;
}

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  WorldScene *world = [WorldScene sceneWithSize:CGSizeMake(1024, 768)];

  // Set the scale mode to scale to fit the window.
  world.scaleMode = SKSceneScaleModeAspectFit;

  [self.skView presentScene:world];

  self.skView.showsFPS       = YES;
  self.skView.showsNodeCount = YES;
  self.skView.showsDrawCount = YES;

  httpServer = [[RoutingHTTPServer alloc] init];
  [httpServer setPort:8000];
  [httpServer setDefaultHeader:@"Server" value:@"Flatland/1.0"];

	[httpServer get:@"/spawn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:[request header:@"X-Player"]];
    [world spawn:UUID];
//    [world addShip:CGPointMake(RANDOM() * 500, RANDOM() * 500)];
    [response setHeader:@"Content-Type" value:@"application/json"];
    [response respondWithData:[world toJSON]];
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
