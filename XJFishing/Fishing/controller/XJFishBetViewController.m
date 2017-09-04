//
//  XJFishBetViewController.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/16.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XJFishBetViewController.h"
#import "XJPoolView.h"
#import "XJHappyFishManager.h"
#import "SoundManager+BackgroundMusic.h"
#import "XJStickView.h"
#import "UIView+Toast.h"
#import "Masonry.h"
#import "CoinCountView.h"
#import "KYWaterWaveView.h"
#import "XJCountDownView.h"
#import "XJFishBetConsoleView.h"
#import "XJScoreBoardView.h"
#import "XJFishCharacterView.h"
#import "CCommon.h"
#import "GameEnum.h"


#define Wave_Offset                 (16.0 * Fish_Screen_Height_Ratio)
#define REWARD_ANIMATION_DURATION               1.5
#define EMPTY_REWARD_ANIMATION_DURATION         0.75
#define INITIAL_COIN_COUNT                      2000
@interface XJFishBetViewController ()<XJPoolViewDelegate, XJFishBetConsoleViewDelegate, XJFishCharacterViewDelegate>

@property(nonatomic, strong) KYWaterWaveView *frontWave;
@property(nonatomic, strong) KYWaterWaveView *backWave;
@property(nonatomic, strong) XJStickView *leftFishStick;
@property(nonatomic, strong) XJStickView *rightFishStick;
@property(nonatomic, strong) UIImageView *backgroundView;
@property(nonatomic, strong) CoinCountView *coinCountView;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) XJPoolView *pool;
@property(nonatomic, strong) XJCountDownView *countDownView;
@property(nonatomic, strong) XJFishBetConsoleView *consoleView;
@property(nonatomic, strong) XJScoreBoardView *scoreBoardView;
@property(nonatomic, strong) XJFishCharacterView *characterView;
@property(nonatomic, strong) NSError *lastError;
@property(nonatomic)         BOOL isRightWin;
@property(nonatomic)         NSInteger rewardCount;
@property(nonatomic)         BOOL isOnAd;
@property(nonatomic)         GameStatus gameStatus;

@end

@implementation XJFishBetViewController

#pragma mark - lifeCircle

- (void)dealloc {
    debugMethod();
    [self.backWave stop];
    [self.frontWave stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetGameStat];
    self.gameStatus = GameStatus_Start;
    self.isOnAd = NO;
    self.view.clipsToBounds = YES;
    [self configView];
    [self.backWave wave];
    [self.frontWave wave];
//    [[HJGameRulesManager sharedManager] showGameRulesViewWithGameType:GameType_HappyFishDouble betCoins:0 result:^(BOOL canStartGame) {
//        
//    }];
//    [LWGameDataController sharedInstance].delegate = self;
//    if ([ZFRewardVideoManager sharedInstance].status == ZFRewardVideoStatusReady) {
//        [ZFRewardVideoManager sharedInstance].delegate = self;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (([ZFRewardVideoManager sharedInstance].status == ZFRewardVideoStatusReady) && [XJHappyFishManager sharedManager].isAdFishOn) {
//    }
    [self.pool addAdFish];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark - configView
- (void)configView{
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    CGFloat backY = SCREEN_HEIGHT * 0.40;
    CGFloat backHeight = SCREEN_HEIGHT - backY;
    
    [self.view addSubview:self.backWave];
    [self.view addSubview:self.frontWave];
    [self.backWave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(backY + Wave_Offset);
    }];
    [self.frontWave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(backY + Wave_Offset * 2.0);
    }];
    
    CGFloat stickWidth = (SCREEN_WIDTH * 0.35)/(1-Stick_Height_Ratio);
    CGFloat stickHeight = 120 * Fish_Screen_Height_Ratio ;
    CGFloat stickY = backY - stickHeight * 1.5 + Wave_Offset * 4.0;
    self.rightFishStick.frame = CGRectMake(SCREEN_WIDTH * 0.65 + stickWidth*0.5 , stickY, stickWidth, stickHeight);
    [self.view addSubview:self.rightFishStick];
    
    self.leftFishStick.frame = CGRectMake(- stickWidth * (Stick_Height_Ratio + 0.5) , stickY, stickWidth, stickHeight);
    [self.view addSubview:self.leftFishStick];
    
    [self.view addSubview:self.pool];
    [self.pool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.bottom.equalTo(self.view);
        make.height.mas_equalTo(backHeight);
    }];
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
        make.top.equalTo(self.view).offset(8 * ScreenHeightRatio);
        make.left.equalTo(self.view).offset(10 * ScreenWidthRatio);
    }];
    
    [self.view addSubview:self.coinCountView];
    [self.coinCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10.0 * ScreenWidthRatio);
        make.bottom.equalTo(self.backButton);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.countDownView];
    [self.countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(120 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(80 * Fish_Screen_Width_Ratio);
        make.height.mas_equalTo(110 * Fish_Screen_Height_Ratio);
    }];
    
    [self.view addSubview:self.consoleView];
    [self.consoleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(181 * Fish_Screen_Width_Ratio);
        make.height.mas_equalTo(128 * Fish_Screen_Height_Ratio);
        make.bottom.equalTo(self.view).offset(-60 * Fish_Screen_Height_Ratio);
    }];
    
    [self.view addSubview:self.scoreBoardView];
    [self.scoreBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(51 * Fish_Screen_Height_Ratio);
        make.width.mas_equalTo(401 * Fish_Screen_Width_Ratio);
        make.top.equalTo(self.view).offset(Score_Board_Top);
    }];
    [self.view addSubview:self.characterView];
    [self.characterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.view);
        make.height.mas_equalTo(198 * Fish_Screen_Height_Ratio);
        make.top.equalTo(self.view).offset(Fish_Screen_Height_Ratio * 98);
    }];
    
}

