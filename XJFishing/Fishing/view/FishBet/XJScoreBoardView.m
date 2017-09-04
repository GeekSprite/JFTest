//
//  XJScoreBoardView.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/17.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XJScoreBoardView.h"
#import "Masonry.h"
#import "UIView+FishGameAnimation.h"

#define Design_Fish_Count   5
#define Fish_Screen_Height_Ratio    (SCREEN_HEIGHT/736.0)
#define Fish_Screen_Width_Ratio     (SCREEN_WIDTH/414.0)

@interface XJScoreBoardView ()

@property(nonatomic, strong) UIImageView *containerView;
@property(nonatomic, strong) NSMutableArray<UIImageView *> *leftImageViews;
@property(nonatomic, strong) NSMutableArray<UIImageView *> *rightImageViews;
@property(nonatomic) NSInteger leftCount;
@property(nonatomic) NSInteger rightCount;

@end

@implementation XJScoreBoardView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configView];
        [self resetState];
    }
    return self;
}

#pragma mark - configView
- (void)configView{
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_top).offset(-Score_Board_Top);
    }];
    
    for (int index = 0 ; index < Design_Fish_Count; index ++ ) {
        UIImageView *leftImgView = [[UIImageView alloc] init];
        [self.containerView addSubview:leftImgView];
        [self.leftImageViews addObject:leftImgView];
        [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(28 * Fish_Screen_Width_Ratio);
            make.top.equalTo(self.containerView).offset(13 * Fish_Screen_Height_Ratio);
            make.bottom.equalTo(self.containerView).offset(-14 * Fish_Screen_Height_Ratio);
            make.left.equalTo(self.containerView).offset(11 * Fish_Screen_Width_Ratio + (32 * Fish_Screen_Width_Ratio)*index);
        }];
        
        UIImageView *rightImgView = [[UIImageView alloc] init];
        [self.containerView addSubview:rightImgView];
        [self.rightImageViews addObject:rightImgView];
        [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(28 * Fish_Screen_Width_Ratio);
            make.top.equalTo(self.containerView).offset(13 * Fish_Screen_Height_Ratio);
            make.bottom.equalTo(self.containerView).offset(-14 * Fish_Screen_Height_Ratio);
            make.right.equalTo(self.containerView).offset(-11 * Fish_Screen_Width_Ratio - (32 * Fish_Screen_Width_Ratio)*index);
        }];
    }
}

#pragma mark - public
- (void)addScoreToLeft:(BOOL)isLeft{
    if (isLeft) {
        if (self.leftCount < Design_Fish_Count) {
            self.leftCount += 1;
            UIImageView *imgView = self.leftImageViews[self.leftCount - 1];
            imgView.image = [UIImage imageNamed:@"fishbet_score_reward"];
            imgView.transform = CGAffineTransformScale(imgView.transform, 1.5, 1.5);
            [UIView animateWithDuration:0.25 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                imgView.transform = CGAffineTransformIdentity;
            }];
        }
    }else{
        if (self.rightCount < Design_Fish_Count) {
            self.rightCount += 1;
            UIImageView *imgView = self.rightImageViews[self.rightCount - 1];
            imgView.image = [UIImage imageNamed:@"fishbet_score_reward"];
            imgView.transform = CGAffineTransformScale(imgView.transform, 1.5, 1.5);
            [UIView animateWithDuration:0.25 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                imgView.transform = CGAffineTransformIdentity;
            }];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            imgView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 1, 0);
            [CATransaction commit];
        }
    }
}

- (void)animationForAppearWithCompletion:(dispatch_block_t)completion{
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.containerView.hidden = NO;
    [UIView springAnimationWithDuration:0.5
                             animations:^{
                                 [self layoutIfNeeded];
                             }
                          AndCompletion:^{
                                if (completion) {
                                    completion();
                                }
            }];
}

- (void)animationForDisappearWithCompletion:(dispatch_block_t)completion{
    [self resetState];
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_top).offset(-Score_Board_Top
                                                 );
    }];
    [UIView springAnimationWithDuration:0.5
                             animations:^{
                                 [self layoutIfNeeded];
                             }
                          AndCompletion:^{
                              self.containerView.hidden = YES;
                              if (completion) {
                                  completion();
                              }
                          }];
}

#pragma mark - private
- (void)resetState{
    self.leftCount = 0;
    self.rightCount = 0;
    for (UIImageView *imgView in self.leftImageViews) {
        imgView.image = [UIImage imageNamed:@"fish_score_placeHolder"];
        imgView.layer.transform = CATransform3DIdentity;;
    }
    for (UIImageView *imgView in self.rightImageViews) {
        imgView.image = [UIImage imageNamed:@"fish_score_placeHolder"];
        imgView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 1, 0);
    }
}

#pragma mark - getter
- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"fish_score_board"];
        _containerView.hidden = YES;
    }
    return _containerView;
}

- (NSMutableArray<UIImageView *> *)leftImageViews{
    if (!_leftImageViews) {
        _leftImageViews = [NSMutableArray arrayWithCapacity:Design_Fish_Count];
    }
    return _leftImageViews;
}

- (NSMutableArray<UIImageView *> *)rightImageViews{
    if (!_rightImageViews) {
        _rightImageViews = [NSMutableArray arrayWithCapacity:Design_Fish_Count];
    }
    return _rightImageViews;
}

@end
