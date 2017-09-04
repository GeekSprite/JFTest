//
//  XJHappyFishViewController.m
//  HappyFishing
//
//  Created by GeekSprite on 2017/3/2.
//  Copyright © 2017年 GeekSprite. All rights reserved.
//

#import "XJHappyFishViewController.h"
#import "XJPoolView.h"
#import "XJHappyFishManager.h"
#import "XJStickView.h"
#import "Masonry.h"
#import "CoinCountView.h"
#import "UIView+Toast.h"
#import "SoundManager+BackgroundMusic.h"
#import "KYWaterWaveView.h"
#import "XJLeverListTableViewCell.h"
#import "XJFishRewardView.h"
#import "XJFishBottomBar.h"
#import "CCommon.h"
#import "GameEnum.h"

#define Wave_Offset     16.0
#define Lever_Cell_Height 46.0
#define REWARD_ANIMATION_DURATION               1.5
#define EMPTY_REWARD_ANIMATION_DURATION         0.75
#define INITIAL_COIN_COUNT                  2000

@interface XJHappyFishViewController ()<XJPoolViewDelegate, XJFishBottomBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) XJPoolView *pool;
@property(nonatomic, strong) XJStickView *fishStickView;
@property(nonatomic, strong) KYWaterWaveView *frontWave;
@property(nonatomic, strong) KYWaterWaveView *backWave;
@property(nonatomic, strong) XJFishBottomBar *bottomBar;
@property(nonatomic, strong) UIImageView *backgroundView;
@property(nonatomic, strong) CoinCountView *coinCountView;
@property(nonatomic, strong) UITableView *leverListTableView;
@property(nonatomic, strong) XJFishRewardView *rewardView;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) NSError *lastError;
@property(nonatomic)         NSInteger lastReward;
@property(nonatomic)         NSInteger rewardCoinsCount;
@property(nonatomic)         NSInteger rewardFishCount;
@property(nonatomic)         BOOL isOnAd;
@property(nonatomic)         GameStatus gameStatus;

@end

static NSString *XJLeverListCellIdentifier = @"XJLeverListCellIdentifier";
@implementation XJHappyFishViewController

#pragma mark - lifeCircle
- (void)dealloc{
    debugMethod();
    [self.backWave stop];
    [self.frontWave stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameStatus = GameStatus_Start;
    self.isOnAd = NO;
    [self setGameReadyToStart:YES];
    [self resetRewardInfo];
    [self configView];
    [self.backWave wave];
    [self.frontWave wave];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.pool addAdFish];
}

#pragma mark - configView
- (void)configView{
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CGFloat backY = SCREEN_HEIGHT * 0.32;
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
    
    CGFloat stickWidth = (SCREEN_WIDTH/2.0)/(1-Stick_Height_Ratio);
    CGFloat stickHeight = 160 * ScreenHeightRatio ;
    self.fishStickView.frame = CGRectMake(SCREEN_WIDTH/2.0 + stickWidth/2.0 , backY - stickHeight * 1.5 + Wave_Offset * 4.0, stickWidth, stickHeight);
    [self.view addSubview:self.fishStickView];

    [self.view addSubview:self.pool];
    [self.pool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.bottom.equalTo(self.view);
        make.height.mas_equalTo(backHeight);
    }];
    
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.height.mas_equalTo(142 * SCREEN_WIDTH / 414.0);
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
    
    [self.view addSubview:self.leverListTableView];
    [self.leverListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(14);
        make.bottom.equalTo(self.view).offset(-77 * SCREEN_HEIGHT / 736.0);
        make.height.mas_equalTo(Lever_Cell_Height * [XJHappyFishManager sharedManager].leverList.count);
        make.width.mas_equalTo(110 * SCREEN_WIDTH / 414.0);
    }];
    
    [self.view addSubview:self.rewardView];
    [self.rewardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(145 * SCREEN_HEIGHT / 736.0);
        make.height.mas_equalTo(107 * SCREEN_HEIGHT / 736.0);
        make.width.mas_equalTo(150 * SCREEN_WIDTH / 414.0);
    }];
}

