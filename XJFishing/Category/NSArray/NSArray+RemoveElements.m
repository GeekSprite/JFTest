//
//  NSArray+RemoveElements.m
//  DCGame
//
//  Created by Jerry Liu on 2017/5/11.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "NSArray+RemoveElements.h"

@implementation NSArray (RemoveElements)

- (NSArray *)arrayByRemovingIndex:(NSInteger)index {
    if (index >= 0 && index < self.count) {
        NSMutableArray *mutableArray = [self mutableCopy];
        [mutableArray removeObjectAtIndex:index];
        return [mutableArray copy];
    }
    return self;
}

@end
