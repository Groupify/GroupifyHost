//
//  Queue.m
//  Groupify
//
//  Created by Niki Wells on 11/3/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import "Queue.h"
#import "Song.h"

@interface Queue () <NSTableViewDataSource>

@property (nonatomic) NSMutableArray *songs;

@end

@implementation Queue

- (void)addNewSongFromSongInfo:(NSDictionary *)songInfo newSongs:(NSMutableArray *)newSongs
{
    Song *newSong = [[Song alloc] initWithSongName:songInfo[@"songName"]
                                            artist:songInfo[@"artist"]
                                             album:songInfo[@"album"]
                                       contributor:songInfo[@"contributor"]
                                          trackURI:songInfo[@"uri"]
                                       albumArtURL:songInfo[@"albumArt"]
                                            songID:[songInfo[@"id"] integerValue]
                                            length:[songInfo[@"length"] integerValue]];
    [newSongs addObject:newSong];
}

- (void)updateQueueWithArray:(NSArray *)queueArray
{
    NSMutableArray *newSongs = [[NSMutableArray alloc] init];
    for (NSDictionary *songInfo in queueArray) {
        if (self.songs) {
            NSUInteger songIndex = [self.songs indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Song *currentSong = (Song *) obj;
                if (currentSong.songID == [songInfo[@"id"] integerValue]) {
                    return YES;
                } else {
                    return NO;
                }
            }];
            if (songIndex != NSNotFound) {
                [newSongs addObject:self.songs[songIndex]];
            } else {
                [self addNewSongFromSongInfo:songInfo newSongs:newSongs];
            }
        } else {
            [self addNewSongFromSongInfo:songInfo newSongs:newSongs];
        }
    }
    self.songs = newSongs;

}

- (void)updateQueueWithData:(NSString *)queueData
{
    id queueJSONObject = [NSJSONSerialization JSONObjectWithData:[queueData dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:0
                                                           error:nil];
    NSArray *songData = ((NSDictionary *)queueJSONObject)[@"songs"];
    [self updateQueueWithArray:songData];
}

- (Song *)nextSongInQueue
{
    Song *nextSong = self.songs[0];
    [self.songs removeObject:nextSong];
    return nextSong;
}

- (NSArray *)currentQueue
{
    return self.songs;
}

- (BOOL)queueIsEmpty
{
    return [self.songs count] == 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row >= [self.songs count]) {
        return @"";
    }
    Song *songForRow = self.songs[row];
    
    // Get a new ViewCell
    //NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if ( [tableColumn.identifier isEqualToString:@"NameColumn"] ) {
        //cellView.textField.stringValue = songForRow.name;
        //return cellView;
        return songForRow.name;
    } else if ([tableColumn.identifier isEqualToString:@"ContributorColumn"]) {
        //cellView.textField.stringValue = songForRow.contributor;
        //return cellView;
        return songForRow.contributor;
    }
    return @"";
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.songs count];
}

@end