#pragma mark - ZFRewardVideoManagerDelegate
//
//- (void)videoDidUpdateStatus:(ZFRewardVideoStatus)status{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (status == ZFRewardVideoStatusReady) {
//            [self.pool addAdFish];
//        }
//    });
//}
//
//- (void)videoDidFinishedWithPlatform:(ZFRewardVideoType)platform{
//        self.isOnAd = NO;
//        if ([[SoundManager sharedManager] shouldPlayBackgroundMusic]) {
//            [[SoundManager sharedManager] playMusic:@"background_music.mp3"];
//        }
//        if (self.gameStatus == GameStatus_End) {
//            NSTimeInterval duration = (self.rewardCount == 0 || self.lastError) ? EMPTY_REWARD_ANIMATION_DURATION : REWARD_ANIMATION_DURATION;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self showRewardAnimation];
//            });
//        }
//    [HJGameWatchVideoConditions didWatchVideoWithGameType:GameType_HappyFishDouble];
//}
//
//- (void)videoWillStartPlayingWithPlatform:(ZFRewardVideoType)platform{
//    [GiftEventLogHelper logWatchVideo:DVALUE_GAME_BATTLEFISH platform:platform];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [CCommon getAppDelegateWindow].userInteractionEnabled = YES;
//        [[CCommon getAppDelegateWindow] hideToastActivity];
//    });
//    
//    if ([[SoundManager sharedManager] shouldPlayBackgroundMusic]) {
//        [[SoundManager sharedManager] stopMusic];
//    }
//}

#pragma mark - LWGameControllerDelegate
//- (void)battleFishGameDidUpdate:(LWGameModel *)gameModel{
//    if ([self.presentedViewController isKindOfClass:[DPAlertViewController class]]) {
//        DPAlertViewController *alertVC = (DPAlertViewController *)self.presentedViewController;
//        [alertVC updateCountDown:gameModel.coolDownTime];
//    }
//}

#pragma mark - DPAlertViewControllerDelegate
//- (void)videoButtonDidClick:(id)sender {
//    [self playVideo];
//}

#pragma mark - XJPoolViewDelegate
- (void)didTouchBeginWithChooseAdFish:(BOOL)choose{
    if (!choose) {
        return;
    }
    [self.pool removeAdFish];
//    if ([ZFRewardVideoManager sharedInstance].status == ZFRewardVideoStatusReady) {
//        self.isOnAd = YES;
//        [GiftEventLogHelper logNewGameOpen:@"ok"];
//        
//        [CCommon getAppDelegateWindow].userInteractionEnabled = NO;
//        [[CCommon getAppDelegateWindow] makeToastActivity:CSToastPositionCenter];
//        [[ZFRewardVideoManager sharedInstance] playWithPreferredPlatform:ZFRewardVideoTypeApplovin];
//        
//        if ([[SoundManager sharedManager] shouldPlayBackgroundMusic]) {
//            [[SoundManager sharedManager] stopMusic];
//        }
//    } else {
//        [GiftEventLogHelper logNewGameOpen:@"no_ad"];
//    }
}

- (void)didGetFish:(XJFishItem *)fish{
    [self.scoreBoardView addScoreToLeft:fish.isSide];
}

- (void)gameRewardAnimationDidEndWithError:(BOOL)isError{
    [self.leftFishStick takeUpWireAnimationWithCompletion:nil];
    
    WEAK_SELF;
    [self.rightFishStick takeUpWireAnimationWithCompletion:^{
        STRONG_SELF;
        if (!isError) {
            [self.characterView animationForRewardIsRightWin:self.isRightWin];
        }

        self.gameStatus = GameStatus_End;
        if (!self.isOnAd) {
            NSTimeInterval duration = (self.rewardCount == 0 || self.lastError) ? EMPTY_REWARD_ANIMATION_DURATION : REWARD_ANIMATION_DURATION;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showRewardAnimation];
            });
        }
    }];
}

