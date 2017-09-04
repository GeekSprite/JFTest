//
//  XJStickView.m
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import "XJStickView.h"
#import "SoundManager+BackgroundMusic.h"

@interface XJStickView ()<CAAnimationDelegate>
{
    BOOL _isAppeared;
}

@property(nonatomic, strong) CALayer *stickWireLayer;
@property(nonatomic, strong) CALayer *stickLayer;
@property(nonatomic, strong) CALayer *biteLayer;
@property(nonatomic, copy) dispatch_block_t takeUpWireCompletion;
@property(nonatomic, copy) ThrowWireCompetion throwWireCompletion;
@property(nonatomic) CATransform3D initialTransform;
@property(nonatomic) XJStickViewDirection direction;

@end

static NSString *const throwWireAnimationKey    = @"throwWireAnimationKey";
static NSString *const takeUpWireAnimationKey   = @"takeUpWireAnimationKey";

@implementation XJStickView

#pragma mark - init & deinit

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.fishStickImage = [UIImage imageNamed:@"fishImgFishingrod"];
        self.isReady = YES;
        _isAppeared = NO;
        self.direction = XJStickViewDirectionRight;
    }
    return self;
}

- (instancetype)initWithDirection:(XJStickViewDirection)direction{
    if (self = [super initWithFrame:CGRectZero]) {
        self.direction = direction;
    }
    return self;
}

#pragma mark - life circle

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_isAppeared) {
        _isAppeared = YES;
        [self configView];
    }
}

#pragma mark - configView
- (void)configView{
    self.stickWireLayer.frame = CGRectMake(1, 1, 1, 0);
    [self.layer addSublayer:self.stickWireLayer];
    
    self.stickLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * Stick_Height_Ratio);
    [self.layer addSublayer:self.stickLayer];
    
    self.biteLayer.frame = CGRectMake(-(Bite_Width)/2.0 , 0, Bite_Width, Bite_Width);
    [self.layer addSublayer:self.biteLayer];
    
    if (_direction == XJStickViewDirectionLeft) {
        self.layer.transform = CATransform3DRotate(self.layer.transform, M_PI, 0, 1, 0);
        self.layer.transform = CATransform3DRotate(self.layer.transform, -M_PI_2*3, 0, 0, 1);
    }else{
        self.layer.transform = CATransform3DRotate(self.layer.transform, M_PI_2, 0, 0, 1);
    }
    self.initialTransform = self.layer.transform;
    self.layer.anchorPoint = CGPointMake(1, 0);
}

#pragma mark - public
- (void)setFishStickImage:(UIImage *)fishStickImage{
    _fishStickImage = fishStickImage;
    self.stickLayer.contents = (__bridge id _Nullable)(fishStickImage.CGImage);
}

- (void)throwWireAnimationWithCompletion:(ThrowWireCompetion)completion{
    self.throwWireCompletion = completion;
    self.isReady = NO;

    CFTimeInterval duration = Stick_Animation_Duration;
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform"];
    ani.fromValue = [NSValue valueWithCATransform3D:self.initialTransform];
    ani.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.initialTransform, -M_PI_2, 0, 0, 1)];
    ani.duration = duration;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    ani.delegate = self;
    
    [self.layer addAnimation:ani forKey:throwWireAnimationKey];
}

- (void)takeUpWireAnimationWithCompletion:(void (^)(void))completion{
        self.takeUpWireCompletion = completion;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CGFloat duration = Take_Up_Animation_Duration;
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform"];
    ani.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
    ani.toValue = [NSValue valueWithCATransform3D:self.initialTransform];
    ani.duration = duration;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    group.animations = @[ani];
    group.delegate = self;
    [self.layer addAnimation:group forKey:takeUpWireAnimationKey];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([anim isEqual:[self.layer animationForKey:takeUpWireAnimationKey]]) {
        self.isReady = YES;
        [self.layer removeAllAnimations];
        self.layer.transform = self.initialTransform;
        self.stickWireLayer.frame = CGRectMake(1, 1, 1, 0);
        self.layer.opacity = 1.0;
        if (self.takeUpWireCompletion) {
            self.takeUpWireCompletion();
        }
    }else if ([anim isEqual:[self.layer animationForKey:throwWireAnimationKey]]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CATransaction begin];
            [CATransaction setAnimationDuration:Wire_Animation_Duration];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            self.biteLayer.hidden = NO;
            self.stickWireLayer.frame = CGRectMake(1, 1, 1, self.frame.size.width - Bite_Width/6.0);
            self.biteLayer.frame = CGRectMake(self.biteLayer.frame.origin.x, self.frame.size.width - Bite_Width/2.0, self.biteLayer.frame.size.width, self.biteLayer.frame.size.height);
            [CATransaction setCompletionBlock:^{
                [self.layer removeAllAnimations];
                self.layer.transform = CATransform3DRotate(self.initialTransform, -M_PI_2, 0, 0, 1);
                if (self.throwWireCompletion) {
                    self.throwWireCompletion([self getBitePoint]);
                }
            }];
            [CATransaction commit];
        });
    }
}

- (void)animationDidStart:(CAAnimation *)anim{
    if ([anim isEqual:[self.layer animationForKey:takeUpWireAnimationKey]]) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.biteLayer.frame = CGRectMake(self.biteLayer.frame.origin.x, 0, self.biteLayer.frame.size.width, self.biteLayer.frame.size.height);
        self.biteLayer.hidden = YES;
        self.stickWireLayer.frame = CGRectMake(1, 1, 1, 0);
        [CATransaction commit];
    }else if([anim isEqual:[self.layer animationForKey:throwWireAnimationKey]]){
         [[SoundManager sharedManager] playSound:@"CGL_fishrod.mp3"];
    }
}

#pragma mark - private
- (CGPoint)getBitePoint{
    CGRect rect = self.frame;
    return CGPointMake(rect.origin.x + (_direction == XJStickViewDirectionRight ? 0 : rect.size.width), rect.origin.y + rect.size.height + Bite_Width/2.0);
}

- (CALayer *)stickWireLayer{
    if (!_stickWireLayer) {
        _stickWireLayer = [CALayer layer];
        _stickWireLayer.backgroundColor = [UIColor hexStringToColor:@"#567e8f"].CGColor;
    }
    return _stickWireLayer;
}

- (CALayer *)stickLayer{
    if (!_stickLayer) {
        _stickLayer = [CALayer layer];
        _stickLayer.contents = (__bridge id _Nullable)(self.fishStickImage.CGImage);
    }
    return _stickLayer;
}

- (CALayer *)biteLayer{
    if (!_biteLayer) {
        _biteLayer = [CALayer layer];
        _biteLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"bait_sprite"].CGImage);
        _biteLayer.hidden = YES;
    }
    return _biteLayer;
}

@end
