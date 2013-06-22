//
//  AppDelegate.m
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "AppDelegate.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyScene.h"

// Log levels: off, error, warn, info, verbose.
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation AppDelegate {
	HTTPServer *httpServer;
}

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  /* Pick a size for the scene */
  SKScene *scene = [MyScene sceneWithSize:CGSizeMake(1024, 768)];

  /* Set the scale mode to scale to fit the window */
  scene.scaleMode = SKSceneScaleModeAspectFit;

  [self.skView presentScene:scene];

  self.skView.showsFPS = YES;
  self.skView.showsNodeCount = YES;

	// Configure our logging framework.
	// To keep things simple and fast, we're just going to log to the Xcode console.
	[DDLog addLogger:[DDTTYLogger sharedInstance]];

	// Initalize our http server
	httpServer = [[HTTPServer alloc] init];

	// Tell the server to broadcast its presence via Bonjour.
	// This allows browsers such as Safari to automatically discover our service.
	[httpServer setType:@"_http._tcp."];

	// Normally there's no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for easy testing you may want force a certain port so you can just hit the refresh button.
  //	[httpServer setPort:12345];

	// Serve files from the standard Sites folder
	NSString *docRoot = [@"~/Sites" stringByExpandingTildeInPath];
	DDLogInfo(@"Setting document root: %@", docRoot);

	[httpServer setDocumentRoot:docRoot];

	NSError *error = nil;
	if(![httpServer start:&error]) {
		DDLogError(@"Error starting HTTP Server: %@", error);
	}
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

@end
