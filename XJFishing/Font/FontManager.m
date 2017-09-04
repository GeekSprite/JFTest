//
//  FontManager.m
//  GiftGame
//
//  Created by Jason on 16/11/22.
//  Copyright © 2016年 Ruozi. All rights reserved.
//

#import "FontManager.h"
#import "FontUtil.h"

#define kFontColorKey @"Color"
#define kFontNameKey  @"Name"
#define kFontSizeKey  @"Size"

static FontManager *_fontManager = nil;

@interface FontManager ()

@property (nonatomic, copy) NSMutableDictionary *fontDic;

@end

@implementation FontManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fontManager = [[FontManager alloc] init];
        [_fontManager readThemeFontConfig];
    });
    return _fontManager;
}

- (NSString *)getPlistName {

    return @"Font_default";
}

- (void)readThemeFontConfig {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:[self getPlistName] ofType:@"plist"];
    self.fontDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - Public method

- (UIFont *)getFontWithIdentifier:(NSString *)identifier {
    NSDictionary *renderInfo = self.fontDic[identifier];
    NSString *fontName = renderInfo[kFontNameKey] ? renderInfo[kFontNameKey] : @"Helvetica";
    CGFloat fontSize = renderInfo[kFontSizeKey] ? [renderInfo[kFontSizeKey] floatValue]: 10.0f;
    
    return [UIFont fontWithName:fontName size:[FontUtil fontSize:fontSize]];
}

- (UIColor *)getColorWithIdentifier:(NSString *)identifier {
    NSDictionary *renderInfo = self.fontDic[identifier];
    NSString *colorHexValue = renderInfo[kFontColorKey] ? renderInfo[kFontColorKey] : @"#FFFFFF";
    
    return kColorWithHexValue(colorHexValue);
}

@end
