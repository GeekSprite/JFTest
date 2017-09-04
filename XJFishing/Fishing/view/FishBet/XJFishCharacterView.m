//
//  XJFishCharacterView.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/21.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XJFishCharacterView.h"
#import "Masonry.h"
#import "XJHappyFishManager.h"
#import "SoundManager+BackgroundMusic.h"
#import "UIView+FishGameAnimation.h"

#define Fish_Screen_Height_Ratio    (SCREEN_HEIGHT/736.0)
#define Fish_Screen_Width_Ratio     (SCREEN_WIDTH/414.0)
#define Not_Choose_Multi            0.67

static NSString *const leftPlayerIndicatorKey = @"leftPlayerIndicatorKey";
static NSString *const rightPlayerIndicatorKey = @"rightPlayerIndicatorKey";

@interface XJFishCharacterView ()
{
    BOOL _shouldAnimation;
    NSInteger _leverage;
    BOOL _chooseRight;
}

@property(nonatomic, strong) UIImageView *leftCharacterView;
@property(nonatomic, strong) UIImageView *rightCharacterView;
@property(nonatomic, strong) UIButton    *leftChooseButton;
@property(nonatomic, strong) UIButton    *rightChooseButton;
@property(nonatomic, strong) UIImageView *leftCharacterIndicator;
@property(nonatomic, strong) UIImageView *rightCharacterIndicator;
@property(nonatomic, strong) UILabel *leftCharacterIndicatorLabel;
@property(nonatomic, strong) UILabel *rightCharacterIndicatorlabel;
@property(nonatomic, strong) UIImageView *rewardView;

@end

@implementation XJFishCharacterView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
        _shouldAnimation = YES;
        _leverage = 0;
        _chooseRight = NO;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self addShakeAnimation];
}

#pragma mark - configView
- (void)configView{
    [self addSubview:self.leftCharacterView];
    [self.leftCharacterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13 * Fish_Screen_Width_Ratio);
        make.top.equalTo(self);
        make.height.mas_equalTo(154 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(149 * Fish_Screen_Width_Ratio);
    }];
    
    [self addSubview:self.rightCharacterView];
    [self.rightCharacterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13 * Fish_Screen_Width_Ratio);
        make.top.equalTo(self);
        make.height.mas_equalTo(154 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(149 * Fish_Screen_Width_Ratio);
    }];
    
    [self addSubview:self.rewardView];
    [self.rewardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(180 * Fish_Screen_Width_Ratio);
        make.height.mas_equalTo(118 * Fish_Screen_Height_Ratio);
        make.top.equalTo(self).offset(196 * Fish_Screen_Height_Ratio);
    }];
    
    [self addSubview:self.leftCharacterIndicator];
    [self.leftCharacterIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftCharacterView).offset(-18 * Fish_Screen_Height_Ratio);
        make.left.equalTo(self.leftCharacterView).offset(75 * Fish_Screen_Width_Ratio);
        make.width.mas_equalTo(86 * Fish_Screen_Width_Ratio);
        make.height.mas_equalTo(36 * Fish_Screen_Height_Ratio);
    }];
    
    [self.leftCharacterIndicator addSubview:self.leftCharacterIndicatorLabel];
    [self.leftCharacterIndicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftCharacterIndicator).offset(2);
        make.left.width.equalTo(self.leftCharacterIndicator);
        make.height.mas_equalTo(17 * Fish_Screen_Height_Ratio);
    }];
    
    [self addSubview:self.rightCharacterIndicator];
    [self.rightCharacterIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightCharacterView).offset(-4 * Fish_Screen_Height_Ratio);
        make.left.equalTo(self.rightCharacterView).offset(-49 * Fish_Screen_Width_Ratio);
        make.width.mas_equalTo(86 * Fish_Screen_Width_Ratio);
        make.height.mas_equalTo(36 * Fish_Screen_Height_Ratio);
    }];
    
    [self.rightCharacterIndicator addSubview:self.rightCharacterIndicatorlabel];
    [self.rightCharacterIndicatorlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightCharacterIndicator).offset(2);
        make.left.width.equalTo(self.rightCharacterIndicator);
        make.height.mas_equalTo(17 * Fish_Screen_Height_Ratio);
    }];
    
    [self addSubview:self.leftChooseButton];
    [self.leftChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30 * Fish_Screen_Width_Ratio);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(36 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(112 * Fish_Screen_Width_Ratio);
    }];

    [self addSubview:self.rightChooseButton];
    [self.rightChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-30 * Fish_Screen_Width_Ratio);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(36 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(112 * Fish_Screen_Width_Ratio);
    }];
    
}

