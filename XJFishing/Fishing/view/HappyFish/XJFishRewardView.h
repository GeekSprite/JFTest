//
//  XJFishRewardView.h
//  DCGame
//
//  Created by GeekSprite on 2017/3/14.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJFishRewardView : UIView

- (void)updateWithFishCount:(NSInteger)fishCount andReward:(NSInteger)rewards;
- (void)stopRewardAnimation;

@end
