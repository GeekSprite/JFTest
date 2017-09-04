//
//  UIView+FishGameAnimation.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/28.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "UIView+FishGameAnimation.h"

@implementation UIView (FishGameAnimation)

+ (void)scaleAndShrinkAnimationForView:(UIView *)aniView andCompletion:(void (^)(void))completion{
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                         aniView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.20
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                                              aniView.transform = CGAffineTransformIdentity;
                                          } completion:^(BOOL finished) {
                                              if (completion) {
                                                  completion();
                                              }
                                          }];
                     }];
}

+ (void)springAnimationWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations AndCompletion:(void (^)(void))completion{

    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         if (animations) {
                             animations();
                         }
                     } completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}


@end
