//
//  Song.m
//  Groupify
//
//  Created by Niki Wells on 9/21/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import "Song.h"

@implementation Song

// default initializer
// sets all attributes to nil for safety
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = nil;
        self.artist = nil;
        self.contributor = nil;
        self.spotifyURI = nil;
        self.albumArt = nil;
    }
    return self;
}

// custom initializer
// sets all attributes to appropriate values
- (instancetype)initWithSongName:(NSString *)name
                          artist:(NSString *)artist
                           album:(NSString *)album
                     contributor:(NSString *)contributor
                        trackURI:(NSString *)spotifyURI
                     albumArtURL:(NSString *)albumArt
                          songID:(int)songID
                          length:(int)length
{
    self = [super init];
    if (self) {
        self.name = name;
        self.artist = artist;
        self.album = album;
        self.contributor = contributor;
        self.spotifyURI = spotifyURI;
        self.songID = songID;
        self.length = length;
        
        // fetches album art
        NSURL *albumArtURL = [[NSURL alloc] initWithString:albumArt];
        self.albumArt = [[NSImage alloc] initWithContentsOfURL:albumArtURL];
    }
    return self;
}

@end
