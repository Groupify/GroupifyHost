//
//  Song.h
//  Groupify
//
//  Created by Niki Wells on 9/21/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AppKit;

@interface Song : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *album;
@property (nonatomic) NSString *contributor;
@property (nonatomic) NSString *spotifyURI;
@property (nonatomic) NSImage  *albumArt;
@property (nonatomic) int songID;
@property (nonatomic) int length;

// custom initializer
- (instancetype)initWithSongName:(NSString *)name
                          artist:(NSString *)artist
                           album:(NSString *)album
                     contributor:(NSString *)contributor
                        trackURI:(NSString *)spotifyURI
                     albumArtURL:(NSString *)albumArtURL
                          songID:(int)songID
                          length:(int)length;

@end
