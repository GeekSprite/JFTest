//
//  XJPoolView.m
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import "XJPoolView.h"
#import "XJFishView.h"
#import "XJStickView.h"
#import "UIColor+hexstringToUIColor.h"
#import "XJFishItem.h"
#import "XJHappyFishManager.h"
#import <objc/runtime.h>

static char associatedClickedKey;

#define PoolUpper_Offset    100.0
#define poolBottom_Offset   (80.0 + 67 * SCREEN_WIDTH / 414.0)

@interface XJPoolView ()
{
    BOOL _apperaed;
}

@property(nonatomic, strong) NSMutableArray<XJFishView *> *poolFishs;
@property(nonatomic, strong) NSMutableArray<XJFishView *> *totalFishs;
@property(nonatomic, strong) NSMutableArray<XJFishView *> *rewardFishs;
@property(nonatomic, strong) NSMutableArray<XJFishView *> *sideRewardFishs;
@property(nonatomic, strong) NSMutableArray<XJFishItem *> *rewardItems;
@property(nonatomic, strong) NSArray<XJFishItem *> *initialFishs;
@property(nonatomic, strong) XJFishView *adFish;

@end

@implementation XJPoolView

#pragma mark - init
- (instancetype)initWithFishs:(NSArray<XJFishItem *> *)initialFishs{
    if (self = [super initWithFrame:CGRectZero]) {
        self.bitePoint = CGPointZero;
        self.sideBaitPoint = CGPointZero;
        self.poolState = XJPoolStateInitial;
        _apperaed = NO;
        self.initialFishs = initialFishs;
    }
    return self;
}

#pragma mark - config view
- (void)configView{
    [self addFishsToPool];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_apperaed) {
        _apperaed = YES;
        [self configView];
    }
}

#pragma mark - public

- (void)addAdFish{
    if (self.adFish || ![XJHappyFishManager sharedManager].isAdFishOn) {
        return ;
    }
    
   self.adFish = [[XJFishView alloc] initWithItem:[[XJFishItem alloc] initWithType:XJFishTypeADFish isStraw:NO isSide:NO]];
    objc_setAssociatedObject(self.adFish, &associatedClickedKey, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.adFish.layer.transform = CATransform3DTranslate(self.adFish.layer.transform, 0, 0, (self.adFish.frame.size.width + self.poolFishs.lastObject.layer.transform.m43) * -1.0);
    NSInteger randomDirection = arc4random_uniform(2);
    CGFloat delta = self.adFish.frame.size.width + arc4random_uniform(16) * SCREEN_WIDTH / 16.0;
    CGFloat startX = randomDirection == XJFishSwimDrectionLeft ?  delta + SCREEN_WIDTH : delta * -1.0 ;
    self.adFish.frame = CGRectMake(startX, arc4random_uniform(self.frame.size.height - PoolUpper_Offset - poolBottom_Offset * 1.5) + PoolUpper_Offset, self.adFish.frame.size.width, self.adFish.frame.size.height);

    [self addSubview:self.adFish];
    [self.adFish wanderingWithRange:delta + SCREEN_WIDTH/2.0 + arc4random_uniform(SCREEN_WIDTH/2.0 + delta) andDirection:randomDirection];


}

- (void)removeAdFish{
    XJFishView *temFish = self.adFish;
    self.adFish = nil;
    __weak typeof(temFish) weakTemFish = temFish;
    [temFish moveToDisappearWithMaxTime:0.4 :^{
        __strong typeof(weakTemFish) temFish = weakTemFish;
        [temFish removeFromSuperview];
        temFish = nil;
    }];
}


- (void)setRewardResult:(NSArray<XJFishItem *> *)rewardItem{
    [self.rewardItems removeAllObjects];
    [self.rewardItems addObjectsFromArray:rewardItem];
    for (XJFishItem *item  in self.rewardItems) {
        XJFishType type = item.type;
        for (int j = 0; j < self.poolFishs.count; j++) {
            XJFishView *fish = self.poolFishs[j];
            if (fish.item.type == type) {
                fish.item.isStraw = item.isStraw;
                fish.item.isSide = item.isSide;
                if (!item.isStraw) {
                    if (item.isSide) {
                        [self.sideRewardFishs addObject:fish];
                    }else{
                        [self.rewardFishs addObject:fish];
                    }
                }
                [self.totalFishs addObject:fish];
                [self.poolFishs removeObject:fish];
                break;
            }
        }
    }
    
}

- (void)setPoolState:(XJPoolState)poolState{
    if ((_poolState == XJPoolStateReadyForBite && poolState == XJPoolStateReceivedError) || (_poolState == XJPoolStateReceivedError && poolState == XJPoolStateReadyForBite)) {
        [self resetGameSence];
        if (self.delegate && [self.delegate respondsToSelector:@selector(gameRewardAnimationDidEndWithError:)]) {
            [self.delegate gameRewardAnimationDidEndWithError:YES];
        }
        return;
    }
    if ((poolState == XJPoolStateReceivedResult && _poolState == XJPoolStateReadyForBite) || (poolState == XJPoolStateReadyForBite && _poolState == XJPoolStateReceivedResult)) {
        _poolState = XJPoolStateReadyForReward;
        [self startRewardAnimation];
        return;
    }
    _poolState = poolState;
}

#pragma mark - priavte
- (void)addFishsToPool{
    for (XJFishItem *item in self.initialFishs) {
        [self addFishWithType:item andDelay:self.poolFishs.count/12.0];
    }
}

- (void)refillPool{
    for (int i = 0; i < self.totalFishs.count; i++) {
        XJFishView *fish = [self.totalFishs objectAtIndex:i];
        XJFishItem *item = [[XJFishItem alloc] initWithType:fish.item.type isStraw:NO isSide:NO];
        [self addFishWithType:item andDelay:i/12.0];
    }
}

- (void)startRewardAnimation{
    self.bitePoint = [self convertPoint:self.bitePoint fromView:self.superview];
    self.bitePoint = CGPointMake(self.bitePoint.x, self.bitePoint.y + self.rewardFishs.firstObject.frame.size.width /3.0);
    self.sideBaitPoint = [self convertPoint:self.sideBaitPoint fromView:self.superview];
    self.sideBaitPoint = CGPointMake(self.sideBaitPoint.x, self.sideBaitPoint.y + self.sideRewardFishs.firstObject.frame.size.width / 3.0);
    if (self.totalFishs.count == self.rewardItems.count) {
        [self performSelector:@selector(fishMoveToBait) withObject:nil afterDelay:0.1];
    }else{
        [self resetAfterGame];
    }
}

- (void)resetGameSence{
    for (XJFishView *dFish in self.totalFishs) {
        [dFish removeFromSuperview];
    }
    [self refillPool];
    [self.totalFishs removeAllObjects];
    [self.rewardFishs removeAllObjects];
    [self.sideRewardFishs removeAllObjects];
    [self.rewardItems removeAllObjects];
    self.bitePoint = CGPointZero;
    self.sideBaitPoint = CGPointZero;
    self.poolState = XJPoolStateInitial;
}

- (void)resetAfterGame{
    [self resetGameSence];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameRewardAnimationDidEndWithError:)]) {
        [self.delegate gameRewardAnimationDidEndWithError:NO];
    }
}

