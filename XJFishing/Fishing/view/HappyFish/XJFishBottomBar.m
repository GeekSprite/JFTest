//
//  XJFishBottomBar.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/15.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XJFishBottomBar.h"
#import "XJHappyFishManager.h"
#import "Masonry.h"
#import "SoundManager+BackgroundMusic.h"

@interface XJFishBottomBar ()

@property(nonatomic, strong) UIImageView *containerView;
@property(nonatomic, strong) UIImageView *progressView;

@end

static NSString *const Wait_Animation_Key = @"Wait_Animation_Key";
@implementation XJFishBottomBar

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configView];
        [self registerObserver];
    }
    return self;
}

- (void)configView{
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.bottom.equalTo(self);
        make.height.mas_equalTo(67 * SCREEN_WIDTH / 414.0);
    }];
    
    [self addSubview:self.startButton];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(140 * SCREEN_WIDTH / 414.0);
        make.width.mas_equalTo(140 * SCREEN_WIDTH / 414.0);
        make.bottom.equalTo(self).offset(2 * SCREEN_WIDTH / 414.0);
    }];
    
    [self.startButton addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.startButton);
        make.height.width.equalTo(self.startButton).multipliedBy(130.0/140.0);
    }];
    
    [self addSubview:self.betSelectButton];
    [self.betSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24 * SCREEN_WIDTH / 414.0);
        make.bottom.equalTo(self).offset(-11 * SCREEN_HEIGHT / 736.0);
        make.height.mas_equalTo(36 * SCREEN_HEIGHT / 736.0);
        make.width.mas_equalTo(90 * SCREEN_WIDTH / 414.0);
    }];
    
    [self addSubview:self.betLeverView];
    [self.betLeverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.betSelectButton);
        make.bottom.equalTo(self.betSelectButton.mas_top).offset(-5 * SCREEN_HEIGHT / 736.0);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(8);
    }];
}

- (void)removeFromSuperview{
    [self stopWaitAnimation];
    [self unregisterObserver];
    [super removeFromSuperview];
}

#pragma mark - kvo

- (void)registerObserver {
    [self.startButton addObserver:self
                       forKeyPath:@"enabled"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
}

- (void)unregisterObserver {
    [self.startButton removeObserver:self
                     forKeyPath:@"enabled"
                        context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"enabled"]) {
        BOOL isEnabled = ((NSNumber *)change[NSKeyValueChangeNewKey]).boolValue;
        if (isEnabled) {
            [self stopWaitAnimation];
        }else{
            [self startWaitAnimation];
        }
    }
}

#pragma mark - action
- (void)startButtonDidClick:(UIControl *)sender{
        [[SoundManager sharedManager] playSound:@"game_start.mp3"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStart)]) {
        [self.delegate didClickStart];
    }
}

- (void)betSelectButtonDidClick:(UIControl *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBetSelect)]) {
        [self.delegate didClickBetSelect];
    }
}

#pragma mark - private

- (void)startWaitAnimation{
    self.progressView.hidden = NO;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = MAXFLOAT;
    group.duration = 2.0;
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ani.fromValue = @(0);
    ani.toValue = @(-M_PI * 2.0);
    ani.duration = 3.6;
    ani.repeatCount = MAXFLOAT;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *ani1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ani1.fromValue = @(120/130.0);
    ani1.toValue = @(150.0/130.0);
    ani1.autoreverses = YES;
    ani1.duration = 1.0;
    ani1.repeatCount = MAXFLOAT;
    ani1.removedOnCompletion = NO;
    ani1.fillMode = kCAFillModeForwards;
    ani1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group.animations = @[ani,ani1];
    [self.progressView.layer addAnimation:ani forKey:Wait_Animation_Key];
}

- (void)stopWaitAnimation{
    self.progressView.hidden = YES;
    [self.progressView.layer removeAnimationForKey:Wait_Animation_Key];
}

#pragma mark - getter
- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"fishBgBar"];
    }
    return _containerView;
}

- (UIButton *)startButton{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"fISHBtnGo"] forState:UIControlStateNormal];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"fISHBtnGoPressed"] forState:UIControlStateHighlighted];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"fISHBtnGoDisable"] forState:UIControlStateDisabled];
        [_startButton addTarget:self action:@selector(startButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)betSelectButton{
    if (!_betSelectButton) {
        _betSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_betSelectButton setBackgroundImage:[UIImage imageNamed:@"fishBtnBat"] forState:UIControlStateNormal];
        [_betSelectButton setTitleColor:kColorWithHexValue(@"#f7cf3e") forState:UIControlStateNormal];
        [_betSelectButton setTitle:[NSString stringWithFormat:@"%@",[[XJHappyFishManager sharedManager] perBet]] forState:UIControlStateNormal];
        _betSelectButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:20];
        _betSelectButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_betSelectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 22)];
        [_betSelectButton addTarget:self action:@selector(betSelectButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _betSelectButton;
}

- (UIImageView *)betLeverView{
    if (!_betLeverView) {
        _betLeverView = [[UIImageView alloc] init];
        _betLeverView.image = [UIImage imageNamed:@"fishImgUp"];
    }
    return _betLeverView;
}

- (UIImageView *)progressView{
    if (!_progressView) {
        _progressView = [[UIImageView alloc] init];
        _progressView.image = [UIImage imageNamed:@"tAPBtnTapEffect"];
        _progressView.hidden = YES;
    }
    return _progressView;
}

@end
