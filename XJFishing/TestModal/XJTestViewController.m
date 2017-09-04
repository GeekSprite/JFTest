//
//  XJTestViewController.m
//  XJFishing
//
//  Created by liuxj on 2017/6/20.
//  Copyright © 2017年 XRA. All rights reserved.
//

#import "XJTestViewController.h"

static NSString *const aniKey = @"anikey";

@interface XJTestViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *upperImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UILongPressGestureRecognizer *upperGestureRecognizer;

@end

@implementation XJTestViewController

- (void)dealloc {
    [self.upperGestureRecognizer removeObserver:self forKeyPath:@"state"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    
    [self.upperGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        switch (self.upperGestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
            {
                [self.upperImageView.layer removeAnimationForKey:aniKey];
                

                
                self.upperImageView.layer.transform = CATransform3DMakeRotation(M_PI / 4.0, 1.0, 0.0, 0.0);
            }
                break;
                
            case UIGestureRecognizerStateChanged:
            {
                debugMethod();
                self.upperImageView.layer.transform = CATransform3DRotate(self.upperImageView.layer.transform, M_PI / 12.0, 1.0, 0.0, 0.0);
            }
                
                break;
                
            case UIGestureRecognizerStateEnded:{
             

                
                
                CATransform3D transform = CATransform3DIdentity;
                transform.m34 = -1.0 / 1200;
                
                CATransform3D transformAfter = CATransform3DRotate(transform, M_PI, 1.0, 0.0, 0.0);
                
                CATransform3D transformEnd = CATransform3DRotate(transformAfter, M_PI, 1.0, 0.0, 0.0);
                
                CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                ani.values = @[[NSValue valueWithCATransform3D:transform],[NSValue valueWithCATransform3D:transformAfter],[NSValue valueWithCATransform3D:transformEnd]];
                ani.keyTimes = @[@(0.0),@(0.5),@(1.0)];
                ani.duration = 3.0;
                ani.repeatCount = HUGE_VAL;
                [self.upperImageView.layer addAnimation:ani forKey:aniKey];
                
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)configureView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
        make.center.equalTo(self.view);
    }];
    
    [self.containerView addSubview:self.upperImageView];
    
    [self.upperImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.top.equalTo(self.containerView);
        make.height.mas_equalTo(self.containerView.mas_height).multipliedBy(0.5);
    }];
    
    [self.containerView addSubview:self.bottomImageView];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.containerView);
        make.height.mas_equalTo(self.containerView.mas_height).multipliedBy(0.5);
    }];
}


- (void)gestureBegin {
    


}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
//        _containerView.layer.borderWidth = 2.0;
//        _containerView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _containerView;
}

- (UIImageView *)upperImageView {
    if (!_upperImageView) {
        _upperImageView = [[UIImageView alloc] init];
        _upperImageView.image = [UIImage imageNamed:@"banner_ad_box"];
        _upperImageView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
        _upperImageView.userInteractionEnabled = YES;
        _upperImageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 2.0 / -2000.0;
        _upperImageView.layer.transform = transform;
        [_upperImageView addGestureRecognizer:self.upperGestureRecognizer];
    }
    return _upperImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.image = [UIImage imageNamed:@"banner_ad_box"];
        _bottomImageView.layer.anchorPoint = CGPointMake(0.5, 0.0);
        _bottomImageView.layer.contentsRect = CGRectMake(0, 0.5, 1.0, 0.5);
    }
    return _bottomImageView;
}

- (UILongPressGestureRecognizer *)upperGestureRecognizer {
    if (!_upperGestureRecognizer) {
        _upperGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureBegin)];
        _upperGestureRecognizer.minimumPressDuration = 0.23;
    }
    return _upperGestureRecognizer;
}

@end
