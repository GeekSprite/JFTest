//
//  XJMainIndexCell.m
//  JFTest
//
//  Created by geeksprite on 2017/8/10.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

#import "XJMainIndexCell.h"
#import "XJMainIndexCellModel.h"
#import <UIImageView+WebCache.h>

@interface XJMainIndexCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation XJMainIndexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(XJMainIndexCellModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.name;
    self.descLabel.text = cellModel.desc;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:cellModel.iconUrl]];
}

@end