- (void)addFishWithType:(XJFishItem *)item andDelay:(CGFloat)delay{
    XJFishView *fish = [[XJFishView alloc] initWithItem:item];
    fish.layer.transform = CATransform3DTranslate(fish.layer.transform, 0, 0, (fish.frame.size.width + self.poolFishs.lastObject.layer.transform.m43) * -1.0);
    NSInteger randomDirection = arc4random_uniform(2);
    CGFloat delta = fish.frame.size.width + arc4random_uniform(16) * SCREEN_WIDTH / 16.0;
    CGFloat startX = randomDirection == XJFishSwimDrectionLeft ?  delta + SCREEN_WIDTH : delta * -1.0 ;
    fish.frame = CGRectMake(startX, arc4random_uniform(self.frame.size.height - PoolUpper_Offset - poolBottom_Offset) + PoolUpper_Offset, fish.frame.size.width, fish.frame.size.height);
    [self.poolFishs addObject:fish];
    [self addSubview:fish];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [fish wanderingWithRange:delta + SCREEN_WIDTH/2.0 + arc4random_uniform(SCREEN_WIDTH/2.0 + delta) andDirection:randomDirection];
    });
}

- (void)fishMoveToBait{
    if (self.rewardItems.count < 1) {
        [self resetGameSence];
        if (self.delegate && [self.delegate respondsToSelector:@selector(gameRewardAnimationDidEndWithError:)]) {
            [self.delegate gameRewardAnimationDidEndWithError:YES];
        }
        return ;
    }
    
    dispatch_block_t handler = ^(){
        if (self.rewardItems.count == 1) {
            [self animationForLastReward];
        }else if(self.rewardItems.count > 1){
            [self.rewardItems removeObjectAtIndex:0];
            [self performSelector:@selector(fishMoveToBait) withObject:nil afterDelay:0.0];
        }
    };
    
    NSInteger index = self.totalFishs.count - self.rewardItems.count;
    XJFishView *currentFish = self.totalFishs[index];
    __weak typeof(currentFish) weakFish = currentFish;
    CGPoint baitPoint = currentFish.item.isSide ? self.sideBaitPoint : self.bitePoint;
    [currentFish moveToCenter:baitPoint withCompletion:^{
        __strong typeof(weakFish) currentFish = weakFish;
        __weak typeof(currentFish) weakFish = currentFish;
        [currentFish showRewardStatusAnimation:^{
            __strong typeof(weakFish) currentFish = weakFish;
            __weak typeof(currentFish) weakFish = currentFish;
            if (currentFish.item.isStraw) {
                [currentFish moveToDisappear:^{
                    __strong typeof(weakFish) currentFish = weakFish;
                    [currentFish removeFromSuperview];
                }];
                handler();
            }else{
                [self bringSubviewToFront:currentFish];
                [currentFish moveToBait:baitPoint WithComplete:^{
                    __strong typeof(weakFish) currentFish = weakFish;
                    handler();
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didGetFish:)]) {
                        [self.delegate didGetFish:currentFish.item];
                    }
                    if (currentFish.item.isSide) {
                        if (![currentFish isEqual:self.sideRewardFishs.lastObject]) {
                            NSInteger rewardIndex = [self.sideRewardFishs indexOfObject:currentFish];
                            CGFloat biteY = self.sideBaitPoint.y + (self.sideRewardFishs[rewardIndex + 1].frame.size.width + self.sideRewardFishs[rewardIndex].frame.size.height)/3.0;
                            self.sideBaitPoint = CGPointMake(self.sideBaitPoint.x, biteY);
                        }
                    }else{
                        if (![currentFish isEqual:self.rewardFishs.lastObject]) {
                            NSInteger rewardIndex = [self.rewardFishs indexOfObject:currentFish];
                            CGFloat biteY = self.bitePoint.y + (self.rewardFishs[rewardIndex + 1].frame.size.width + self.rewardFishs[rewardIndex].frame.size.height)/3.0;
                            self.bitePoint = CGPointMake(self.bitePoint.x, biteY);
                        }
                    }
                }];
            }
        }];
    }];

}

