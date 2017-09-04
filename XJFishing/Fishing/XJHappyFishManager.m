//
//  XJHappyFishManager.m
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import "XJHappyFishManager.h"
#import "XJFishItem.h"


#define Fish_Bet_Win_Count      5
#define STRAW_FISH_MAX_COUNT    2

static NSString *const Fishing_Game_Leverage_Key = @"Fishing_Game_Leverage_Key";

@implementation XJHappyFishManager

+ (instancetype)sharedManager{
    static XJHappyFishManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XJHappyFishManager alloc] init];
    });
    return manager;
}

#pragma mark - public
- (void)playHappyFishingGameWithCompletion:(void(^)(NSNumber *reward, NSArray<XJFishItem *> *bait_list, NSError *error))handler{
    
//    [[LWGameDataController sharedInstance] playHappyFishing:self.currentLeverage.integerValue resultHandler:^(NSNumber *reward, NSArray *bait_list, NSError *error) {
//        if (error) {
//            handler(nil,nil,error);
//        }else{
//            NSInteger typeCount = [self typeCount];
//            NSMutableArray *totalArr = [NSMutableArray array];
//            NSInteger limited = 3;//炮灰鱼的最大数
//            
//            if (bait_list.count == typeCount && [[GiftClient sharedClient].currentGameInfo.Fishing.game_config.fish_number_list componentsSeparatedByString:@","].count == typeCount) {
//                for (NSInteger i = 0; i < typeCount; i++) {
//                    NSMutableArray *muArr = [NSMutableArray array];
//                    //种类得奖数
//                    NSInteger rewardCount = ((NSString *)bait_list[i]).integerValue;
//                    //种类总鱼数
//                    NSInteger totalCount = ((NSString *)[[[GiftClient sharedClient].currentGameInfo.Fishing.game_config.fish_number_list componentsSeparatedByString:@","] objectAtIndex:i]).integerValue;
//            
//                    rewardCount = rewardCount > totalCount ? totalCount : rewardCount;
//                    for (int j = 0 ; j < rewardCount; j ++) {
//                        [muArr addObject:[[XJFishItem alloc] initWithType:i isStraw:NO isSide:NO]];
//                    }
//                    NSInteger salt = 65;
//                    if (muArr.count == 0) {
//                        salt = 85;
//                    }
//                    for (int index = 0 ; index < (totalCount - rewardCount) && arc4random() % 100 > salt && limited > 0; (index ++,limited --)) {
//                            uint32_t index = arc4random_uniform((uint32_t)muArr.count);
//                            [muArr insertObject:[[XJFishItem alloc] initWithType:i isStraw:YES isSide:NO] atIndex:index];
//                    }
//                    [totalArr addObjectsFromArray:muArr];
//                }
//            }
//            if (!totalArr.count) {
//                [totalArr addObject:[[XJFishItem alloc] initWithType:XJFishTypeSmallBlue isStraw:YES isSide:NO]];
//                [totalArr addObject:[[XJFishItem alloc] initWithType:arc4random() % self.typeCount isStraw:YES isSide:NO]];
//            }
//            handler(reward,totalArr,nil);
//        }
//    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger typeCount = [self typeCount];
        NSMutableArray *totalArr = [NSMutableArray array];
        NSInteger limited = 3;//炮灰鱼的最大数
        
        NSInteger rewardSum = 0;
        
        NSArray * bait_list = [@"5,3,1,1,0,0" componentsSeparatedByString:@","];
        
        if (bait_list.count == typeCount && self.fist_Number_List.count == typeCount) {
            for (NSInteger i = 0; i < typeCount; i++) {
                NSMutableArray *muArr = [NSMutableArray array];
                //种类得奖数
                NSInteger rewardCount = ((NSString *)bait_list[i]).integerValue;
                //种类总鱼数
                NSInteger totalCount = self.fist_Number_List[i].integerValue;
                
                rewardCount = rewardCount > totalCount ? totalCount : rewardCount;
                
                rewardSum += (rewardCount * self.rewardList[i].integerValue);
                for (int j = 0 ; j < rewardCount; j ++) {
                    [muArr addObject:[[XJFishItem alloc] initWithType:i isStraw:NO isSide:NO]];
                }
                NSInteger salt = 65;
                if (muArr.count == 0) {
                    salt = 85;
                }
                for (int index = 0 ; index < (totalCount - rewardCount) && arc4random() % 100 > salt && limited > 0; (index ++,limited --)) {
                    uint32_t index = arc4random_uniform((uint32_t)muArr.count);
                    [muArr insertObject:[[XJFishItem alloc] initWithType:i isStraw:YES isSide:NO] atIndex:index];
                }
                [totalArr addObjectsFromArray:muArr];
            }
        }
        if (!totalArr.count) {
            [totalArr addObject:[[XJFishItem alloc] initWithType:XJFishTypeSmallBlue isStraw:YES isSide:NO]];
            [totalArr addObject:[[XJFishItem alloc] initWithType:arc4random() % self.typeCount isStraw:YES isSide:NO]];
        }
        handler(@(rewardSum),totalArr,nil);
    });
}

