//
//  RefundAmountViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/7/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "RefundAmountViewCell.h"

@interface RefundAmountViewCell ()
@property(nonatomic,strong)UILabel* moneyLabel;
@end

@implementation RefundAmountViewCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"退款总金额";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(278, 151, 82, 29);
    label.text = @"¥800.80";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    label.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-15);
        make.centerY.equalTo(self);
    }];
    self.moneyLabel = label;
}
@end
