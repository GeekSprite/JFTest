//
//  NSString+URLEncode.h
//  iFun
//
//  Created by ChaiJun on 14-12-1.
//  Copyright (c) 2014年 AppFinder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)
- (NSString *)URLEncode;
- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)URLDecode;
- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding;
@end
