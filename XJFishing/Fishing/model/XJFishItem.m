//
//  XJFishItem.m
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import "XJFishItem.h"
#import "XJHappyFishManager.h"

@implementation XJFishItem

- (instancetype)initWithType:(XJFishType)type isStraw:(BOOL)isStraw isSide:(BOOL)isSide{
    if (self = [super init]) {
        self.type = type;
        self.isStraw = isStraw;
        self.isSide = isSide;
    }
    return self;
}

- (NSUInteger)rewardCount{
    if (self.isStraw) {
        return 0;
    }
    if (self.isSide) {
        return 0;
    }
    if (self.type < [XJHappyFishManager sharedManager].rewardList.count) {
        return ((NSNumber *)[XJHappyFishManager sharedManager].rewardList[self.type]).integerValue;
    }
    return 0;
}

@end
