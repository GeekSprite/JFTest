//
//  CCommon.h
//  GiftGame
//
//  Created by Ruozi on 8/2/16.
//  Copyright © 2016 Ruozi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CCommon : NSObject

+ (UIViewController *)getTopmostViewController;
+ (UIWindow *)getAppDelegateWindow;
+ (CGSize)getSizeForText:(NSString *)text maxWidth:(CGFloat)width font:(UIFont *)font;

@end
