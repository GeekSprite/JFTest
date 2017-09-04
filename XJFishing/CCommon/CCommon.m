//
//  CCommon.m
//  GiftGame
//
//  Created by Ruozi on 8/2/16.
//  Copyright © 2016 Ruozi. All rights reserved.
//

#import "CCommon.h"
#import "AppDelegate.h"
@implementation CCommon

+ (UIViewController *)getTopmostViewController {
    
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    BOOL isPresenting = NO;
    do {
        UIViewController *presented = [rootController presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            rootController = presented;
        }
    } while (isPresenting);
    
    return rootController;
}

+ (UIWindow *)getAppDelegateWindow {
   UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    return window;
}


+ (CGSize)getSizeForText:(NSString *)text maxWidth:(CGFloat)width font:(UIFont *)font
{
    CGSize constraintSize;
    constraintSize.height = MAXFLOAT;
    constraintSize.width = width;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    CGRect frame = [text boundingRectWithSize:constraintSize
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributesDictionary
                                      context:nil];
    return frame.size;
}

@end
