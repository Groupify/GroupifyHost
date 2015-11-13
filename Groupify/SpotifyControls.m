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

- (void)updateQueue:(NSString *)queueData
{
    BOOL queueWasEmpty = [self.queue queueIsEmpty];
    [self.queue updateQueueWithData:queueData];
    if (queueWasEmpty) {
        [self playNextSong];
    }
}

- (void)updateQueueWithArray:(NSArray *)queueData
{
    BOOL queueWasEmpty = [self.queue queueIsEmpty];
    [self.queue updateQueueWithArray:queueData];
    if (queueWasEmpty) {
        [self playNextSong];
    }
}

- (void)playMusic
{
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

- (void)playSongImmediately:(NSDictionary *)songInfo
{
    Song *newSong = [[Song alloc] initWithSongName:songInfo[@"songName"]
                                            artist:songInfo[@"artist"]
                                             album:songInfo[@"album"]
                                       contributor:songInfo[@"contributor"]
                                          trackURI:songInfo[@"uri"]
                                       albumArtURL:songInfo[@"albumArt"]
                                            songID:[songInfo[@"id"] integerValue]
                                            length:[songInfo[@"length"] integerValue]];
    
    // build and execute AppleScript to play said song
    [self queueNextSong:newSong.spotifyURI];
    [self.playNext executeAndReturnError:nil];
    
    // update the view controller
    [self.musicPlayerVC currentSong:newSong];
    [self.musicPlayerVC currentQueue:self.queue];
}

- (void)queueNextSong:(NSString *)songURI
{
    NSString *scriptString = [NSString stringWithFormat:@"tell application \"Spotify\" to play track \"%@\"", songURI];
    
    self.playNext = [[NSAppleScript alloc] initWithSource:scriptString];
    [self.playNext compileAndReturnError:nil];
}

- (BOOL)queueIsEmpty
{
    return [self.queue queueIsEmpty];
}

@end
