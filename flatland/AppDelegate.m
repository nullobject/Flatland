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

NSString *kXPlayer     = @"X-Player";
NSString *kContentType = @"Content-Type";
NSString *kServer      = @"Server";

@implementation AppDelegate {
  WorldScene *_world;
	RoutingHTTPServer *_server;
}

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  _world = [self world];
  _server = [self HTTPServer];

  NSError *error;

	if (![_server start:&error]) {
		NSLog(@"Error starting HTTP server: %@", error);
	}
}

- (WorldScene *)world {
  WorldScene *world = [WorldScene sceneWithSize:CGSizeMake(1024, 768)];

  // Set the scale mode to scale to fit the window.
  world.scaleMode = SKSceneScaleModeAspectFit;

  [self.skView presentScene:world];

  self.skView.showsFPS       = YES;
  self.skView.showsNodeCount = YES;
  self.skView.showsDrawCount = YES;

  return world;
}

- (RoutingHTTPServer *)HTTPServer {
  RoutingHTTPServer *server = [[RoutingHTTPServer alloc] init];

  [server setPort:8000];
  [server setDefaultHeader:kServer value:@"Flatland/1.0"];

	[server get:@"/spawn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    [_world spawn:UUID];
    [response setHeader:kContentType value:@"application/json"];
    [response respondWithData:[_world toJSON]];
	}];

  return server;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

@end
