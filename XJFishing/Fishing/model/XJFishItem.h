//
//  XJFishItem.h
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XJFishTypeSmallBlue = 0,
    XJFishTypeBigBlue,
    XJFishTypeSmallYellow,
    XJFishTypeBigYellow,
    XJFishTypeSmallRed,
    XJFishTypeBigRed,
    XJFishTypeSideFish = 6,
    XJFishTypeADFish
} XJFishType;

@interface XJFishItem : NSObject

- (instancetype)initWithType:(XJFishType)type isStraw:(BOOL)isStraw isSide:(BOOL)isSide;

@property(nonatomic) XJFishType type; //鱼的种类
@property(nonatomic) NSUInteger rewardCount; //鱼对应的奖励
@property(nonatomic) BOOL isStraw; //是否为炮灰鱼
@property(nonatomic) BOOL isSide; //用于两杆的时候，标记其上副杆

@end
