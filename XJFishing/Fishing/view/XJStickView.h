//
//  XJStickView.h
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Stick_Height_Ratio          (46.0 / 215.0)
#define Bite_Width                  28.0
#define Stick_Animation_Duration    0.22
#define Wire_Animation_Duration     0.22
#define Take_Up_Animation_Duration  0.28

typedef enum : NSUInteger {
    XJStickViewDirectionLeft,
    XJStickViewDirectionRight,
} XJStickViewDirection;

typedef void(^ThrowWireCompetion)(CGPoint bait);
@interface XJStickView : UIView

@property(nonatomic, assign) BOOL isReady;
@property(nonatomic, strong) UIImage *fishStickImage;

- (instancetype)initWithDirection:(XJStickViewDirection)direction;
- (void)throwWireAnimationWithCompletion:(ThrowWireCompetion)completion;
- (void)takeUpWireAnimationWithCompletion:(void (^)(void))completion;

@end
