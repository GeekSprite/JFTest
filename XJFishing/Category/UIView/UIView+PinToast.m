//
//  UIView+PinToast.m
//  GiftGame
//
//  Created by Andres He on 9/5/16.
//  Copyright © 2016 Ruozi. All rights reserved.
//

#import "UIView+PinToast.h"

@implementation UIView (PinToast)

- (void)makePinToast:(NSString *)toast {
    if ([CSToastManager isQueueEnabled]) {
        [CSToastManager setQueueEnabled:NO];
    }
    
    [self makeToast:toast duration:2.0 position:[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 3 / 4)]];
}

- (void)makePinToast:(NSString *)toast atPosition:(CGPoint)point{
    if ([CSToastManager isQueueEnabled]) {
        [CSToastManager setQueueEnabled:NO];
    }
    
    [self makeToast:toast duration:2.0 position:[NSValue valueWithCGPoint:point]];
}

@end
