//
//  NSArray+ImageNames.h
//  DCGame
//
//  Created by xiabob on 2017/5/5.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ImageNames)

+ (NSArray<UIImage *> *)safeImagesArray:(NSArray<NSString *> *)imageNames;

@end
