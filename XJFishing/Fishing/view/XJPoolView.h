//
//  XJPoolView.h
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJFishItem.h"

typedef enum : NSUInteger {
    XJPoolStateInitial,
    XJPoolStateReceivedResult,
    XJPoolStateReceivedError,
    XJPoolStateReadyForBite,
    XJPoolStateReadyForReward,
} XJPoolState;

@protocol XJPoolViewDelegate <NSObject>

- (void)didGetFish:(XJFishItem *)fish;
- (void)gameRewardAnimationDidEndWithError:(BOOL)isError;
- (void)didTouchBeginWithChooseAdFish:(BOOL)choose;

@end

@interface XJPoolView : UIView

@property(nonatomic, weak)id<XJPoolViewDelegate> delegate;
@property(nonatomic) XJPoolState poolState;
@property(nonatomic) CGPoint bitePoint;
@property(nonatomic) CGPoint sideBaitPoint;

- (instancetype)initWithFishs:(NSArray<XJFishItem *> *)initialFishs;
- (void)setRewardResult:(NSArray<XJFishItem *> *)rewardItem;

- (void)addAdFish;
- (void)removeAdFish;

@end
   
