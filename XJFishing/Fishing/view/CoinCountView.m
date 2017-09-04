//
//  CoinCountView.m
//  Turntable
//
//  Created by HeJi on 16/6/17.
//  Copyright © 2016年 HeJi. All rights reserved.
//

#import "CoinCountView.h"
#import "NSString+Size.h"
#import "GlobalColors.h"
#import "Masonry.h"

#define DefaultCountLabelWidth 36.0
#define DefaultBackgroundImageWidth 90.0

@interface CoinCountView ()

@property (nonatomic, strong) UIImageView           *backgroundImageView;
@property (nonatomic, strong) UIImageView           *coinImageView;
@property (nonatomic, strong) UILabel               *coinCountLabel;
@property (nonatomic, strong) UIButton              *coinButton;
@property (nonatomic, strong) UIImageView           *coinBadgeImageView;

@end

@implementation CoinCountView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubviews];

    }
    return self;
}

- (void)configureSubviews{
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.coinCountLabel];
    [self.coinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.0);
        make.bottom.equalTo(self).offset(-3.0);
        make.height.mas_equalTo(20.0);
        make.width.mas_greaterThanOrEqualTo(DefaultCountLabelWidth);
    }];
    
    [self addSubview:self.coinButton];
    [self.coinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //add red dot image view
    [self addSubview:self.coinBadgeImageView];
    [self.coinBadgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8.0, 8.0));
        make.right.equalTo(self).offset(-2.0);
        make.top.equalTo(self).offset(6.0);
    }];

    [self addSubview:self.coinImageView];
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5.0);
        make.bottom.equalTo(self).offset(-5.0);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(30.0);
    }];
    self.coinImageView.hidden = YES;
}


#pragma mark - Public
- (void)onlyShowCoinCountAndIcon {
    self.backgroundImageView.hidden = YES;
    self.coinImageView.hidden = NO;
}

- (void)onlyShowCoinIcon {
    self.backgroundImageView.hidden = YES;
    self.coinCountLabel.hidden = YES;
    self.coinImageView.hidden = NO;
}

- (CGRect)coinViewFrameInSuperView{
    if (!self.superview) {
        return CGRectZero;
    }
    return [self convertRect:self.coinImageView.frame toView:self.superview];
}

- (void)disableCoinBadgeDisplay {

    [self.coinBadgeImageView removeFromSuperview];
    self.coinBadgeImageView = nil;
    self.userInteractionEnabled = NO;
}

- (void)playAnimationWithDeductCoinCount:(NSInteger)count {
    UIView *contain = [[UIView alloc] init];
    
    UIImageView *coin = [[UIImageView alloc] init];
    coin.contentMode = UIViewContentModeScaleAspectFit;
    coin.image = [UIImage imageNamed:@"coin_icon_small"];
    
    UILabel *coinCountLabel = [[UILabel alloc] init];
    coinCountLabel.backgroundColor = [UIColor clearColor];
    coinCountLabel.textColor = [UIColor hexStringToColor:@"#CA7604"];
        coinCountLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:25];
    coinCountLabel.textAlignment = NSTextAlignmentCenter;
    coinCountLabel.text = [NSString stringWithFormat:@"-%li", (long)count];
    [coinCountLabel sizeToFit];
    
    coin.frame = CGRectMake(DefaultBackgroundImageWidth - 35, 0, 30, 30);
    CGRect lFrame = [self convertRect:self.coinCountLabel.frame toView:self];
    coinCountLabel.frame = CGRectMake(lFrame.origin.x + (lFrame.size.width - coinCountLabel.frame.size.width)/2.0, 0, coinCountLabel.frame.size.width, coinCountLabel.frame.size.height);
    [contain addSubview:coin];
    [contain addSubview:coinCountLabel];
    
    contain.frame = CGRectMake(0, CGRectGetMidY(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    [self addSubview:contain];
    contain.alpha = 0.0;
    [UIView animateWithDuration:0.5
                     animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGAffineTransform s = CGAffineTransformMakeScale(1.0, 1.0);
        CGAffineTransform t = CGAffineTransformMakeTranslation(0, (self.frame.size.height + 40.0)/2.0);
        contain.transform = CGAffineTransformConcat(t, s);
        contain.alpha = 1.0;
    }   completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
                              delay:0.6
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            CGAffineTransform s = CGAffineTransformMakeScale(1.0, 1.0);
            CGAffineTransform t = CGAffineTransformMakeTranslation(0, (self.frame.size.height + 40.0));
            contain.transform = CGAffineTransformConcat(t, s);
            contain.alpha = 0.0;
        } completion:^(BOOL finished) {
            [contain removeFromSuperview];
        }];
    }];
    
    
}

#pragma mark -Action
- (void)onClick:(UIButton *)button{
    BOOL canClick = YES;
    if ([self.delegate respondsToSelector:@selector(canClickCoinCountView:)]) {
        canClick = [self.delegate canClickCoinCountView:self];
    }
    
    if (canClick) {

        

        if ([self.delegate respondsToSelector:@selector(coinCountViewDidClick:)]) {
            [self.delegate coinCountViewDidClick:self];
        }
        
    }

}

#pragma mark - LWCoinViewBadgeDisplayDelegate
- (void)coinViewBadgeDidUpdated:(BOOL)shouldDisplay {
    self.coinBadgeImageView.hidden = !shouldDisplay;
}

#pragma mark - Setter
- (void)setCoinCount:(NSInteger)coinCount{
    _coinCount = coinCount;
    // calculate width
    self.coinCountLabel.text = [NSString stringWithFormat:@"%@",@(coinCount)];
    
    CGFloat countWidth = self.coinCountLabel.intrinsicContentSize.width;
    if (countWidth > DefaultCountLabelWidth) {
        CGFloat delta = countWidth - DefaultCountLabelWidth;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DefaultBackgroundImageWidth +  delta);
        }];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DefaultBackgroundImageWidth);
        }];
    }
    [self.superview updateConstraintsIfNeeded];
    [self.superview layoutIfNeeded];
    
}

#pragma mark - Getter
- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"hOMECoinAmount_new"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 40.0) resizingMode:UIImageResizingModeStretch];
        _backgroundImageView.image = image;
    }
    return _backgroundImageView;
}

- (UILabel *)coinCountLabel{
    if (!_coinCountLabel) {
        _coinCountLabel = [[UILabel alloc] init];
        _coinCountLabel.font = kFontOfIdenfitier(@"Font_CoinsView_Coins_Count_Label");
        _coinCountLabel.textColor = CoinLabel_TextColor;
        _coinCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _coinCountLabel;
}

- (UIImageView *)coinImageView {
    if (!_coinImageView) {
        _coinImageView = [[UIImageView alloc] init];
        _coinImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coinImageView.image = [UIImage imageNamed:@"coin_icon_small"];
    }
    return _coinImageView;
}

- (UIButton *)coinButton{
    if (!_coinButton) {
        _coinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coinButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        _coinButton.backgroundColor = [UIColor clearColor];
    }
    return _coinButton;
}

- (UIImageView *)coinBadgeImageView{
    if (!_coinBadgeImageView) {
        _coinBadgeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _coinBadgeImageView.layer.cornerRadius = 4.0;
        _coinBadgeImageView.layer.masksToBounds = YES;
        _coinBadgeImageView.layer.backgroundColor = CoinView_Dot_FillColor.CGColor;
        _coinBadgeImageView.layer.borderColor = CoinView_Dot_BorderColor.CGColor;
        _coinBadgeImageView.layer.borderWidth = 1.0;
    }
    return _coinBadgeImageView;
}

@end
