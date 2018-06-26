//
//  TextTitleHeadView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "TextTitleHeadView.h"

@interface TextTitleHeadView ()

@end

@implementation TextTitleHeadView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUI];
        
        [self setUpBase];
    }
    return self;
}

- (void)setUpUI{

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _subTitleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self addSubview:_subTitleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(self);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.bottom).offset(3);
        make.centerX.mas_equalTo(self);
    }];
}

- (void)setUpBase
{
    self.backgroundColor = [UIColor whiteColor];
}
@end
