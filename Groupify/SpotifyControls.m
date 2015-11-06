//
//  SpotifyControls.m
//  Groupify
//
//  Created by Niki Wells on 9/19/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import "SpotifyControls.h"
#import "Queue.h"
#import "Song.h"
#import "MusicPlayerViewController.h"

@interface SpotifyControls ()

// applescript commands
@property (nonatomic) NSAppleScript *getPlayerPosition;
@property (nonatomic) NSAppleScript *getSongLength;
@property (nonatomic) NSAppleScript *startPlayer;
@property (nonatomic) NSAppleScript *pausePlayer;
@property (nonatomic) NSAppleScript *playNext;

@property (nonatomic) Queue *queue;

@property (nonatomic, weak) MusicPlayerViewController *musicPlayerVC;

@end

@implementation SpotifyControls

// default initializer - shouldn't be called 
- (instancetype)init
{
    self = [super init];
    if (self) {
        // build and compile applescript commands
        self.getPlayerPosition = [[NSAppleScript alloc] initWithSource:@"tell application \"Spotify\"\n  set position to get player position\n  return position\nend tell"];
        [self.getPlayerPosition compileAndReturnError:nil];
        
        self.getSongLength = [[NSAppleScript alloc] initWithSource:@"tell application \"Spotify\"\n set songlength to get duration of current track\n   return songlength\nend tell"];
        [self.getSongLength compileAndReturnError:nil];
        
        self.startPlayer = [[NSAppleScript alloc] initWithSource:@"tell application \"Spotify\" to play"];
        [self.startPlayer compileAndReturnError:nil];
        
        self.pausePlayer = [[NSAppleScript alloc] initWithSource:@"tell application \"Spotify\" to pause"];
        [self.pausePlayer compileAndReturnError:nil];
        
        self.queue = [[Queue alloc] init];
        
        self.musicPlayerVC = nil;
    }
    return self;
}

- (instancetype)initWithMusicPlayerViewController:(MusicPlayerViewController *)musicPlayerVC
{
    self = [self init];
    if (self) {
        self.musicPlayerVC = musicPlayerVC;
    }
    return self;
}

- (void)playMusic
{
    // read in sample data file
    NSData *jsonInfo = [NSData dataWithContentsOfFile:[@"~/test_data.json" stringByExpandingTildeInPath]];
    [self.queue updateQueueWithData:jsonInfo];
    [self playNextSong];
}

- (void)playNextSong
{
    if (![self.queue queueIsEmpty]) {
        Song *newSong = [self.queue nextSongInQueue];
        
        // build and execute AppleScript to play said song
        [self queueNextSong:newSong.spotifyURI];
        [self.playNext executeAndReturnError:nil];
        
        // update the view controller
        [self.musicPlayerVC currentSong:newSong];
        [self.musicPlayerVC currentQueue:self.queue];
    }
}

- (void)queueNextSong:(NSString *)songURI
{
    NSString *scriptString = [NSString stringWithFormat:@"tell application \"Spotify\" to play track \"%@\"", songURI];
    
    self.playNext = [[NSAppleScript alloc] initWithSource:scriptString];
    [self.playNext compileAndReturnError:nil];
}

@end
