//
//  FontManager.h
//  GiftGame
//
//  Created by Jason on 16/11/22.
//  Copyright © 2016年 Ruozi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontManager : NSObject

+ (instancetype)sharedInstance;

- (UIFont *)getFontWithIdentifier:(NSString *)identifier;
- (UIColor *)getColorWithIdentifier:(NSString *)identifier;

@end
