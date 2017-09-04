//
//  XJFishView.m
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import "XJFishView.h"
#import "SoundManager+BackgroundMusic.h"

#define Fish_Small_Height       20.0
#define Fish_Small_Width        40.0
#define WanderBasicSpeed        80.0
#define Pause_Duration          0.8
#define Transform_duration      0.25
#define Middle_Range            (SCREEN_WIDTH/20.0)
#define DecorationView_Width    30.0
#define FRAMES_OF_IMAGE          (6)

@interface XJFishView ()<CAAnimationDelegate>
{
    CGFloat _startX ;
    CGFloat _showX;
    CGFloat _wanderSpeed;
}
@property(nonatomic, strong) UIImageView *fishBody;
@property(nonatomic, strong) NSArray *bodyImages;
@property(nonatomic, assign) CATransform3D beginTransform;
@property(nonatomic, strong) UIImageView *decorationView;
@property(nonatomic, strong) CAEmitterLayer *explosionLayer;
@property(nonatomic, copy)   dispatch_block_t centerCompletion;
@property(nonatomic, copy)   dispatch_block_t showStatusCompletion;
@property(nonatomic, copy)   dispatch_block_t baitCompletion;
@property(nonatomic, copy)   dispatch_block_t disAppearCompletion;
@property(nonatomic, copy)   dispatch_block_t removeAfterBaitCompletion;
@property(nonatomic) BOOL                     animationFlag;
@property(nonatomic) CGPoint                  animationPoint;

@end

static NSString *wanderingAniKey = @"wanderingAniKey";
static NSString *baitAniKey = @"baitAniKey";
static NSString *centerAniKey = @"centerAniKey";
static NSString *showStatusAniKey = @"showStatusAniKey";
static NSString *disAppearAniKey = @"disAppearAniKey";
static NSString *removeAfterBaitKey = @"removeAfterBaitKey";

@implementation XJFishView

#pragma mark - init

- (instancetype)initWithItem:(XJFishItem *)item{
    if (self = [super initWithFrame:CGRectZero]) {
        _item = item;
        [self configView];
        if (item.type == XJFishTypeADFish) {
            self.animationFlag = YES;
        }
        self.beginTransform = self.layer.transform;
    }
    return self;
}

#pragma mark - configViews

- (void)configView{
    CGFloat height = ((UIImage *)self.bodyImages.firstObject).size.height;
    CGFloat width = ((UIImage *)self.bodyImages.firstObject).size.width;
    CGFloat ratio = 1.0;
    if (self.item.type == XJFishTypeSideFish) {
        ratio = 0.6;
    }else if(self.item.type == XJFishTypeADFish){
        ratio = 0.4;
    }
    
    height *= (ScreenHeightRatio * ratio);
    width *= (ScreenWidthRatio * ratio);
    self.frame = CGRectMake(0, 0, width, height);
    self.fishBody.animationImages = self.bodyImages;
    self.fishBody.animationDuration = self.item.type == XJFishTypeSideFish ? 1.8 : 1.0;
    self.fishBody.animationRepeatCount = 0;
    [self.fishBody startAnimating];
    self.fishBody.frame = self.bounds;
    [self addSubview:self.fishBody];
    [self addSubview:self.decorationView];
    self.decorationView.frame = CGRectMake(-DecorationView_Width/2.0, 0, DecorationView_Width, DecorationView_Width);
    self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    self.animationPoint = self.center;
}