- (NSInteger)typeCount{
    return 6;
}

- (BOOL)canPlayHappyFishing{
    return YES;
}


- (NSNumber *)perBet{
    NSInteger baseBet = 10 ;
    return  @(baseBet * self.currentLeverage.integerValue);
}

- (NSArray<XJFishItem *> *)poolFishs{
    NSArray *arr = @[@"6",@"4",@"3",@"2",@"2",@"1"];
    NSMutableArray *muarr = [NSMutableArray arrayWithCapacity:arr.count];
    for (int type = 0; type < arr.count; type++) {
        NSInteger count = ((NSString *)arr[type]).integerValue;
        for (int index = 0; index < count; index ++ ) {
            [muarr addObject:[[XJFishItem alloc] initWithType:type isStraw:NO isSide:NO]];
        }
    }
    return muarr;
}

- (NSArray<NSNumber *> *)rewardList{
    NSString *str = @"1.0,2.0,2.5,3.0,3.5,10.0";
    NSArray *arr = [str componentsSeparatedByString:@","];
    NSMutableArray *rewards = [NSMutableArray array];
    for (NSString *str in arr) {
        [rewards addObject:@(str.floatValue * self.perBet.integerValue)];
    }
    return rewards;
}

- (void)setCurrentLeverage:(NSNumber *)currentLeverage{
    [[NSUserDefaults standardUserDefaults] setObject:currentLeverage forKey:Fishing_Game_Leverage_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)currentLeverage{
    NSNumber *nd_leverage = [[NSUserDefaults standardUserDefaults] objectForKey:Fishing_Game_Leverage_Key];
    if (nd_leverage) {
        return nd_leverage;
    }
    return @(1);
}

- (NSArray<NSNumber *> *)leverList{
    NSArray *arr = [@"1.0,2.0,2.5,3.0,3.5,10.0" componentsSeparatedByString:@","];
    NSMutableArray *muarr = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSString *str in arr) {
        [muarr addObject:@(str.integerValue)];
    }
    return muarr;
}

