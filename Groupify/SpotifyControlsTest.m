//
//  SpotifyControlsTest.m
//  Groupify
//
//  Created by Niki Wells on 11/12/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SpotifyControls.h"

@interface SpotifyControlsTest : XCTestCase

@property (nonatomic) SpotifyControls *spotifyPlayer;

@end

@implementation SpotifyControlsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.spotifyPlayer = [[SpotifyControls alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSString *)getPlayerState
{
    NSAppleScript *scriptPlaying = [[NSAppleScript alloc] initWithSource:@"tell application \"Spotify\" to get player state"];
    NSAppleEventDescriptor *playerState = [scriptPlaying executeAndReturnError:nil];
    return [playerState stringValue];
}

- (void)pauseMusic
{
    NSAppleScript *pauseMusic = [[NSAppleScript alloc] initWithSource:@"tell application \"Spotify\" to pause"];
    [pauseMusic executeAndReturnError:nil];
}

- (void)testUpdateQueue {
    NSString *jsonInfo = [NSString stringWithContentsOfFile:[@"~/test_data.json" stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil];
    [self.spotifyPlayer updateQueue:jsonInfo];
    
    // assert queue nonempty
    XCTAssertFalse([self.spotifyPlayer queueIsEmpty]);
    
    NSString *playerState = [self getPlayerState];
    // assert song is playing
    XCTAssertTrue([playerState isEqualToString:@"kPSP"]);
    
    [self pauseMusic];
}

- (void)testPlayMusic {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.spotifyPlayer playMusic];
    
    NSString *playerState = [self getPlayerState];
    // assert song is playing
    XCTAssertTrue([playerState isEqualToString:@"kPSP"]);
}

@end