#pragma mark - ZFRewardVideoManagerDelegate

//- (void)videoDidUpdateStatus:(ZFRewardVideoStatus)status{
//    if (status == ZFRewardVideoStatusReady) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//                [self.pool addAdFish];
//        });
//    }
//}
//
//- (void)videoWillStartPlayingWithPlatform:(ZFRewardVideoType)platform {
//    [GiftEventLogHelper logWatchVideo:DVALUE_GAME_HAPPYFISH platform:platform];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [CCommon getAppDelegateWindow].userInteractionEnabled = YES;
//        [[CCommon getAppDelegateWindow] hideToastActivity];
//    });
//    
//    if ([[SoundManager sharedManager] shouldPlayBackgroundMusic]) {
//        [[SoundManager sharedManager] stopMusic];
//    }
//    
//}
//
//- (void)videoDidFinishedWithPlatform:(ZFRewardVideoType)platform {
//    self.isOnAd = NO;
//    if ([[SoundManager sharedManager] shouldPlayBackgroundMusic]) {
//        [[SoundManager sharedManager] playMusic:@"background_music.mp3"];
//    }
//    if (self.gameStatus == GameStatus_End) {
//        CGFloat duration = (self.rewardCoinsCount == 0 || self.lastError) ? EMPTY_REWARD_ANIMATION_DURATION : REWARD_ANIMATION_DURATION;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self showRewardAnimation];
//        });
//    }
//    [HJGameWatchVideoConditions didWatchVideoWithGameType:GameType_HappyFish];
//}


#pragma mark - XJPoolViewDelegate
- (void)gameRewardAnimationDidEndWithError:(BOOL)isError{
    [self resetRewardInfo];
    WEAK_SELF;
    [self.fishStickView takeUpWireAnimationWithCompletion:^{
        STRONG_SELF;
        self.gameStatus = GameStatus_End;
        if (!self.isOnAd) {
            CGFloat duration = (self.rewardCoinsCount == 0 || self.lastError) ? EMPTY_REWARD_ANIMATION_DURATION : REWARD_ANIMATION_DURATION;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showRewardAnimation];
            });
        }
    }];
}

- (void)didGetFish:(XJFishItem *)fish{
    self.rewardFishCount += 1;
    self.rewardCoinsCount += fish.rewardCount;
    [self.rewardView updateWithFishCount:_rewardFishCount andReward:self.rewardCoinsCount];
}

- (void)didTouchBeginWithChooseAdFish:(BOOL)choose{
    [self showLeverListView:NO];
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
//        
//        if ([[SoundManager sharedManager] shouldPlayBackgroundMusic]) {
//            [[SoundManager sharedManager] stopMusic];
//        }
//    } else {
//        [GiftEventLogHelper logNewGameOpen:@"no_ad"];
//    }
//    [GiftEventLogHelper logFishAdClick:@"unknown"];
}

#pragma mark - XJFishBottomBarDelegate
- (void)didClickStart {
//    if ([self timeToWatchVideo]) {
//        DPAlertViewController *alertVC = [[DPAlertViewController alloc] init];
//        alertVC.delegate = self;
//        alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        [alertVC updateCountDown:[[LWGameDataController sharedInstance] gameModelForGameType:LWGameTypeFishing].coolDownTime];
//        [self presentViewController:alertVC animated:NO completion:nil];
//        [GiftEventLogHelper logShowVideoAlert:DVALUE_GAME_HAPPYFISH];
//        [self setGameReadyToStart:YES];
//        
//    } else {
//    }
    [self showLeverListView:NO];
    [self startFishing];
}

