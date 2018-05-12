//
//  SearchHeadView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/6.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "SearchHeadView.h"

@implementation SearchHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"热门搜索";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(14);
        make.bottom.equalTo(self);
    }];
    _titleLabel = label;
}
@end