#pragma mark - public
- (void)wanderingWithRange:(CGFloat)width andDirection:(XJFishSwimDrection)direction{
    if (self.item.type == XJFishTypeADFish) {
        [self waterdropAnimation];
    }
    CGFloat endX ;
    CGFloat middleX1 ;
    CGFloat middleX2 ;
    _wanderSpeed = WanderBasicSpeed + (arc4random() % 8) * 10.0;
    if (self.item.type == XJFishTypeADFish) {
        width = SCREEN_WIDTH + self.frame.size.width;
        if (direction == XJFishSwimDrectionLeft) {
            self.frame = CGRectMake(SCREEN_WIDTH, self.frame.origin.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }else{
           self.frame = CGRectMake(-CGRectGetWidth(self.frame), self.frame.origin.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
        _wanderSpeed *= 0.3;
    }
    CGFloat midRange = Middle_Range * (_wanderSpeed / WanderBasicSpeed);
    if (direction == XJFishSwimDrectionLeft) {
        self.layer.transform = CATransform3DRotate(self.layer.transform, M_PI, 0, 1, 0);
         _startX = self.center.x;
         endX = _startX - width;
         middleX1 = _startX - width/2.0 + midRange;
         middleX2 = _startX - width/2.0 - midRange;
    }else{
         _startX = self.center.x;
         endX = _startX + width;
         middleX1 = _startX + width/2.0 - midRange;
         middleX2 = _startX + width/2.0 + midRange;
    }
    CFTimeInterval duration = 0;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    
    CAKeyframeAnimation *ani1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani1.path = [self pathWithStartX:_startX andEndPoint:middleX1].CGPath;
    ani1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CFTimeInterval duration1 = fabs(middleX1 - _startX) / _wanderSpeed;
    duration += duration1;
    ani1.duration = duration1;
    ani1.removedOnCompletion = NO;
    ani1.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *aniP1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    aniP1.path = [self pathWithStartX:middleX1 andEndPoint:middleX2].CGPath;
    aniP1.beginTime = duration;
    aniP1.duration = Pause_Duration;
    aniP1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    aniP1.fillMode = kCAFillModeForwards;
    aniP1.removedOnCompletion = NO;
    duration += Pause_Duration;
    
    CAKeyframeAnimation *ani2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani2.path = [self pathWithStartX:middleX2 andEndPoint:endX].CGPath;
    ani2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    ani2.beginTime = duration;
    CFTimeInterval duration2 = fabs(middleX2 - endX) / _wanderSpeed;
    duration += duration2;
    ani2.duration = duration2;
    ani2.removedOnCompletion = NO;
    ani2.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *ani3 = [CABasicAnimation animationWithKeyPath:@"transform"];
    ani3.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
    ani3.toValue =[NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, M_PI, 0, 1, 0)];
    ani3.beginTime = duration;
    CFTimeInterval duration3 = Transform_duration;
    duration += duration3;
    ani3.duration = duration3;
    ani3.removedOnCompletion = NO;
    ani3.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *ani4 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani4.path = [self pathWithStartX:endX andEndPoint:middleX2].CGPath;
    ani4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    ani4.beginTime = duration;
    CFTimeInterval duration4 = fabs(middleX2 - endX) / _wanderSpeed;
    duration += duration4;
    ani4.duration = duration4;
    ani4.removedOnCompletion = NO;
    ani4.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *aniP2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    aniP2.beginTime = duration;
    aniP2.path = [self pathWithStartX:middleX2 andEndPoint:middleX1].CGPath;
    aniP2.duration = Pause_Duration;
    aniP2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    aniP2.fillMode = kCAFillModeForwards;
    aniP2.removedOnCompletion = NO;
    duration += Pause_Duration;
    
    CAKeyframeAnimation *ani5 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani5.path = [self pathWithStartX:middleX1 andEndPoint:_startX].CGPath;
    ani5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    ani5.beginTime = duration;
    CFTimeInterval duration5 = fabs(middleX1- endX) / _wanderSpeed;
    duration += duration5;
    ani5.duration = duration5;
    ani5.removedOnCompletion = NO;
    ani5.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *ani6 = [CABasicAnimation animationWithKeyPath:@"transform"];
    ani6.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
    ani6.toValue =[NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, M_PI, 0, 1, 0)];
    ani6.beginTime = duration;
    CFTimeInterval duration6 = Transform_duration;
    duration += duration6;
    ani6.duration = duration6;
    ani6.removedOnCompletion = NO;
    ani6.fillMode = kCAFillModeForwards;
    
    
    group.animations = @[ani1,aniP1,ani2,ani3,ani3,ani4,aniP2,ani5,ani6];
    group.repeatCount = MAXFLOAT;
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [self.layer addAnimation:group forKey:wanderingAniKey];
}

- (void)moveToBait:(CGPoint)position WithComplete:(nullable dispatch_block_t)completion{
    self.baitCompletion = completion;
    CGFloat duration = 0.25;
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *ani1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    ani1.duration = duration;
    ani1.removedOnCompletion = NO;
    ani1.fillMode = kCAFillModeForwards;
    ani1.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, M_PI_2, 0, 0, 1)];
    ani1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *ani2 = [CABasicAnimation animationWithKeyPath:@"position"];
    ani2.duration = duration;
    ani2.removedOnCompletion = NO;
    ani2.fillMode = kCAFillModeForwards;
    ani2.toValue = [NSValue valueWithCGPoint:position];
    ani2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    group.animations = @[ani1,ani2];
    group.delegate = self;
    [self.layer addAnimation:group forKey:baitAniKey];
}

