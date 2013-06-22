//
//  AppDelegate.m
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "AppDelegate.h"
#import "RoutingHTTPServer.h"
#import "MyScene.h"

@implementation AppDelegate {
	RoutingHTTPServer *httpServer;
}

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  SKScene *scene = [MyScene sceneWithSize:CGSizeMake(1024, 768)];

  // Set the scale mode to scale to fit the window.
  scene.scaleMode = SKSceneScaleModeAspectFit;

  [self.skView presentScene:scene];

  self.skView.showsFPS = YES;
//  self.skView.showsNodeCount = YES;

  httpServer = [[RoutingHTTPServer alloc] init];
  [httpServer setPort:8000];
  [httpServer setDefaultHeader:@"Server" value:@"Flatland/1.0"];

	[httpServer get:@"/hello" withBlock:^(RouteRequest *request, RouteResponse *response) {
    [response setHeader:@"Content-Type" value:@"application/json"];
		[response respondWithString:@"{name:1}"];
	}];

	[httpServer get:@"/hello/:name" withBlock:^(RouteRequest *request, RouteResponse *response) {
    [response setHeader:@"Content-Type" value:@"application/json"];
		[response respondWithString:[NSString stringWithFormat:@"{name:\"%@\"}", [request param:@"name"]]];
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
