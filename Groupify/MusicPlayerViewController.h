//
//  SongAndQueueViewController.h
//  Groupify
//
//  Created by Niki Wells on 11/5/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import AppKit;

@class Song;
@class Queue;

@interface MusicPlayerViewController : NSViewController

- (void)currentSong:(Song *)newSong;
- (void)currentQueue:(Queue *)newQueue;

@end