#pragma mark - XJFishBetConsoleViewDelegate
- (void)didStartWithLeverage:(NSInteger)leverage didChooseRightSide:(BOOL)isRight{
    [self setGameReadyToStart:NO];
    
    //watch video
//    if ([self timeToWatchVideo]) {
//        DPAlertViewController *alertVC = [[DPAlertViewController alloc] init];
//        alertVC.delegate = self;
//        alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        [alertVC updateCountDown:[[LWGameDataController sharedInstance] gameModelForGameType:LWGameTypeBattleFish].coolDownTime];
//        [self presentViewController:alertVC animated:NO completion:nil];
//        [self setGameReadyToStart:YES];
//        [GiftEventLogHelper logShowVideoAlert:DVALUE_GAME_BATTLEFISH];
//        return;
//    }
//    
//    //not enough coins
//    if (![[XJHappyFishManager sharedManager] fishbetCanPlayWithLeverage:leverage]) {
//        [[ZFJiangjinManager sharedInstance] showNotEnoughCoinsAlert];
//        [self setGameReadyToStart:YES];
//        return ;
//    }
    
    [self.characterView animationForGameStart];
    [[XJHappyFishManager sharedManager] fishbetPlayGamedidChooseRightSide:isRight
                                                             withLeverage:leverage
                                                           WithCompletion:^(NSInteger rewardCount, NSArray<XJFishItem *> *bait_list, NSError *error) {
           self.rewardCount = rewardCount;
           self.isRightWin = rewardCount > 0 ? isRight : !isRight;
        if (error) {
            self.pool.poolState = XJPoolStateReceivedError;
            self.lastError = error;
        }else{
            [self.pool setRewardResult:bait_list];
            self.pool.poolState = XJPoolStateReceivedResult;
        };
    }];
   
    WEAK_SELF;
    [self.countDownView startCountDown:3 WithCompletion:^{
        STRONG_SELF;
        [self.scoreBoardView animationForAppearWithCompletion:nil];
        WEAK_SELF;
        [self.leftFishStick throwWireAnimationWithCompletion:^(CGPoint bait) {
            STRONG_SELF;
            [self.pool setSideBaitPoint:bait];
            if (!CGPointEqualToPoint(CGPointZero, self.pool.bitePoint)) {
                self.pool.poolState = XJPoolStateReadyForBite;
            }
        }];
        
        [self.rightFishStick throwWireAnimationWithCompletion:^(CGPoint bait) {
            STRONG_SELF;
            self.gameStatus = GameStatus_Underway;
            [self.pool setBitePoint:bait];
            if (!CGPointEqualToPoint(CGPointZero, self.pool.sideBaitPoint)) {
                self.pool.poolState = XJPoolStateReadyForBite;
            }
        }];
    }];
    
    NSInteger coinsNeeded = leverage * [XJHappyFishManager sharedManager].fishbetBasicCoinCost;
    [self.coinCountView playAnimationWithDeductCoinCount:coinsNeeded];
    [self.coinCountView setCoinCount:INITIAL_COIN_COUNT - coinsNeeded];
}

- (void)didClickCancel{
    [self.characterView resetScence];
}

#pragma mark - XJFishCharacterViewDelegate
- (void)didTapPlayerOnRightSide:(BOOL)isRight{
    [self.consoleView refreshContentWhenChooseRightSide:isRight];
}

