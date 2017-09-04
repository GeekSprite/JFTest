//
//  XJFishBetConsoleView.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/17.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XJFishBetConsoleView.h"
#import "Masonry.h"
#import "XJHappyFishManager.h"
#import "UIView+FishGameAnimation.h"
#import "SoundManager+BackgroundMusic.h"

#define Appear_Animation_Duration    0.10

@interface XJFishBetConsoleView ()

@property(nonatomic, strong) UIButton *startButton;
@property(nonatomic, strong) UIButton *cancleButton;
@property(nonatomic) BOOL isRight;
@property(nonatomic) NSInteger leverage;

@end

@implementation XJFishBetConsoleView
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configView];
        [self resetState];
    }
    return self;
}

#pragma mark - config view
- (void)configView{
    [self addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(32 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(95 * Fish_Screen_Width_Ratio);
    }];
    
    [self addSubview:self.startButton];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.cancleButton.mas_top).offset(-17 * Fish_Screen_Height_Ratio);
        make.height.mas_equalTo(78 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(181 * Fish_Screen_Width_Ratio);
    }];
    
}

#pragma mark - public
- (void)resetConsole{
    [self resetState];
}

- (void)refreshContentWhenChooseRightSide:(BOOL)right{
    if (self.leverage >= [XJHappyFishManager sharedManager].fishbetMaxLeverage) {
        return;
    }
    if (self.leverage == 0) {
        self.isRight = right;
        self.startButton.hidden = NO;
        self.cancleButton.hidden = NO;
        [UIView animateWithDuration:Appear_Animation_Duration animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            self.startButton.alpha = 1.0;
            self.cancleButton.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    self.leverage += 1;
}

#pragma mark - target-action

- (void)startButtonDidClick{
    [[SoundManager sharedManager] playSound:@"game_start.mp3"];
    [UIView animateWithDuration:Appear_Animation_Duration animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.startButton.alpha = 0.0;
        self.cancleButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.startButton.hidden = YES;
        self.cancleButton.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didStartWithLeverage:didChooseRightSide:)]) {
            [self.delegate didStartWithLeverage:self.leverage didChooseRightSide:self.isRight];
        }
    }];
}

- (void)cancleButtonDidClick{
    [self resetState];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCancel)]) {
        [self.delegate didClickCancel];
    }
}

#pragma mark - private
- (void)resetState{
    self.isRight = NO;
    self.leverage = 0;

    [UIView animateWithDuration:Appear_Animation_Duration animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.startButton.alpha = 0.0;
        self.cancleButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.startButton.hidden = YES;
        self.cancleButton.hidden = YES;
    }];
}

#pragma mark - getter


- (UIButton *)startButton{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"RewardConfirmButtonNormal"] forState:UIControlStateNormal];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"RewardConfirmButtonPressed"] forState:UIControlStateHighlighted];
        [_startButton setTitle:NSLocalizedString(@"FishBattle_Start_Button", nil) forState:UIControlStateNormal];
        [_startButton setTitleColor:kColorWithHexValue(@"#fffbe5") forState:UIControlStateNormal];
        _startButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:28];
        _startButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_startButton addTarget:self action:@selector(startButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        _startButton.hidden = YES;
        _startButton.exclusiveTouch = YES;
        _startButton.alpha = 0.0;
    }
    return _startButton;
}

- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setBackgroundImage:[UIImage imageNamed:@"fishbet_cancel"] forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancleButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        _cancleButton.hidden = YES;
        _cancleButton.exclusiveTouch = YES;
        _cancleButton.alpha = 0.0;
    }
    return _cancleButton;
}

@end