#pragma mark - public
- (void)resetScence{
    [self resetState];
    self.rewardView.hidden= YES;
    [self.leftCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13 * Fish_Screen_Width_Ratio);
        make.top.equalTo(self);
        make.height.mas_equalTo(154 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(149 * Fish_Screen_Width_Ratio);
    }];
    
    [self.rightCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13 * Fish_Screen_Width_Ratio);
        make.top.equalTo(self);
        make.height.mas_equalTo(154 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(149 * Fish_Screen_Width_Ratio);
    }];
    
    [UIView springAnimationWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    } AndCompletion:nil];
    
    [UIView animateWithDuration:0.1 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                self.leftChooseButton.alpha = 1.0;
                self.rightChooseButton.alpha = 1.0;
        self.leftCharacterIndicator.alpha = 1.0;
        self.rightCharacterIndicator.alpha = 1.0;
    } completion:nil];
        [self.leftChooseButton setTitle:@"+" forState:UIControlStateNormal];
        [self.rightChooseButton setTitle:@"+" forState:UIControlStateNormal];
}

- (void)animationForGameStart{

    self.leftCharacterView.userInteractionEnabled = NO;
    self.rightCharacterView.userInteractionEnabled = NO;
    if (_chooseRight) {
        [self.rightCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-3 * Fish_Screen_Width_Ratio);
            make.top.equalTo(self).offset(34 * Fish_Screen_Height_Ratio);
            make.width.mas_equalTo(92 * Fish_Screen_Width_Ratio );
            make.height.mas_equalTo(96 * Fish_Screen_Height_Ratio );
        }];
    }else{
        [self.leftCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(3 * Fish_Screen_Width_Ratio);
            make.top.equalTo(self).offset(34 * Fish_Screen_Height_Ratio);
            make.width.mas_equalTo(92 * Fish_Screen_Width_Ratio );
            make.height.mas_equalTo(96 * Fish_Screen_Height_Ratio );
        }];
    }
    
    [UIView springAnimationWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    } AndCompletion:^{
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.leftChooseButton.alpha = 0.0;
        self.rightChooseButton.alpha = 0.0;
        self.leftCharacterIndicator.alpha = 0.0;
        self.rightCharacterIndicator.alpha = 0.0;
    }completion:nil];
}

- (void)animationForRewardIsRightWin:(BOOL)isRight{
    if (!isRight) {
        [self.leftCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(70 * Fish_Screen_Height_Ratio);
            make.width.mas_equalTo(157 * Fish_Screen_Width_Ratio);
            make.height.mas_equalTo(166 * Fish_Screen_Height_Ratio);
        }];
    }else{
        [self.rightCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(70 * Fish_Screen_Height_Ratio);
            make.width.mas_equalTo(157 * Fish_Screen_Width_Ratio);
            make.height.mas_equalTo(166 * Fish_Screen_Height_Ratio);
        }];
    }
    
    [UIView springAnimationWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    } AndCompletion:^{
        self.rewardView.hidden = NO;
        self.rewardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        [UIView springAnimationWithDuration:0.5 animations:^{
            self.rewardView.transform = CGAffineTransformIdentity;
        } AndCompletion:^{
            
        }];
    }];
}

