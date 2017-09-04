//
//  UIView+ShinningAnimation.m
//  DCGame
//
//  Created by HeJi on 17/4/14.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "UIView+ShinningAnimation.h"
#import <objc/runtime.h>



static char HJShinningAnimationKey;


@implementation UIView (ShinningAnimation)

- (void)startWaterdropAnimationAtPoint:(CGPoint)animatePoint {
    
    [self hj_changeAnimateState:YES];
    
    [self hj_waterdropAnimationAtPoint:[NSValue valueWithCGPoint:animatePoint]];
}

- (void)stopWaterdropAnimation {
    [self hj_changeAnimateState:NO];
}


- (void)hj_waterdropAnimationAtPoint:(NSValue *)pointValue {
    if ([self hj_isAnimating]) {
        UIView *waterDropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidthRatio * 50, ScreenWidthRatio * 50)];
        waterDropView.layer.cornerRadius = ScreenWidthRatio * 25;
        waterDropView.center = [pointValue CGPointValue];
        waterDropView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [self insertSubview:waterDropView atIndex:0];
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            waterDropView.transform = CGAffineTransformMakeScale(8, 8);
            waterDropView.alpha = 0;
        } completion:^(BOOL finished) {
            [waterDropView removeFromSuperview];
        }];
        
        [self performSelector:@selector(hj_waterdropAnimationAtPoint:) withObject:pointValue afterDelay:1.5];
    }
}

- (BOOL)hj_isAnimating {
    
    if (!objc_getAssociatedObject(self, &HJShinningAnimationKey)) {
        return NO;
    }
    
    if ([objc_getAssociatedObject(self, &HJShinningAnimationKey) isEqualToString:@"NO"]) {
        return NO;
    }
    
    return YES;
}

- (void)hj_changeAnimateState:(BOOL)state {
    
    if (state) {
        objc_setAssociatedObject(self, &HJShinningAnimationKey, @"YES", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, &HJShinningAnimationKey, @"NO", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
