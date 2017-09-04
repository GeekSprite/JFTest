//
//  FontUtil.m
//  iFun
//
//  Created by Andres He on 6/22/16.
//  Copyright © 2016 AppFinder. All rights reserved.
//

#import "FontUtil.h"



@implementation FontUtil

/**
 *  获取当前device screen实际需要的font size
 *
 *  @param size 设计师在4.7inch标的font size
 *
 *  @return 实际需要的font size，根据屏幕宽度比例缩放,用pt换算
 */
+ (CGFloat)fontSize:(CGFloat)size
{
    if (IS_6_6S_PLUS) {
        return size * 414/375;
    }
    else if (IS_6_6S) {
        return size;
    }
    else if (IS_5_5S_5C) {
        return size * 320/375;
    }
    else if (IS_4_4S) {
        return size * 320/375;
    }
    else {
        return size * 320/375;
    }
}


@end
