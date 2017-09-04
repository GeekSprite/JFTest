//
//  XJHappyFishManager.h
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XJFishItem;
@interface XJHappyFishManager : NSObject

//HappyFishing
@property(nonatomic, readonly) BOOL canPlayHappyFishing; //是否可以玩单人钓鱼
@property(nonatomic, readonly) NSInteger typeCount; //鱼的种类数
@property(nonatomic, readonly, strong) NSArray<XJFishItem *> *poolFishs; //单人钓鱼中初始鱼群
@property(nonatomic, readonly, strong) NSArray<NSNumber *> *rewardList;  //鱼群对应的奖励
@property(nonatomic, readonly, strong) NSArray<NSNumber *> *leverList;  //奖励杠杆率列表
@property(nonatomic, readonly, strong) NSArray<NSNumber *> *fist_Number_List;
@property(nonatomic, readonly, strong) NSNumber *perBet;                //一杆需要的金币数
@property(nonatomic, strong) NSNumber *currentLeverage;                 //当前杠杆率

//FishBet
@property(nonatomic, readonly) NSInteger fishbetPoolFishsCount; //default 15
@property(nonatomic, readonly) NSInteger fishbetBasicCoinCost; //default 20
@property(nonatomic, readonly) NSInteger fishbetMaxLeverage;  //default 5
@property(nonatomic, readonly) NSInteger fishBetOdds;         //default 2
@property(nonatomic, readonly) BOOL isAdFishOn;

+ (instancetype)sharedManager;
- (void)playHappyFishingGameWithCompletion:(void(^)(NSNumber *reward, NSArray<XJFishItem *> *bait_list, NSError *error))handler;

//FishBet
- (void)fishbetPlayGamedidChooseRightSide:(BOOL)isRightSide withLeverage:(NSInteger)leverage WithCompletion:(void(^)(NSInteger rewardCount , NSArray<XJFishItem *> *bait_list, NSError *error))handler;
- (BOOL)fishbetCanPlayWithLeverage:(NSInteger)leverage;
@end
