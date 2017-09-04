//
//  XJFishRewardView.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/14.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XJFishRewardView.h"
#import "Masonry.h"
#import "XJOutLineLabel.h"

@interface XJFishRewardView ()

@property(nonatomic) NSInteger fishCount;
@property(nonatomic) NSInteger rewardsCount;
@property(nonatomic, strong) XJOutLineLabel *rewardsLabel;
@property(nonatomic, strong) XJOutLineLabel *coinsPlaceHolderLabel;
@property(nonatomic, strong) UIImageView *fishCountBg;
@property(nonatomic, strong) UIImageView *fishCountView1;
@property(nonatomic, strong) UIImageView *fishCountView2;
@property(nonatomic, strong) UIView *fishCountContainer;

@end

@implementation XJFishRewardView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self configView];
    }
    return self;
}

#pragma mark - configView
- (void)configView{
    [self addSubview:self.rewardsLabel];
    [self.rewardsLabel sizeToFit];
    [self.rewardsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(-150);
        make.top.equalTo(self);
        make.height.mas_equalTo(self.rewardsLabel.frame.size.height + 4);
        make.width.mas_equalTo(self.rewardsLabel.frame.size.width + 4);
    }];
    
    [self addSubview:self.coinsPlaceHolderLabel];
    [self.coinsPlaceHolderLabel sizeToFit];
    [self.coinsPlaceHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rewardsLabel.mas_right).offset(5.0);
        make.top.equalTo(self.rewardsLabel).offset(28 * SCREEN_HEIGHT / 736.0);
        make.height.mas_equalTo(self.coinsPlaceHolderLabel.frame.size.height + 4);
        make.width.mas_equalTo(self.coinsPlaceHolderLabel.frame.size.width + 4);
    } ];
    
    [self addSubview:self.fishCountBg];
    [self.fishCountBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(-150);
        make.top.equalTo(self.rewardsLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(150);
    }];
    
    [self.fishCountBg addSubview:self.fishCountContainer];
    [self.fishCountContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fishCountBg).offset(10);
        make.top.equalTo(self.fishCountBg).offset(20);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
    
    [self.fishCountContainer addSubview:self.fishCountView1];
    [self.fishCountView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fishCountBg).offset(6);
        make.top.equalTo(self.fishCountBg).offset(20);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(56);
    }];
    
    [self.fishCountContainer addSubview:self.fishCountView2];
    [self.fishCountView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fishCountBg).offset(30);
        make.top.equalTo(self.fishCountBg).offset(20);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(56);
    }];
}

#pragma mark - public
- (void)updateWithFishCount:(NSInteger)fishCount andReward:(NSInteger)rewards{
    self.hidden = NO;
    [self updateConstraintsAfterReward];
    [self layoutIfNeeded];
    [self.rewardsLabel setText:[NSString stringWithFormat:@"+%ld",(long)rewards]];
    if (fishCount > 9) {
        self.fishCountView2.hidden = NO;
        NSInteger ten = fishCount / 10;
        NSInteger num = fishCount % 10;
         [self.fishCountView1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"num%ld",(long)ten]]];
         [self.fishCountView2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"num%ld",(long)num]]];
        [self.fishCountView1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fishCountBg).offset(6);
            make.top.equalTo(self.fishCountBg).offset(20);
            make.width.mas_equalTo(33);
            make.height.mas_equalTo(56);
        }];
        
        [self.fishCountView2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fishCountBg).offset(30);
            make.top.equalTo(self.fishCountBg).offset(20);
            make.width.mas_equalTo(33);
            make.height.mas_equalTo(56);
        }];
    }else{
        self.fishCountView2.hidden = YES;
        [self.fishCountView1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"num%ld",(long)fishCount]]];
        [self.fishCountView1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fishCountBg).offset(10);
            make.top.equalTo(self.fishCountBg).offset(20);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(56);
        }];
    }
    [self updateConstraintsForReward];
    [UIView animateWithDuration:0.15
                          delay:0.05
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self layoutIfNeeded];
                     }
                     completion:nil];
    [UIView animateWithDuration:0.25 delay:0.18 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.rewardsLabel.alpha = 1.0;
        self.fishCountContainer.alpha = 1.0;
        self.coinsPlaceHolderLabel.alpha = 1.0;
        self.fishCountContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)stopRewardAnimation{
    self.hidden = YES;
    [self updateConstraintsAfterReward];
    [self layoutIfNeeded];
}

