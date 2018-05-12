//
//  SearchGridCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/6.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "SearchGridCell.h"

@implementation SearchGridCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorE8E8E8E;
        self.layer.cornerRadius = 4;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"特惠三文鱼";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self);
    }];
    _titleLabel = label;
}
@end