#pragma mark - action
- (void)goBack:(UIButton *)button {
    [[SoundManager sharedManager] playSound:@"HOME_Btn_tap.mp3"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - priavte
//- (void)playVideo {
//    [ZFRewardVideoManager sharedInstance].delegate = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [CCommon getAppDelegateWindow].userInteractionEnabled = NO;
//        [[CCommon getAppDelegateWindow] makeToastActivity:CSToastPositionCenter];
//        [[ZFRewardVideoManager sharedInstance] play];
//    });
//}

- (void)setGameReadyToStart:(BOOL)flag{
    self.navigationController.interactivePopGestureRecognizer.enabled = flag;
    self.pool.clipsToBounds = flag;
    self.backButton.enabled = flag;
    if (flag) {
        [self.characterView resetScence];
        [self.consoleView resetConsole];
        [self resetGameStat];
        self.gameStatus = GameStatus_Start;
        self.isOnAd = NO;
    }
}

- (void)resetGameStat{
    self.rewardCount = 0;
    self.isRightWin = YES;
    self.lastError = nil;
}

//- (BOOL)timeToWatchVideo {
//    BOOL shoudlWatchVideo =  [HJGameWatchVideoConditions shouldWatchVideoWithGameType:GameType_HappyFishDouble];
//    BOOL videoReady = [ZFRewardVideoManager sharedInstance].status == ZFRewardVideoStatusReady;
//    BOOL isCoolingDown = [GiftClient sharedClient].currentGameInfo.BattleFishing.game_item.cool_down_remain_second.integerValue > 0;
//    return shoudlWatchVideo && videoReady && isCoolingDown;
//}

- (void)showRewardAnimation{
    if (self.lastError) {
        [self.view makeToast:self.lastError.localizedDescription duration:2.0f position:CSToastPositionBottom];
    }else{
        NSInteger initialCount = INITIAL_COIN_COUNT - self.rewardCount;
        NSInteger reward = self.rewardCount;
//        ZFRewardType rewardType = reward == 0 ? ZFRewardTypeNothing : ZFRewardTypeCoin;
        
//        [[ZFJiangjinManager sharedInstance] showRewardViewWithType:rewardType from:ZFRewardFromBattleFish initialCount:@(initialCount) rewardCount:@(reward) dismissCompletion:^{
//            
//            [HJRateUsController showRateUsViewWithAwardCoin:reward / 2 andCostCoin:0];
//        }];
    }
    
    [self.characterView animationForDisappear];
    [self.scoreBoardView animationForDisappearWithCompletion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coinCountView setCoinCount:INITIAL_COIN_COUNT];
        [self setGameReadyToStart:YES];
    });
}

#pragma mark - getter
- (XJPoolView *)pool{
    if (!_pool) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < [XJHappyFishManager sharedManager].fishbetPoolFishsCount; i ++) {
            [arr addObject:[[XJFishItem alloc] initWithType:XJFishTypeSideFish isStraw:NO isSide:NO]];
        }
        _pool = [[XJPoolView alloc] initWithFishs:arr];
        _pool.clipsToBounds = YES;
        _pool.delegate =self;
    }
    return _pool;
}

- (UIImageView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fISHBG_bet"]];
    }
    return _backgroundView;
}

- (CoinCountView *)coinCountView {
    if (!_coinCountView) {
        _coinCountView = [[CoinCountView alloc] initWithFrame:CGRectZero];
        [_coinCountView setCoinCount:INITIAL_COIN_COUNT];
    }
    return _coinCountView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"common_btn_back"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"common_btn_back"] forState:UIControlStateDisabled];
        
        [_backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (KYWaterWaveView *)frontWave{
    if (!_frontWave) {
        _frontWave = [[KYWaterWaveView alloc]init];
        _frontWave.waveSpeed = 1.4f;
        _frontWave.waveAmplitude = 4.0f;
        _frontWave.userInteractionEnabled = NO;
        _frontWave.waveColor = [UIColor hexStringToColor:@"#006a8e" alpha:0.2];
    }
    return _frontWave;
}

- (KYWaterWaveView *)backWave{
    if (!_backWave) {
        _backWave = [[KYWaterWaveView alloc]init];
        _backWave.waveSpeed = 1.5f;
        _backWave.waveAmplitude = 5.0f;
        _backWave.userInteractionEnabled = NO;
        _backWave.waveColor = [UIColor hexStringToColor:@"#006a8e" alpha:0.2];
    }
    return  _backWave;
}

- (XJStickView *)rightFishStick{
    if (!_rightFishStick) {
        _rightFishStick = [[XJStickView alloc] init];
        _rightFishStick.userInteractionEnabled = NO;
        [_rightFishStick setFishStickImage:[UIImage imageNamed:@"fishbetFishingrod"]];
    }
    return _rightFishStick;
}

- (XJStickView *)leftFishStick{
    if (!_leftFishStick) {
        _leftFishStick = [[XJStickView alloc] initWithDirection:XJStickViewDirectionLeft];
        _leftFishStick.userInteractionEnabled = NO;
        [_leftFishStick setFishStickImage:[UIImage imageNamed:@"fishbetFishingrod"]];
    }
    return _leftFishStick;
}

- (XJCountDownView *)countDownView{
    if (!_countDownView) {
        _countDownView = [[XJCountDownView alloc] init];
    }
    return _countDownView;
}

- (XJFishBetConsoleView *)consoleView{
    if (!_consoleView) {
        _consoleView = [[XJFishBetConsoleView alloc] init];
        _consoleView.delegate = self;
    }
    return _consoleView;
}

- (XJScoreBoardView *)scoreBoardView{
    if (!_scoreBoardView) {
        _scoreBoardView = [[XJScoreBoardView alloc] init];
        _scoreBoardView.userInteractionEnabled = NO;
    }
    return _scoreBoardView;
}

- (XJFishCharacterView *)characterView{
    if (!_characterView) {
        _characterView = [[XJFishCharacterView alloc] init];
        _characterView.delegate = self;
    }
    return _characterView;
}
@end
