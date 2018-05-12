//
//  DetailTopFootView.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/5/10.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DetailTopFootView.h"

@implementation DetailTopFootView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    UIView* whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(10);
        make.bottom.equalTo(-10);
        make.left.right.equalTo(self);
    }];

    _leftTitleLable = [[UILabel alloc] init];
    _leftTitleLable.text = @"请选择 规格";
    _leftTitleLable.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _leftTitleLable.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_leftTitleLable];
    [_leftTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:10];
        make.centerY.mas_equalTo(self);
    }];
    
    _indicateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_indicateButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [self addSubview:_indicateButton];
    [_indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self)setOffset:-10];
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.mas_equalTo(self);
    }];
}


@end
