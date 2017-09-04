//
//  XJFishBetConsoleView.h
//  DCGame
//
//  Created by GeekSprite on 2017/3/17.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Fish_Screen_Height_Ratio    (SCREEN_HEIGHT/736.0)
#define Fish_Screen_Width_Ratio     (SCREEN_WIDTH/414.0)

@protocol  XJFishBetConsoleViewDelegate <NSObject>

- (void)didStartWithLeverage:(NSInteger)leverage didChooseRightSide:(BOOL)isRight;
- (void)didClickCancel;

@end
@interface XJFishBetConsoleView : UIView

@property(nonatomic, weak)id<XJFishBetConsoleViewDelegate> delegate;
- (void)resetConsole;
- (void)refreshContentWhenChooseRightSide:(BOOL)right;
@end
