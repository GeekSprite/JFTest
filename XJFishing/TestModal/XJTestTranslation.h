//
//  XJTestTranslation.h
//  XJFishing
//
//  Created by liuxj on 2017/6/20.
//  Copyright © 2017年 XRA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XJTestSource;

@interface XJTestSummary : NSObject

@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *key;

@end


@interface XJTestBaike : NSObject

@property (nonatomic, strong) NSArray<XJTestSummary *> *summarys;
@property (nonatomic, strong) XJTestSource *source;

@end

@interface XJTestTranslation : NSObject

@property (nonatomic, copy)     NSString *input;
@property (nonatomic, copy)     NSString *le;
@property (nonatomic, strong)   XJTestBaike *baike;

@end



