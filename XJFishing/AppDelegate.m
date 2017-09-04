//
//  AppDelegate.m
//  XJFishing
//
//  Created by liuxj on 2017/6/12.
//  Copyright © 2017年 XRA. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (UIWindow *)window {

    if (!_window) {
        _window = [[UIWindow alloc] init];
        _window.frame = [UIScreen mainScreen].bounds;
    }
    return _window;
}

@end
