//
//  SpotifyControls.h
//  Groupify
//
//  Created by Niki Wells on 9/19/15.
//  Copyright © 2015 8-bit best team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MusicPlayerViewController;

@interface SpotifyControls : NSObject

- (void)playMusic;
- (void)playNextSong;
- (instancetype)initWithMusicPlayerViewController:(MusicPlayerViewController *)musicPlayerVC;

@end
