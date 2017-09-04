//
//  NSArray+ImageNames.m
//  DCGame
//
//  Created by xiabob on 2017/5/5.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "NSArray+ImageNames.h"

@implementation NSArray (ImageNames)

+ (NSArray<UIImage *> *)safeImagesArray:(NSArray<NSString *> *)imageNames {
    NSMutableArray *imagesArray = [NSMutableArray new];
    for (NSString *name in imageNames) {
        UIImage *image = [UIImage imageNamed:name];
        if (image) {
            [imagesArray addObject:image];
        }
    }
    
    return imagesArray;
}

@end