//FishBet
- (void)fishbetPlayGamedidChooseRightSide:(BOOL)isRightSide withLeverage:(NSInteger)leverage WithCompletion:(void(^)(NSInteger rewardCount , NSArray<XJFishItem *> *bait_list, NSError *error))handler{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((rand() % 4 + 2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSNumber *reward = @(200);
        NSArray *bait_list = [@"1,1,0,1,1,1,0,0,0" componentsSeparatedByString:@","];
    
        NSInteger rewardCount = reward.integerValue;
        BOOL isWin = rewardCount > 0;
        NSInteger winFishCount = Fish_Bet_Win_Count;
        NSInteger lostFishCount = Fish_Bet_Win_Count - 1;
        NSInteger strawFishCount = rand() % (STRAW_FISH_MAX_COUNT + 1);
        NSMutableArray *rewardList = [NSMutableArray array];
        for (NSString *rewarStr in bait_list) {
            XJFishItem *item;
            //winFish
            if (rewarStr.integerValue == (isWin ? 1 : 0)) {
                winFishCount -= 1;
                item = [[XJFishItem alloc] initWithType:XJFishTypeSideFish isStraw:NO isSide:(isWin ? !isRightSide : isRightSide)];
                [rewardList addObject:item];
                if (winFishCount == 0) {
                    break;
                }
            }else if(rewarStr.integerValue == (isWin ? 0 : 1)){
                if (lostFishCount == 0) {
                    continue;
                }
                lostFishCount -= 1;
                item = [[XJFishItem alloc] initWithType:XJFishTypeSideFish isStraw:NO isSide:(isWin ? isRightSide : !isRightSide)];
                [rewardList addObject:item];
            }
        }
        rewardList = [self insertStarwFishs:strawFishCount inBattleRewardList:rewardList];
        handler(rewardCount,rewardList,nil);
    });
    
//    [[LWGameDataController sharedInstance] playBattleFish:leverage resultHandler:^(NSNumber *reward, NSArray *bait_list, NSError *error) {
//        if (error) {
//            handler(0,nil,error);
//        }else{
//            NSInteger rewardCount = reward.integerValue;
//            BOOL isWin = rewardCount > 0;
//            NSInteger winFishCount = Fish_Bet_Win_Count;
//            NSInteger lostFishCount = Fish_Bet_Win_Count - 1;
//            NSInteger strawFishCount = rand() % (STRAW_FISH_MAX_COUNT + 1);
//            NSMutableArray *rewardList = [NSMutableArray array];
//            for (NSString *rewarStr in bait_list) {
//                XJFishItem *item;
//                //winFish
//                if (rewarStr.integerValue == (isWin ? 1 : 0)) {
//                    winFishCount -= 1;
//                    item = [[XJFishItem alloc] initWithType:XJFishTypeSideFish isStraw:NO isSide:(isWin ? !isRightSide : isRightSide)];
//                    [rewardList addObject:item];
//                    if (winFishCount == 0) {
//                        break;
//                    }
//                }else if(rewarStr.integerValue == (isWin ? 0 : 1)){
//                    if (lostFishCount == 0) {
//                        continue;
//                    }
//                    lostFishCount -= 1;
//                    item = [[XJFishItem alloc] initWithType:XJFishTypeSideFish isStraw:NO isSide:(isWin ? isRightSide : !isRightSide)];
//                    [rewardList addObject:item];
//                }
//            }
//            rewardList = [self insertStarwFishs:strawFishCount inBattleRewardList:rewardList];
//            handler(rewardCount,rewardList,nil);
//        }
//    }];
}

- (NSInteger)fishbetBasicCoinCost{
//    return [GiftClient sharedClient].currentGameInfo.BattleFishing.game_config.bet.integerValue;
    return 20;
}

- (NSInteger)fishbetMaxLeverage{
//    return [GiftClient sharedClient].currentGameInfo.BattleFishing.game_config.max_lever.integerValue;
    return 5;
}

- (BOOL)fishbetCanPlayWithLeverage:(NSInteger)leverage{
//    return [GiftClient sharedClient].currentUser.coins.integerValue >= leverage * self.fishbetBasicCoinCost;
    return YES;
}

- (NSInteger)fishbetPoolFishsCount{
    return Fish_Bet_Win_Count * 3;
}

- (NSInteger)fishBetOdds{
    return 2.0;
}

- (NSArray<NSNumber *> *)fist_Number_List {
    return @[@(6),@(5),@(3),@(2),@(2),@(1)];
}

- (BOOL)isAdFishOn{
    return YES;
}

- (NSMutableArray *)insertStarwFishs:(NSInteger)count inBattleRewardList:(NSArray *)rewardList{
    NSMutableArray *resultFishs = [[NSMutableArray alloc] initWithArray:rewardList];
    if (rewardList.count < Fish_Bet_Win_Count) {
        return resultFishs;
    }
    for (int index = 0; index < count; index ++) {
        XJFishItem *strawItem = [[XJFishItem alloc] initWithType:XJFishTypeSideFish isStraw:YES isSide:NO];
        [resultFishs insertObject:strawItem atIndex:random() % (resultFishs.count - 1)];
    }
    return resultFishs;
}

@end
