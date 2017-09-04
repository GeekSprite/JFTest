//
//  XJScoreBoardView.h
//  DCGame
//
//  Created by GeekSprite on 2017/3/17.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import <UIKit/UIKit.h>


#define Score_Board_Top   (65.0 * (SCREEN_HEIGHT/736.0))  

@interface XJScoreBoardView : UIView

- (void)addScoreToLeft:(BOOL)isLeft;
- (void)animationForAppearWithCompletion:(dispatch_block_t)completion;
- (void)animationForDisappearWithCompletion:(dispatch_block_t)completion;

@end
