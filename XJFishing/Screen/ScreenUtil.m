//
//  ScreenUtil.m
//  GiftGame
//
//  Created by Andres He on 8/18/16.
//  Copyright © 2016 Ruozi. All rights reserved.
//

#import "ScreenUtil.h"

@implementation ScreenUtil

/**
 *  set height of sheet content in UIAlertController, for redeem
 *
 *  @return NSString
 */
+ (NSString *)alertMessage {
    if (IS_6_6S_PLUS) {
        return @"\n\n\n\n\n\n\n\n\n\n\n";
    }
    else if (IS_6_6S) {
        return @"\n\n\n\n\n\n\n\n\n";
    }
    else if (IS_5_5S_5C) {
        return @"\n\n\n\n\n\n\n";
    }
    else if (IS_4_4S) {
        return @"\n\n\n\n\n\n";
    }
    else {
        return @"\n\n\n\n";
    }
}

@end
