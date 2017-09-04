//
//  XJCountDownView.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/20.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XJCountDownView.h"
#import "Masonry.h"

#define Count_Down_Duration     1.0
#define Disappear_Duration      0.15

@interface XJCountDownView ()

@property(nonatomic, strong) UIImageView *frontView;
@property(nonatomic, strong) UIImageView *temCountView;
@property(nonatomic, copy) dispatch_block_t countDownCompletion;
@property(nonatomic) NSInteger countDownTime;
@property(nonatomic) NSInteger countTotalTime;

@end

@implementation XJCountDownView
#pragma amrk - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

#pragma mark - configView
- (void)configView{
    [self addSubview:self.frontView];
    [self.frontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.temCountView];
    [self.temCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.frontView);
    }];
    [self bringSubviewToFront:self.frontView];
}

#pragma mark - public
- (void)startCountDown:(NSInteger)countTime WithCompletion:(dispatch_block_t)completion{
    self.countDownTime = countTime;
    self.countTotalTime = countTime;
    self.countDownCompletion = completion;
     self.frontView.alpha = 1.0;
    [self performSelector:@selector(refreshViewAfterTimeChange) withObject:nil afterDelay:0.0];
}

#pragma mark - private
- (void)refreshViewAfterTimeChange{
    if (self.countDownTime > 0) {
        [self animationForTimeChange];
        [self performSelector:@selector(refreshViewAfterTimeChange) withObject:nil afterDelay:self.countDownTime == self.countTotalTime ? Count_Down_Duration - Disappear_Duration : Count_Down_Duration];
        self.countDownTime -= 1;
    }else{
        [UIView animateWithDuration:Disappear_Duration animations:^{
            self.frontView.alpha = 0.0;
            self.temCountView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (self.countDownCompletion) {
                self.countDownCompletion();
            }
        }];
        
    }
}

- (void)animationForTimeChange{
    NSInteger currentCount = self.countDownTime;
    self.frontView.image = [UIImage imageNamed:[NSString stringWithFormat:@"countdown_%ld",currentCount]];
    BOOL shouldDoFrontAnimation = currentCount < self.countTotalTime;
    self.frontView.transform = CGAffineTransformScale(self.frontView.transform, 1.6, 1.6);
    if (shouldDoFrontAnimation) {
        self.temCountView.image = [UIImage imageNamed:[NSString stringWithFormat:@"countdown_%ld",currentCount + 1]];
        self.temCountView.alpha = 1.0;
        CGAffineTransform transform1 = CGAffineTransformScale(self.temCountView.transform, 1.6, 1.6);
        CGAffineTransform transform2 = CGAffineTransformTranslate(self.temCountView.transform, 0.0, -self.frame.size.height * 0.3);
        self.temCountView.transform = CGAffineTransformConcat(transform1, transform2);
    }
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frontView.transform = CGAffineTransformIdentity;
                         
                         if (shouldDoFrontAnimation) {
                             CGAffineTransform transform1 = CGAffineTransformScale(self.temCountView.transform, 0.1, 0.1);
                             CGAffineTransform transform2 = CGAffineTransformTranslate(self.temCountView.transform, 0.0, -self.frame.size.height * 0.10);
                             self.temCountView.transform = CGAffineTransformConcat(transform1, transform2);
                             self.temCountView.alpha = 0.10;
                         }
    } completion:^(BOOL finished) {
        if (shouldDoFrontAnimation) {
            self.temCountView.alpha = 0.0;
            self.temCountView.transform = CGAffineTransformIdentity;
            [self.temCountView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.frontView);
            }];
        }
    }];
}

#pragma mark - getter
- (UIImageView *)frontView{
    if (!_frontView) {
        _frontView = [[UIImageView alloc] init];
        _frontView.alpha = 0.0;
    }
    return _frontView;
}

- (UIImageView *)temCountView{
    if (!_temCountView) {
        _temCountView = [[UIImageView alloc] init];
        _temCountView.alpha = 0.0;
    }
    return _temCountView;
}

@end