- (void)removeAnimationAfterBait:(CGPoint)baitPoint WithCompletion:(nullable dispatch_block_t)completion{
    self.removeAfterBaitCompletion = completion;
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"position.y"];
    ani.duration = 0.32;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.byValue = @(-baitPoint.y - 100);
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    ani.delegate = self;
    [self.layer addAnimation:ani forKey:removeAfterBaitKey];
}

- (void)moveToDisappear:(dispatch_block_t)completion{
    [self moveToDisappearWithMaxTime:1.5 :completion];
}

- (void)moveToDisappearWithMaxTime:(NSTimeInterval)duration :(dispatch_block_t)completion{
    if (arc4random() % 2 == 0) {
        self.layer.transform = CATransform3DRotate(self.layer.transform, M_PI, 0, 1, 0);
    }
    CGFloat endX = self.layer.transform.m11 == 1 ? - self.frame.size.width/2.0 : SCREEN_WIDTH + self.frame.size.width/2.0;
    
    self.disAppearCompletion = completion;
    duration = MIN(duration, fabs(_showX - endX)/(_wanderSpeed * 1.2));
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"position"];
    ani.duration = duration;
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(endX, self.layer.position.y)];
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ani.delegate = self;
    
    [self.layer addAnimation:ani forKey:disAppearAniKey];
}

- (void)moveToCenter:(CGPoint)position withCompletion:(nullable dispatch_block_t)completion{
    CGFloat endX;
    CGPoint center;
    if (self.layer.presentationLayer) {
        center = self.layer.presentationLayer.position;
    }
    //Move to Right side
    if (self.layer.presentationLayer.position.x > position.x) {
        self.layer.transform = CATransform3DRotate(self.beginTransform, -M_PI, 0, 1, 0);
        endX = position.x + arc4random_uniform(SCREEN_WIDTH - self.frame.size.width/2.0 - position.x);
        if (center.x < endX) {
            endX = center.x ;
        }
    }else{
        self.layer.transform = self.beginTransform;
        endX = self.frame.size.width/2.0 + arc4random_uniform(position.x - self.frame.size.width/2.0) ;
        if (center.x > endX) {
            endX = center.x ;
        }
    }
    _showX = endX;
    [self.layer removeAllAnimations];
    self.layer.position = center;
    
    self.centerCompletion = completion;
    CGFloat duration = MIN(1.5, fabs(endX - center.x)/(_wanderSpeed * 1.2));
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"position"];
    ani.duration = duration;
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(endX, self.center.y)];
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.delegate = self;
    
    [self.layer addAnimation:ani forKey:centerAniKey];
}

- (void)showRewardStatusAnimation:(dispatch_block_t)completion{
    UIImage *rewardStatusImg;
    if(self.item.isStraw){
        rewardStatusImg = [UIImage imageNamed:@"tangled"];
    }else{
        rewardStatusImg = [UIImage imageNamed:@"like"];
    }
    [self.decorationView setImage:rewardStatusImg];
    self.decorationView.hidden = NO;
    
    self.showStatusCompletion = completion;
    CGFloat duration = 0.25;
    CABasicAnimation *ani1 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    ani1.duration = duration;
    ani1.fromValue = @(0.0);
    ani1.toValue = @(-DecorationView_Width/2.0);
    ani1.removedOnCompletion = NO;
    ani1.fillMode = kCAFillModeForwards;
    ani1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    ani1.delegate = self;
    
    [self.decorationView.layer addAnimation:ani1 forKey:showStatusAniKey];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([anim isEqual:[self.layer animationForKey:centerAniKey]]) {
        if (self.centerCompletion) {
            self.centerCompletion();
        }
    }else if ([anim isEqual:[self.decorationView.layer animationForKey:showStatusAniKey]]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.decorationView.hidden = YES;
            if (self.showStatusCompletion) {
                self.showStatusCompletion();
            }
        });
    }else if([anim isEqual:[self.layer animationForKey:baitAniKey]]){
        self.layer.position = self.layer.presentationLayer.position;
        [self bubbleAnimation];
        if (self.baitCompletion) {
            self.baitCompletion();
        }
    }else if([anim isEqual:[self.layer animationForKey:disAppearAniKey]]){
        if (self.disAppearCompletion) {
            self.disAppearCompletion();
        }
    }else if ([anim isEqual:[self.layer animationForKey:removeAfterBaitKey]]){
        self.hidden = YES;
        if (self.removeAfterBaitCompletion) {
            self.removeAfterBaitCompletion();
        }
    }
}