- (void)animationForDisappear{
    self.rewardView.hidden= YES;
    [self.leftCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13 * Fish_Screen_Width_Ratio);
        make.top.equalTo(self);
        make.height.mas_equalTo(154 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(149 * Fish_Screen_Width_Ratio);
    }];
    
    [self.rightCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13 * Fish_Screen_Width_Ratio);
        make.top.equalTo(self);
        make.height.mas_equalTo(154 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(149 * Fish_Screen_Width_Ratio);
    }];
    
    [UIView springAnimationWithDuration:0.5
                             animations:^{
                                 [self layoutIfNeeded];
                             } AndCompletion:^{
                                 [self resetState];
                             }];
}

- (void)animationForChoosePlayerIsRight:(BOOL)isRight{
    [[SoundManager sharedManager] playSound:@"Coin_Collect.mp3"];
    if(_leverage >= [XJHappyFishManager sharedManager].fishbetMaxLeverage){
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapPlayerOnRightSide:)]) {
        [self.delegate didTapPlayerOnRightSide:isRight];
    }
    
    _chooseRight = isRight;
    UIView *aniView = isRight ? self.rightCharacterView : self.leftCharacterView;
    UIView *aniIndicator = isRight ? self.rightCharacterIndicator : self.leftCharacterIndicator;
    UIView *disAniIndicator = isRight ? self.leftCharacterIndicator : self.rightCharacterIndicator;
    UIButton *disappearButton = isRight ? self.leftChooseButton : self.rightChooseButton;
    _leverage += 1;
    
    UIButton *contentButton = isRight ? self.rightChooseButton : self.leftChooseButton;
    [UIView scaleAndShrinkAnimationForView:contentButton andCompletion:nil];
    [contentButton setTitle:[NSString stringWithFormat:@"+%ld",_leverage * [XJHappyFishManager sharedManager].fishbetBasicCoinCost] forState:UIControlStateNormal];
    if (_leverage == 1) {
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             disappearButton.alpha = 0.0;
                             disAniIndicator.alpha = 0.0;
                         } completion:nil];
    }
    
    if (_leverage == [XJHappyFishManager sharedManager].fishbetMaxLeverage) {
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             aniIndicator.alpha = 0.0;
        } completion:nil];
    }
    [UIView scaleAndShrinkAnimationForView:aniView andCompletion:nil];
    if (_shouldAnimation) {
        _shouldAnimation = NO;
        self.leftCharacterView.userInteractionEnabled = !isRight;
        self.rightCharacterView.userInteractionEnabled = isRight;
        self.leftCharacterIndicator.alpha = isRight ? 0.0 : 1.0;
        self.rightCharacterIndicator.alpha = isRight ? 1.0 : 0.0;
        
        UILabel *aniLabel = isRight ? self.rightCharacterIndicatorlabel : self.leftCharacterIndicatorLabel;
        
        [UIView scaleAndShrinkAnimationForView:aniLabel andCompletion:nil];
        
        aniLabel.text = NSLocalizedString(@"FishBattle_MoreStake_Text", nil);
        if (isRight) {
            [self.leftCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(3 * Fish_Screen_Width_Ratio);
                make.top.equalTo(self).offset(34 * Fish_Screen_Height_Ratio + 96 * (1.0 - Not_Choose_Multi) / 2.0);
                make.width.mas_equalTo(92 * Fish_Screen_Width_Ratio * Not_Choose_Multi);
                make.height.mas_equalTo(96 * Fish_Screen_Height_Ratio * Not_Choose_Multi);
            }];
        }else{
            [self.rightCharacterView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-3 * Fish_Screen_Width_Ratio);
                make.top.equalTo(self).offset(34 * Fish_Screen_Height_Ratio + 96 * (1.0 - Not_Choose_Multi) / 2.0);
                make.width.mas_equalTo(92 * Fish_Screen_Width_Ratio * Not_Choose_Multi);
                make.height.mas_equalTo(96 * Fish_Screen_Height_Ratio * Not_Choose_Multi);
            }];
        }
        
        [UIView springAnimationWithDuration:0.4
                                 animations:^{
                                     [self layoutIfNeeded];
                                 }
                              AndCompletion:^{
                              }];
    }
}