- (void)updateConstraintsForReward{
    [self.rewardsLabel sizeToFit];
    [self.rewardsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.rewardsLabel.frame.size.width);
    }];
    [self.fishCountBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.rewardsLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(150);
    }];
    

}

- (void)updateConstraintsAfterReward{
    [self.rewardsLabel sizeToFit];
    [self.rewardsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(-200);
        make.top.equalTo(self);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.rewardsLabel.frame.size.width);
    }];

    [self.fishCountBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(-200);
        make.top.equalTo(self.rewardsLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(150);
    }];
    
    self.rewardsLabel.alpha = 0.0;
    self.coinsPlaceHolderLabel.alpha = 0.0;
    self.fishCountContainer.alpha = 0.0;
    self.fishCountContainer.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
}

#pragma mark - getter

- (XJOutLineLabel *)rewardsLabel{
    if (!_rewardsLabel) {
        _rewardsLabel = [[XJOutLineLabel alloc] init];
        _rewardsLabel.textAlignment = NSTextAlignmentLeft;
        _rewardsLabel.text = @"+100";
        _rewardsLabel.font = [UIFont fontWithName:@"DunkinSans-Bold" size:36];
        _rewardsLabel.fillColor = kColorWithHexValue(@"#F0FFFF");
        _rewardsLabel.strokenColor = kColorWithHexValue(@"#075ebd");
        _rewardsLabel.strokeWidth = 2.0;
    }
    return _rewardsLabel;
}

- (UIImageView *)fishCountBg{
    if (!_fishCountBg) {
        _fishCountBg = [[UIImageView alloc] init];
        _fishCountBg.image = [UIImage imageNamed:@"fishImgOnehook"];
    }
    return _fishCountBg;
}

- (UIImageView *)fishCountView1{
    if (!_fishCountView1) {
        _fishCountView1 = [[UIImageView alloc] init];
        _fishCountView1.image = [UIImage imageNamed:@"num1"];
    }
    return _fishCountView1;
}

- (UIImageView *)fishCountView2{
    if (!_fishCountView2) {
        _fishCountView2 = [[UIImageView alloc] init];
        _fishCountView2.image = [UIImage imageNamed:@"num1"];
    }
    return _fishCountView2;
}

- (UIView *)fishCountContainer{
    if (!_fishCountContainer) {
        _fishCountContainer = [[UIView alloc] init];
        _fishCountContainer.backgroundColor = [UIColor clearColor];
    }
    return _fishCountContainer;
}

- (XJOutLineLabel *)coinsPlaceHolderLabel{
    if (!_coinsPlaceHolderLabel) {
        _coinsPlaceHolderLabel = [[XJOutLineLabel alloc] init];
        _coinsPlaceHolderLabel.textAlignment = NSTextAlignmentCenter;
        _coinsPlaceHolderLabel.text = @"coins";
        _coinsPlaceHolderLabel.fillColor = kColorWithHexValue(@"#F0FFFF");
        _coinsPlaceHolderLabel.strokenColor = kColorWithHexValue(@"#075ebd");
        _coinsPlaceHolderLabel.strokeWidth = 2.0;
        _coinsPlaceHolderLabel.font = [UIFont fontWithName:@"DunkinSans-Bold" size:12];
    }
    return _coinsPlaceHolderLabel;
}
@end
