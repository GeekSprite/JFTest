//
//  GameEnum.h
//  iFun
//
//  Created by HeJi on 16/7/5.
//  Copyright © 2016年 AppFinder. All rights reserved.
//

#ifndef GameEnum_h
#define GameEnum_h

typedef NS_ENUM(NSInteger, GameType)
{
    GameType_QuickHit,
    GameType_LuckySpin,
    GameType_FreeLuckySpin,
    GameType_GenerousLuckySpin,
    GameType_Slot,
    GameType_GenerousSlot,
    GameType_HappyFish,
    GameType_HappyFishDouble,
    GameType_Puzzle,
    GameType_YellShooter,
    GameType_FreeChest,
    GameType_GiftChest,
    GameType_Farming,
    GameType_FlyCar,
    GameType_Scratch,
};

typedef NS_ENUM(NSInteger, RewardSourceType) {
    RewardSourceType_GoldenChest,
    RewardSourceType_SilverChest,
    RewardSourceType_Redeem,
    RewardSourceType_Turntable,
    RewardSourceType_Slot,
    RewardSourceType_QuickHit
};

typedef NS_ENUM(NSInteger, RewardType)
{
    RewardType_NoReward,
    RewardType_Coin,
    RewardType_MoreSpin,
    RewardType_GiftCard
};

typedef NS_ENUM(NSInteger, SlotAnimationType)
{
    SlotAnimationType_Unknown,
    SlotAnimationType_Start,
    SlotAnimationType_Animating,
    SlotAnimationType_Stop
};

typedef NS_ENUM(NSInteger, SlotResultType)
{
    SlotResultType_NoAlikeItem = 0,
    SlotResultType_TowAlikeItem,
    SlotResultType_ThreeAlikeItem,
    SlotResultType_TwoSmallWin,
    SlotResultType_ThreeSmallWin,
    SlotResultType_TwoBigWin,
    SlotResultType_ThreeBigWin
};

typedef NS_ENUM(NSInteger, GameStatus) {
    GameStatus_Unknown,
    GameStatus_Start,
    GameStatus_Underway,
    GameStatus_End,
    GameStatus_RewardStart,
    GameStatus_RewardEnd
};

#endif /* CassinoEnum_h */