- (void)didClickBetSelect{
    [self showLeverListView:self.leverListTableView.isHidden];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *num = [XJHappyFishManager sharedManager].leverList.reverseObjectEnumerator.allObjects[indexPath.row];
    [XJHappyFishManager sharedManager].currentLeverage =  num;
    [tableView reloadData];
    [self.bottomBar.betSelectButton setTitle:[NSString stringWithFormat:@"%@",[[XJHappyFishManager sharedManager] perBet]] forState:UIControlStateNormal];
    
//    [[HJGameRulesManager sharedManager] showGameRulesViewWithGameType:GameType_HappyFish betCoins:[[XJHappyFishManager sharedManager] perBet].integerValue result:^(BOOL canStartGame) {
//        
//    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [XJHappyFishManager sharedManager].leverList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJLeverListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XJLeverListCellIdentifier];
    cell.leverage = [XJHappyFishManager sharedManager].leverList.reverseObjectEnumerator.allObjects[indexPath.row].integerValue;
    return cell;
}

#pragma mark - DPAlertViewControllerDelegate

//- (void)videoButtonDidClick:(id)sender {
//    [self playVideo];
//}

#pragma mark - LWGameControllerDelegate

//- (void)fishingGameDidUpdate:(LWGameModel *)gameModel {
//    if ([self.presentedViewController isKindOfClass:[DPAlertViewController class]]) {
//        DPAlertViewController *alertVC = (DPAlertViewController *)self.presentedViewController;
//        [alertVC updateCountDown:gameModel.coolDownTime];
//    }
//}

#pragma mark - action
- (void)startFishing {
    [self setGameReadyToStart:NO];
//    if (![[XJHappyFishManager sharedManager] canPlayHappyFishing] || !self.fishStickView.isReady) {
//         [[ZFJiangjinManager sharedInstance] showNotEnoughCoinsAlert];
//        [self setGameReadyToStart:YES];
//        return ;
//    }
    WEAK_SELF;
    [self.fishStickView throwWireAnimationWithCompletion:^(CGPoint point) {
        STRONG_SELF;
        self.gameStatus = GameStatus_Underway;
        [self.pool setBitePoint:point];
        self.pool.poolState = XJPoolStateReadyForBite;
    }];

    [[XJHappyFishManager sharedManager] playHappyFishingGameWithCompletion:^(NSNumber *reward, NSArray *bait_list, NSError *error) {
        self.lastReward = reward.integerValue;
        if (error) {
            self.lastError = error;
            self.pool.poolState = XJPoolStateReceivedError;
        }else{
            [self.pool setRewardResult:bait_list];
            self.pool.poolState = XJPoolStateReceivedResult;
        }
    }];
    
    NSInteger coinsNeeded = [XJHappyFishManager sharedManager].perBet.integerValue;
    [self.coinCountView playAnimationWithDeductCoinCount:coinsNeeded];
//    [self.coinCountView setCoinCount:[GiftClient sharedClient].currentUser.coins.integerValue - coinsNeeded];
}

- (void)goBack:(UIButton *)button {
    [[SoundManager sharedManager] playSound:@"HOME_Btn_tap.mp3"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showLeverListView:NO];
}

#pragma mark - priavte
- (void)showRewardAnimation {
    if (self.lastError) {
        [self.view makeToast:self.lastError.localizedDescription duration:2.0f position:CSToastPositionBottom];
    }else{
        
    NSInteger initialCount = INITIAL_COIN_COUNT - self.lastReward;
//    [[ZFJiangjinManager sharedInstance] showRewardViewWithType:self.lastReward == 0 ? ZFRewardTypeNothing : ZFRewardTypeCoin from:ZFRewardTypeFishing initialCount:@(initialCount) rewardCount:@(self.lastReward) dismissCompletion:^{
//        
//        [HJRateUsController showRateUsViewWithAwardCoin:self.lastReward
//                                            andCostCoin:[[XJHappyFishManager sharedManager] perBet].integerValue];
//    }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coinCountView setCoinCount:INITIAL_COIN_COUNT];
        [self setGameReadyToStart:YES];
    });
}

