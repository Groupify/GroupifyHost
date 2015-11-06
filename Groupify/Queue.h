//
//  Queue.h
//  Groupify
//
//  Created by Niki Wells on 11/3/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AppKit;

@class Song;

@interface Queue : NSObject <NSTableViewDataSource>

- (void)updateQueueWithData:(NSData *)queueData;
- (Song *)nextSongInQueue;
- (NSArray *)currentQueue;
- (BOOL)queueIsEmpty;

@end
