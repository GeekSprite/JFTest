//
//  XJTestTranslation.m
//  XJFishing
//
//  Created by liuxj on 2017/6/20.
//  Copyright © 2017年 XRA. All rights reserved.
//

#import "XJTestTranslation.h"
#import <YYModel/YYModel.h>

@implementation XJTestSummary

@end


@implementation XJTestBaike

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"summarys" : [XJTestSummary class]};
}

@end

@implementation XJTestTranslation

@end