- (void)setGameReadyToStart:(BOOL)flag{
    self.navigationController.interactivePopGestureRecognizer.enabled = flag;
    self.pool.clipsToBounds = flag;
    self.backButton.enabled = flag;
    self.bottomBar.startButton.enabled = flag;
    self.bottomBar.betSelectButton.enabled = flag;
    if (flag) {
        self.lastError = nil;
        self.gameStatus = GameStatus_Start;
        self.isOnAd = NO;
    }
}
- (void)showLeverListView:(BOOL)flag{
    self.leverListTableView.hidden = !flag;
    NSString *imgStr = flag ? @"fishImgDown" : @"fishImgUp";
    self.bottomBar.betLeverView.image = [UIImage imageNamed:imgStr];
}

- (void)resetRewardInfo{
    self.rewardCoinsCount = 0;
    self.rewardFishCount = 0;
    [self.rewardView stopRewardAnimation];
}

//- (BOOL)timeToWatchVideo {
//    
//    BOOL shoudlWatchVideo =  [HJGameWatchVideoConditions shouldWatchVideoWithGameType:GameType_HappyFish];
//    BOOL videoReady = [ZFRewardVideoManager sharedInstance].status == ZFRewardVideoStatusReady;
//    BOOL isCoolingDown = [GiftClient sharedClient].currentGameInfo.Fishing.game_item.cool_down_remain_second.integerValue > 0;
//    return shoudlWatchVideo && videoReady && isCoolingDown;
//    
//}
//
//- (void)playVideo {
//    
//    [ZFRewardVideoManager sharedInstance].delegate = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [CCommon getAppDelegateWindow].userInteractionEnabled = NO;
//        [[CCommon getAppDelegateWindow] makeToastActivity:CSToastPositionCenter];
//        [[ZFRewardVideoManager sharedInstance] play];
//    });
//    [HJGameWatchVideoConditions didWatchVideoWithGameType:GameType_HappyFish];
//}

#pragma mark - getter
- (XJPoolView *)pool{
    if (!_pool) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[XJHappyFishManager sharedManager].poolFishs];
        _pool = [[XJPoolView alloc] initWithFishs:array];
        _pool.clipsToBounds = YES;
        _pool.delegate =self;
    }
    return _pool;
}

- (XJStickView *)fishStickView{
    if (!_fishStickView) {
            _fishStickView = [[XJStickView alloc] init];
        }
    return _fishStickView;
}

- (UIImageView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fISHBG"]];
    }
    return _backgroundView;
}

- (XJFishBottomBar *)bottomBar{
    if (!_bottomBar) {
        _bottomBar = [[XJFishBottomBar alloc] init];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
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
        _backWave.userInteractionEnabled = NO;
        _backWave.waveSpeed = 1.5f;
        _backWave.waveAmplitude = 5.0f;
        _backWave.waveColor = [UIColor hexStringToColor:@"#006a8e" alpha:0.2];
    }
    return  _backWave;
}

- (XJFishRewardView *)rewardView{
    if (!_rewardView) {
        _rewardView = [[XJFishRewardView alloc] init];
    }
    return _rewardView;
}

- (UITableView *)leverListTableView {
    if (!_leverListTableView) {
        _leverListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leverListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leverListTableView.bounces = NO;
        _leverListTableView.showsHorizontalScrollIndicator = NO;
        _leverListTableView.showsVerticalScrollIndicator = NO;
        [_leverListTableView registerClass:[XJLeverListTableViewCell class] forCellReuseIdentifier:XJLeverListCellIdentifier];
        _leverListTableView.dataSource = self;
        _leverListTableView.delegate = self;
        _leverListTableView.rowHeight = Lever_Cell_Height;
        _leverListTableView.backgroundColor = [UIColor clearColor];
        _leverListTableView.hidden = YES;
    }
    return _leverListTableView;
}

@end
