//
//  XJFishView.h
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJFishItem.h"

typedef enum : NSUInteger {
    XJFishSwimDrectionLeft = 0,
    XJFishSwimDrectionRight,
} XJFishSwimDrection;

@interface XJFishView : UIView

@property(nonatomic, strong, readonly, nonnull) XJFishItem *item;

- (nonnull instancetype)initWithItem:(nonnull XJFishItem *)item;

/**
 下面六种方法为鱼的运动方式，
 如果鱼会上钩，则依次执行  闲游-> 移动到屏幕中 -> 显示中奖❤️状态 -> 咬勾 -> 中奖后移出屏幕
 如果鱼会上钩，则依次执行  闲游-> 移动到屏幕中 -> 显示不中奖状态 -> 不中奖移出屏幕
 */
- (void)bubbleAnimation;
- (void)wanderingWithRange:(CGFloat)width andDirection:(XJFishSwimDrection)direction; //闲游
- (void)moveToCenter:(CGPoint)position withCompletion:(nullable dispatch_block_t)completion;//移动到屏幕中
- (void)moveToBait:(CGPoint)position WithComplete:(nullable dispatch_block_t)completion;//咬勾
- (void)moveToDisappear:(nullable dispatch_block_t)completion;//不中奖移出屏幕
- (void)moveToDisappearWithMaxTime:(NSTimeInterval)duration :(dispatch_block_t _Nullable )completion;
- (void)showRewardStatusAnimation:(nullable dispatch_block_t)completion;//显示是否获奖状态
- (void)removeAnimationAfterBait:(CGPoint)baitPoint WithCompletion:(nullable dispatch_block_t)completion;//中奖移出屏幕
@end
