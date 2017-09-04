//
//  CoinCountView.h
//  Turntable
//
//  Created by HeJi on 16/6/17.
//  Copyright © 2016年 HeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoinCountView;
@protocol CoinCountViewDelegate <NSObject>
@optional
- (BOOL)canClickCoinCountView:(CoinCountView *)coinCountView;
- (void)coinCountViewDidClick:(CoinCountView *)coinCountView;

@end

@interface CoinCountView : UIView

@property (nonatomic, assign) NSInteger coinCount;
@property (nonatomic, weak) id<CoinCountViewDelegate> delegate;

- (void)disableCoinBadgeDisplay;
- (void)onlyShowCoinCountAndIcon;
- (void)onlyShowCoinIcon;
- (CGRect)coinViewFrameInSuperView;
- (void)playAnimationWithDeductCoinCount:(NSInteger)count ;

@end
