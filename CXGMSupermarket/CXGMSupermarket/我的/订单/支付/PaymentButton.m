//
//  PaymentButton.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/23.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "PaymentButton.h"

@implementation PaymentButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wechat_pay"]];
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(15);
        }];
        _iconView = imgView;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"微信支付";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(self.iconView.right).offset(7);
        }];
        _titleLabel = label;
        
        
        _markView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_selected"]];
        [self addSubview:_markView];
        [_markView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.right.equalTo(-10);
        }];
        
        
    }
    return self;
}

@end
