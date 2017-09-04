//
//  XJCountDownView.h
//  DCGame
//
//  Created by GeekSprite on 2017/3/20.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJCountDownView : UIView

- (void)startCountDown:(NSInteger)countTime WithCompletion:(dispatch_block_t)completion;

@end
