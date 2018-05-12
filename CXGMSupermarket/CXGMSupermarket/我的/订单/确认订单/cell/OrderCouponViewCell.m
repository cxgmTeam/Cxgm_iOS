//
//  OrderCouponViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/30.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderCouponViewCell.h"

@interface OrderCouponViewCell ()
@property(nonatomic,strong)UILabel* valueLabel;
@end

@implementation OrderCouponViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUP];
    }
    return self;
}

- (void)setupUP
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"优惠券";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.left.equalTo(15);
    }];

    UIImageView* arrow = [UIImageView new];
    arrow.image = [UIImage imageNamed:@"arrow_right"];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-15);
        make.centerY.equalTo(self);
    }];
    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.text = @"-￥50.00";
    _valueLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _valueLabel.textColor = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1/1.0];
    [self addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(arrow.left).offset(-10);
        make.centerY.equalTo(self);
    }];
    
}
@end
