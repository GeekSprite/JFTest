//
//  UIImageView+setUniversalUrl.m
//  iFun
//
//  Created by Mayqiyue on 11/5/15.
//  Copyright © 2015 AppFinder. All rights reserved.
//

#import "UIImageView+setUniversalUrl.h"

@implementation UIImageView (setUniversalUrl)

- (void)setUniversalUrl:(NSString *)url withPlaceHoler:(UIImage *)placeHolder
{
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        [self yy_setImageWithURL:[NSURL URLWithString:url] placeholder:placeHolder];
    }
    else {
        [self setImage:[UIImage imageNamed:url]];
    }
}

@end