#pragma mark - override

- (void)removeFromSuperview{
    self.animationFlag = NO;
    [self.layer removeAllAnimations];
    [self.decorationView.layer removeAllAnimations];
    [super removeFromSuperview];
}

#pragma mark - animation

- (void)bubbleAnimation{
    if (![self.layer.sublayers containsObject:self.explosionLayer]) {
        [self.layer insertSublayer:self.explosionLayer above:self.fishBody.layer];
    }
    [[SoundManager sharedManager] playSound:@"fish_bait.mp3"];
    [self.explosionLayer setValue:@20 forKeyPath:@"emitterCells.explosion.birthRate"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
    });
}

- (void)waterdropAnimation {
    
    if (self.animationFlag) {
        UIView *waterDropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        waterDropView.layer.cornerRadius = self.frame.size.width / 2.0;
        waterDropView.center = [self animationPoint];
        waterDropView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [self insertSubview:waterDropView atIndex:0];
        
        [UIView animateWithDuration:1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            waterDropView.transform = CGAffineTransformMakeScale(2.5, 2.5);
            waterDropView.alpha = 0;
        } completion:^(BOOL finished) {
            [waterDropView removeFromSuperview];
        }];
        
        [self performSelector:@selector(waterdropAnimation) withObject:nil afterDelay:1.5];
    }
}

#pragma mark - getter & setter

- (UIImageView *)fishBody{
    if (!_fishBody) {
        _fishBody = [[UIImageView alloc] init];
    }
    return _fishBody;
}

- (UIImageView *)decorationView{
    if (!_decorationView) {
        _decorationView = [[UIImageView alloc] init];
    }
    return _decorationView;
}

- (UIBezierPath *)pathWithStartX:(CGFloat)x1  andEndPoint:(CGFloat)x2{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x1, self.center.y)];
    [path addLineToPoint:CGPointMake(x2, self.center.y)];
    return path;
}

- (NSArray *)bodyImages{
    if (!_bodyImages) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < FRAMES_OF_IMAGE; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"fish_%lu_%d",self.item.type+1,i+1]];
            if (img) {
                [arr addObject:img];
            }
        }
        [arr addObjectsFromArray:[[arr mutableCopy] reverseObjectEnumerator].allObjects];
        _bodyImages = [NSArray arrayWithArray:arr];
    }
    return _bodyImages;
}

- (CAEmitterLayer *)explosionLayer{
    if (!_explosionLayer) {
        CAEmitterCell *explosionCell = [CAEmitterCell emitterCell];
        explosionCell.name           = @"explosion";
        explosionCell.alphaRange     = 0.10;
        explosionCell.alphaSpeed     = -2.0;
        explosionCell.lifetime       = 0.3;
        explosionCell.lifetimeRange  = 0.2;
        explosionCell.velocity       = 60.0;
        explosionCell.velocityRange  = 40.0;
        explosionCell.scale          = 0.15;
        explosionCell.scaleRange     = 0.1;
        explosionCell.contents       = (id)[UIImage imageNamed:@"fishbet_water_bubble"].CGImage;
        
        _explosionLayer               = [CAEmitterLayer layer];
        _explosionLayer.name          = @"emitterLayer";
        _explosionLayer.emitterShape  = kCAEmitterLayerSphere;
        _explosionLayer.emitterMode   = kCAEmitterLayerSurface;
        _explosionLayer.emitterCells  = @[explosionCell];
        _explosionLayer.renderMode    = kCAEmitterLayerOldestFirst;
        _explosionLayer.masksToBounds = NO;
        _explosionLayer.position      = CGPointMake(self.layer.frame.size.width/2.0, self.layer.frame.size.height/2.0);
        _explosionLayer.emitterSize   = self.fishBody.bounds.size;
    }
    return _explosionLayer;
}

@end
