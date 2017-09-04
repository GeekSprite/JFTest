//
//  NSString+URLEncode.m
//  iFun
//
//  Created by ChaiJun on 14-12-1.
//  Copyright (c) 2014年 AppFinder. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)
- (NSString *)URLEncode {
    return [self URLEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)URLDecode {
    return [self URLDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end
