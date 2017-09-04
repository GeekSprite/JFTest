//
//  NSObject+ReachabilityBugFix.h
//  GiftGame
//
//  Created by Jerry Liu on 16/11/25.
//  Copyright © 2016年 Ruozi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ReachabilityBugFix)
- (id)currentReachabilityStatus;
@end