#pragma mark - target-action
- (void)leftCharacterViewDidTap{
    [self animationForChoosePlayerIsRight:NO];
}

- (void)rightCharacterViewDidTap{
    [self animationForChoosePlayerIsRight:YES];
}

- (void)leftChooseButtonDidClick{
    [self animationForChoosePlayerIsRight:NO];
}

- (void)rightChooseButtonDidClick{
    [self animationForChoosePlayerIsRight:YES];
}

#pragma mark - private
- (void)addShakeAnimation{
    if ([self.leftCharacterIndicator.layer animationForKey:leftPlayerIndicatorKey] != nil && [self.rightCharacterIndicator.layer animationForKey:rightPlayerIndicatorKey] != nil) {
        return;
    }
    CGFloat duration = 1.2;
    CGFloat rangeWidth = 10.0 * ScreenWidthRatio;
    CAKeyframeAnimation *ani1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    ani1.duration = duration;
    ani1.values = @[@(0),@(rangeWidth),@(0),@(-rangeWidth),@(0)];
    ani1.repeatCount = MAXFLOAT;
    ani1.removedOnCompletion = NO;
    ani1.fillMode = kCAFillModeForwards;
    ani1.timingFunction = [CAMediaTimingFunction functionWithName:kCAAnimationLinear];
    [self.leftCharacterIndicator.layer addAnimation:ani1 forKey:leftPlayerIndicatorKey];
    
    CAKeyframeAnimation *ani2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    ani2.duration = duration;
    ani2.values = @[@(0),@(-rangeWidth),@(0),@(rangeWidth),@(0)];
    ani2.repeatCount = MAXFLOAT;
    ani2.removedOnCompletion = NO;
    ani2.fillMode = kCAFillModeForwards;
    ani2.timingFunction = [CAMediaTimingFunction functionWithName:kCAAnimationLinear];
    [self.rightCharacterIndicator.layer addAnimation:ani2 forKey:rightPlayerIndicatorKey];
}

- (void)resetState{
    self.leftCharacterView.userInteractionEnabled = YES;
    self.rightCharacterView.userInteractionEnabled = YES;
    self.leftCharacterIndicatorLabel.text = NSLocalizedString(@"FishBattle_StakeMe_Text", nil);
    self.rightCharacterIndicatorlabel.text = NSLocalizedString(@"FishBattle_StakeMe_Text", nil);
    _shouldAnimation = YES;
    _leverage = 0;
    _chooseRight = NO;
}

#pragma mark - getter
- (UIImageView *)leftCharacterView{
    if (!_leftCharacterView) {
        _leftCharacterView = [[UIImageView alloc] init];
        _leftCharacterView.image = [UIImage imageNamed:@"fish_bet_player_left"];
        _leftCharacterView.userInteractionEnabled = YES;
        _leftCharacterView.exclusiveTouch = YES;
        [_leftCharacterView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftCharacterViewDidTap)]];
    }
    return _leftCharacterView;
}

- (UIImageView *)rightCharacterView{
    if (!_rightCharacterView) {
        _rightCharacterView = [[UIImageView alloc] init];
        _rightCharacterView.image = [UIImage imageNamed:@"fish_bet_player_right"];
        _rightCharacterView.userInteractionEnabled = YES;
        _rightCharacterView.exclusiveTouch = YES;
        [_rightCharacterView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightCharacterViewDidTap)]];
    }
    return _rightCharacterView;
}

