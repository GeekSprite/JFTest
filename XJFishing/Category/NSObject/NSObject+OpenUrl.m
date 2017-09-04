//
//  NSObject+OpenUrl.m
//  GiftGame
//
//  Created by Ruozi on 9/26/16.
//  Copyright © 2016 Ruozi. All rights reserved.
//

#import "NSObject+OpenUrl.h"

@implementation NSObject (OpenUrl)

- (void)openUrl:(NSString *)urlString {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:urlString];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",urlString,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",urlString,success);
    }
}

@end
