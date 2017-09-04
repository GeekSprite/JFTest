//
//  XJFishBottomBar.h
//  DCGame
//
//  Created by GeekSprite on 2017/3/15.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XJFishBottomBarDelegate <NSObject>

- (void)didClickStart;
- (void)didClickBetSelect;

@end

@interface XJFishBottomBar : UIView

@property(nonatomic, weak) id<XJFishBottomBarDelegate> delegate;
@property(nonatomic, strong) UIButton *startButton;
@property(nonatomic, strong) UIButton *betSelectButton;
@property(nonatomic, strong) UIImageView *betLeverView;

@end
