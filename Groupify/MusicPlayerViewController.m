//
//  SongAndQueueViewController.m
//  Groupify
//
//  Created by Niki Wells on 11/5/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "Song.h"
#import "Queue.h"

@interface MusicPlayerViewController ()

@property (weak) IBOutlet NSTextField *songNameTextField;
@property (weak) IBOutlet NSTextField *artistTextField;
@property (weak) IBOutlet NSTextField *albumTextField;
@property (weak) IBOutlet NSTextField *contributorTextField;
@property (weak) IBOutlet NSImageView *albumArtImageView;
@property (weak) IBOutlet NSTableView *queueTableView;


@property (nonatomic) Song *currentSong;
@property (nonatomic, weak) Queue *currentQueue;

@end

@implementation MusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NSLog(@"whaaaaat");
}

- (void)currentSong:(Song *)newSong
{
    self.currentSong = newSong;
    
    [self.songNameTextField setStringValue:newSong.name];
    [self.artistTextField setStringValue:newSong.artist];
    [self.albumTextField setStringValue:newSong.album];
    [self.contributorTextField setStringValue:[NSString stringWithFormat:@"Queued by: %@", newSong.contributor]];
    [self.albumArtImageView setImage:newSong.albumArt];
    
    [self.view setNeedsDisplay:YES];
}

- (void)currentQueue:(Queue *)newQueue
{
    self.currentQueue = newQueue;
    
    [self.queueTableView setDataSource:self.currentQueue];
    [self.queueTableView reloadData];
}

@end
