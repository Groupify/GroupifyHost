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

- (void)updateQueueWithData:(NSString *)queueData;
- (void)updateQueueWithArray:(NSArray *)queueArray;
- (Song *)nextSongInQueue;
- (NSArray *)currentQueue;
- (BOOL)queueIsEmpty;

@end
