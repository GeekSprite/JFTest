//
//  XJTestCell.m
//  XJFishing
//
//  Created by liuxj on 2017/6/19.
//  Copyright © 2017年 XRA. All rights reserved.
//

#import "XJTestCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XJTestModel.h"

@interface XJTestCell ()

@property (nonatomic, strong) UIImageView   *iconView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *descLabel;

@end

@implementation XJTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureViews];
    }
    return self;
}


- (void)configureViews {
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(5);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.top.equalTo(self.iconView);
    }];
    
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView);
        make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.iconView.mas_bottom).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCellModel:(XJTestModel *)cellModel {
    _cellModel = cellModel;
    [_iconView sd_setImageWithURL:cellModel.iconUrl placeholderImage:[UIImage imageNamed:@"DCGame-AppIcon"]];
    _titleLabel.text = cellModel.title;
    _descLabel.text = cellModel.desc;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 10;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}


@end
