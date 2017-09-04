//
//  XJLeverListTableViewCell.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/14.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XJLeverListTableViewCell.h"
#import "XJHappyFishManager.h"
#import "Masonry.h"

@interface XJLeverListTableViewCell ()

@property(nonatomic, strong) UIImageView *containerView;
@property(nonatomic, strong) UIImageView *coinView;
@property(nonatomic, strong) UIImageView *indicatorView;
@property(nonatomic, strong) UILabel *betLabel;

@end

@implementation XJLeverListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self configView];
    }
    return self;
}

#pragma mark - config View
- (void)configView{
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(14 * SCREEN_WIDTH / 414.0);
        make.height.mas_equalTo(13 * SCREEN_WIDTH / 414.0);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(6 * SCREEN_WIDTH / 414.0);
    }];
    
    [self addSubview:self.coinView];
    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24 * SCREEN_WIDTH / 414.0);
        make.width.mas_equalTo(24 * SCREEN_WIDTH / 414.0);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-16 * SCREEN_WIDTH / 414.0);
    }];
    [self addSubview:self.betLabel];
    [self.betLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.coinView.mas_left).offset(-4 * SCREEN_WIDTH / 414.0);
    }];
}

- (void)setLeverage:(NSInteger)leverage{
    _leverage = leverage;
    NSInteger baseCoin = [XJHappyFishManager sharedManager].perBet.integerValue / [XJHappyFishManager sharedManager].currentLeverage.integerValue;
    [self.betLabel setText:[NSString stringWithFormat:@"%ld",baseCoin * leverage]];
    self.indicatorView.hidden = YES;
    if (leverage == [XJHappyFishManager sharedManager].currentLeverage.integerValue) {
        self.indicatorView.hidden = NO;
    }
    NSInteger index = [[XJHappyFishManager sharedManager].leverList indexOfObject:@(leverage)];
    if (index == 0) {
        [self.containerView setImage:[UIImage imageNamed:@"fISHBgBat3"]];
    }else if(index == [XJHappyFishManager sharedManager].leverList.count - 1){
        [self.containerView setImage:[UIImage imageNamed:@"fISHBgBat1"]];
    }else{
        [self.containerView setImage:[UIImage imageNamed:@"fISHBgBat2"]];
    }
}

- (UILabel *)betLabel{
    if (!_betLabel) {
        _betLabel = [[UILabel alloc] init];
        _betLabel.textAlignment = NSTextAlignmentRight;
        _betLabel.textColor = kColorWithHexValue(@"#F7CF3E");
        _betLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:20];
    }
    return _betLabel;
}

- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] init];
        [_indicatorView setImage:[UIImage imageNamed:@"fishImgChoice"]];
        self.indicatorView.hidden = YES;
    }
    return _indicatorView;
}

- (UIImageView *)coinView{
    if (!_coinView) {
        _coinView = [[UIImageView alloc] init];
        _coinView.image = [UIImage imageNamed:@"coin_icon_small"];
        _coinView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coinView;
}

@end
