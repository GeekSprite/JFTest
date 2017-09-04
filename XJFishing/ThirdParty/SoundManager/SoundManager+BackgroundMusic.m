//
//  SoundManager+BackgroundMusic.m
//  GiftGame
//
//  Created by Mac on 16/8/3.
//  Copyright © 2016年 Ruozi. All rights reserved.
//

#import "SoundManager+BackgroundMusic.h"

#define ShouldPlayBackgroundMusic @"ShouldPlayBackgroundMusic"

@implementation SoundManager (BackgroundMusic)

- (BOOL)shouldPlayBackgroundMusic{
    NSNumber *shoudlPlay = [[NSUserDefaults standardUserDefaults] objectForKey:ShouldPlayBackgroundMusic];
    if (shoudlPlay == nil) {
        // never set , default is YES;
        [self setShouldPlayBackgroundMusic:YES];
        return YES;
    }else{
        return shoudlPlay.boolValue;
    }
}

- (void)setShouldPlayBackgroundMusic:(BOOL)shouldPlayBackgroundMusic{
    NSNumber *shouldPlay = [NSNumber numberWithBool:shouldPlayBackgroundMusic];
    [[NSUserDefaults standardUserDefaults] setObject:shouldPlay forKey:ShouldPlayBackgroundMusic];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
