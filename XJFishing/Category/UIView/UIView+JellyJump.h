//
//  UIView+JellyJump.h
//  JellyJump
//
//  Created by DaiPei on 2017/3/5.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JellyJump)

/*
 Note: This method needs view's height, so call this method after the view's size is determined
 */
- (void)startJump;
- (void)stopJump;

@end
