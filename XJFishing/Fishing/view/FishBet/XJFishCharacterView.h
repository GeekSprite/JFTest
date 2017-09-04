//
//  XJFishCharacterView.h
//  DCGame
//
//  Created by GeekSprite on 2017/3/21.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XJFishCharacterViewDelegate <NSObject>

- (void)didTapPlayerOnRightSide:(BOOL)isRight;

@end

@interface XJFishCharacterView : UIView

@property(nonatomic, weak)id<XJFishCharacterViewDelegate> delegate;

- (void)resetScence;
- (void)animationForGameStart;
- (void)animationForRewardIsRightWin:(BOOL)isRight;
- (void)animationForDisappear;
- (void)animationForChoosePlayerIsRight:(BOOL)isRight;

@end