- (void)animationForLastReward{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.rewardFishs.count == 0 && self.sideRewardFishs.count == 0) {
            [self resetAfterGame];
            NSLog(@"straw fish finished");
            return ;
        }
        //只有一边有鱼上钩的话，则此判定条件无效
        BOOL isFinished = self.sideRewardFishs.count == 0 || self.rewardFishs.count == 0;
        __block typeof(isFinished) bIsFinished = isFinished;
        for (XJFishView *fish in self.rewardFishs) {
            __weak typeof(fish) weakFish = fish;
            [fish removeAnimationAfterBait:[self convertPoint:self.bitePoint toView:nil] WithCompletion:^{
                __strong typeof(weakFish) fish = weakFish;
                if ([fish isEqual:self.rewardFishs.lastObject]) {
                    if (bIsFinished) {
                        [self resetGameSence];
                        NSLog(@"fish finished");
                    }
                    bIsFinished = YES;
                }
            }];
        }
        for (XJFishView *fish in self.sideRewardFishs) {
            __weak typeof(fish) weakFish = fish;
            [fish removeAnimationAfterBait:[self convertPoint:self.sideBaitPoint toView:nil] WithCompletion:^{
                __strong typeof(weakFish) fish = weakFish;
                if ([fish isEqual:self.sideRewardFishs.lastObject]) {
                    if (bIsFinished) {
                        [self resetGameSence];
                        NSLog(@"side fish finished");
                    }
                    bIsFinished = YES;
                }
            }];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(gameRewardAnimationDidEndWithError:)]) {
            [self.delegate gameRewardAnimationDidEndWithError:NO];
        }
    });
}

#pragma mark - override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BOOL choosed = NO;
    CGPoint point = [(UITouch*)[touches anyObject] locationInView:self];
    if (self.adFish) {
        CALayer *pLayer = self.adFish.layer.presentationLayer;
        if (CGRectContainsPoint(pLayer.frame, point)) {
            [self.adFish bubbleAnimation];
            //防止重复点击
            NSNumber *flag = objc_getAssociatedObject(self.adFish, &associatedClickedKey);
            if (flag.boolValue) {
                return;
            }
            objc_setAssociatedObject(self.adFish, &associatedClickedKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            choosed = YES;
        }
    }
    if ([self.delegate respondsToSelector:@selector(didTouchBeginWithChooseAdFish:)]) {
        [self.delegate didTouchBeginWithChooseAdFish:choosed];
    }
}

#pragma mark - getter
- (NSMutableArray<XJFishView *> *)poolFishs{
    if (!_poolFishs) {
        _poolFishs = [NSMutableArray array];
    }
    return _poolFishs;
}

- (NSMutableArray<XJFishItem *> *)rewardItems{
    if (!_rewardItems) {
        _rewardItems = [NSMutableArray array];
    }
    return _rewardItems;
}

- (NSMutableArray<XJFishView *> *)totalFishs{
    if (!_totalFishs) {
        _totalFishs = [NSMutableArray array];
    }
    return _totalFishs;
}

- (NSMutableArray<XJFishView *> *)rewardFishs{
    if (!_rewardFishs) {
        _rewardFishs = [NSMutableArray array];
    }
    return _rewardFishs;
}

- (NSMutableArray<XJFishView *> *)sideRewardFishs{
    if (!_sideRewardFishs) {
        _sideRewardFishs = [NSMutableArray array];
    }
    return _sideRewardFishs;
}

- (NSArray<XJFishItem *> *)initialFishs{
    if (!_initialFishs) {
        _initialFishs = [NSArray array];
    }
    return _initialFishs;
}
@end
