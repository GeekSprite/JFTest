//
//  XJMainIndexCellModel.h
//  JFTest
//
//  Created by geeksprite on 2017/8/10.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJMainIndexCellModel : NSObject

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) dispatch_block_t clickHandler;

@end
