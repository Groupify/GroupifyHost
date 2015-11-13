//
//  AppDelegate.m
//  Groupify
//
//  Created by Niki Wells on 9/19/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import "AppDelegate.h"
#import <PSWebSocket.h>
#import "SpotifyControls.h"
#import "MusicPlayerViewController.h"

@interface AppDelegate () <PSWebSocketDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) IBOutlet MusicPlayerViewController *musicPlayerVC;

@property (nonatomic, strong) PSWebSocket *socket;

@property (nonatomic) SpotifyControls *mainControls;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // spotify notification
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(playerStateChanged:) name:@"com.spotify.client.PlaybackStateChanged" object:nil];
    
    // Insert code here to initialize your application
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusItem.button.image = [NSImage imageNamed:@"tempTopBarGuy"];
    self.statusItem.button.action = @selector(printToConsole);
    
    // create the NSURLRequest that will be sent as the handshake
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://shroba.io:4545"]];
    
    // create the socket and assign delegate
    self.socket = [PSWebSocket clientSocketWithRequest:request];
    self.socket.delegate = self;
    
    // open socket
    [self.socket open];
    
    self.musicPlayerVC = [[MusicPlayerViewController alloc] initWithNibName:@"MusicPlayerViewController" bundle:nil];
    
    [self.window.contentView addSubview:self.musicPlayerVC.view];
    self.window.contentView.frame = ((NSView *) self.window.contentView).bounds;
    
    self.mainControls = [[SpotifyControls alloc] initWithMusicPlayerViewController:self.musicPlayerVC];
    
    NSString *jsonInfo = [NSString stringWithContentsOfFile:[@"~/test_server_data.json" stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil];
//    [self webSocket:self.socket didReceiveMessage:jsonInfo];
}

- (void)printToConsole {
    NSLog(@"Hello World!");
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self.socket close];
}

#pragma mark - notifications
-(void)playerStateChanged:(NSNotification *)notification
{
    id information = [notification userInfo];
    NSString *playbackState = information[@"Player State"];
    int duration = [information[@"Duration"] integerValue] / 1000;
    int position = [information[@"Playback Position"] integerValue];
    
    if ([playbackState isEqualToString:@"Paused"] && duration - position <= 1) {
        [self.mainControls playNextSong];
    }
    [self updateHostWithPlaybackState:playbackState andPlayerPositon:position];
}

- (void)updateHostWithPlaybackState:(NSString *)playbackState andPlayerPositon:(int)position
{
    NSDate *relativeStart = [[NSDate date] dateByAddingTimeInterval:-1 * position];
    NSString *updateString = [NSString stringWithFormat:@"{ \"action\": \"ping\", \"identity\": \"host\", \"data\": { \"relativeStartTime\": \"%@\", \"playerState\": \"%@\"}}", relativeStart, playbackState];
    [self.socket send:updateString];
}


#pragma mark - PSWebSocketDelegate

- (void)webSocketDidOpen:(PSWebSocket *)webSocket {
    NSLog(@"The websocket handshake completed and is now open!");
    [webSocket send:@"{ \"action\": \"hello\", \"identity\": \"host\", \"data\": { \"message\": \"Hi there backend!\"} }"];
}

- (void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"The websocket received a message: %@", message);
    id queueJSONObject = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:0
                                                           error:nil];
    NSDictionary *data = (NSDictionary *)queueJSONObject;
    NSString *action = data[@"action"];
    if ([action isEqualToString:@"update-queue"]) {
        NSArray *songs = data[@"data"][@"songs"];
        [self.mainControls updateQueueWithArray:songs];
    } else if ([action isEqualToString:@"playImmediately"]) {
        NSDictionary *songData =data[@"data"][@"song"];
        [self.mainControls playSongImmediately:songData];
    }
}

- (void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"The websocket handshake/connection failed with an error: %@", error);
}

- (void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"The websocket closed with code: %@, reason: %@, wasClean: %@", @(code), reason, (wasClean) ? @"YES" : @"NO");
}

@end
