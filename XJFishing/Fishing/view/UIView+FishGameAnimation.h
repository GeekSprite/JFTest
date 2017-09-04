//
//  UIView+FishGameAnimation.h
//  DCGame
//
//  Created by GeekSprite on 2017/3/28.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FishGameAnimation)

+ (void)scaleAndShrinkAnimationForView:(UIView *)aniView andCompletion:(void(^)(void))completion;
+ (void)springAnimationWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations AndCompletion:(void (^)(void))completion;

@end