- (UIImageView *)rewardView{
    if (!_rewardView) {
        _rewardView = [[UIImageView alloc] init];
        _rewardView.image = [UIImage imageNamed:@"fishbet_reward"];
        _rewardView.hidden = YES;
    }
    return _rewardView;
}

- (UIImageView *)leftCharacterIndicator{
    if (!_leftCharacterIndicator) {
        _leftCharacterIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fishplayer_indicator_left"]];
    }
    return _leftCharacterIndicator;
}

- (UIImageView *)rightCharacterIndicator{
    if (!_rightCharacterIndicator) {
        _rightCharacterIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fishplayer_indicator_right"]];
    }
    return _rightCharacterIndicator;
}

- (UILabel *)leftCharacterIndicatorLabel{
    if (!_leftCharacterIndicatorLabel) {
        _leftCharacterIndicatorLabel = [[UILabel alloc] init];
        _leftCharacterIndicatorLabel.text = NSLocalizedString(@"FishBattle_StakeMe_Text", nil);
        _leftCharacterIndicatorLabel.textColor = kColorWithHexValue(@"#006e04");
        _leftCharacterIndicatorLabel.textAlignment = NSTextAlignmentCenter;
        _leftCharacterIndicatorLabel.font = [UIFont systemFontOfSize:14 * Fish_Screen_Width_Ratio];
    }
    return _leftCharacterIndicatorLabel;
}

- (UILabel *)rightCharacterIndicatorlabel{
    if (!_rightCharacterIndicatorlabel) {
        _rightCharacterIndicatorlabel = [[UILabel alloc] init];
        _rightCharacterIndicatorlabel.text = NSLocalizedString(@"FishBattle_StakeMe_Text", nil);
        _rightCharacterIndicatorlabel.textColor = kColorWithHexValue(@"#006484");
        _rightCharacterIndicatorlabel.textAlignment = NSTextAlignmentCenter;
        _rightCharacterIndicatorlabel.font = [UIFont systemFontOfSize:14 * Fish_Screen_Width_Ratio];
    }
    return _rightCharacterIndicatorlabel;
}

- (UIButton *)leftChooseButton{
    if (!_leftChooseButton) {
        _leftChooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftChooseButton.exclusiveTouch = YES;
        [_leftChooseButton setBackgroundImage:[UIImage imageNamed:@"choose_left_bg"] forState:UIControlStateNormal];
        [_leftChooseButton setTitleColor:kColorWithHexValue(@"#007604") forState:UIControlStateNormal];
        [_leftChooseButton setTitleColor:kColorWithHexValue(@"#9e856d") forState:UIControlStateDisabled];
        _leftChooseButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:20];
        _leftChooseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_leftChooseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -50 * Fish_Screen_Width_Ratio , 0 , 0)];
        [_leftChooseButton setTitle:NSLocalizedString(@"FishBattle_ChooseInitial_Button", nil) forState:UIControlStateNormal];
        [_leftChooseButton addTarget:self action:@selector(leftChooseButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftChooseButton;
}

- (UIButton *)rightChooseButton{
    if (!_rightChooseButton) {
        _rightChooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightChooseButton.exclusiveTouch = YES;
        [_rightChooseButton setBackgroundImage:[UIImage imageNamed:@"choose_right_bg"] forState:UIControlStateNormal];
        [_rightChooseButton setTitleColor:kColorWithHexValue(@"#006f92") forState:UIControlStateNormal];
        [_rightChooseButton setTitleColor:kColorWithHexValue(@"#818c94") forState:UIControlStateDisabled];
        _rightChooseButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:20];
        _rightChooseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_rightChooseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -50 * Fish_Screen_Width_Ratio , 0 , 0)];
        [_rightChooseButton setTitle:NSLocalizedString(@"FishBattle_ChooseInitial_Button", nil) forState:UIControlStateNormal];
        [_rightChooseButton addTarget:self action:@selector(rightChooseButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightChooseButton;
}

@end
