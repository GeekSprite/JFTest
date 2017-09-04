//
//  NSObject+ReachabilityBugFix.m
//  GiftGame
//
//  Created by Jerry Liu on 16/11/25.
//  Copyright © 2016年 Ruozi. All rights reserved.
//

#import "NSObject+ReachabilityBugFix.h"



@implementation NSObject (ReachabilityBugFix)
- (id)currentReachabilityStatus{
    NSLog(@"class:%@, received currentReachabilityStatus",[self class]);
    
    return nil;
}

@end
