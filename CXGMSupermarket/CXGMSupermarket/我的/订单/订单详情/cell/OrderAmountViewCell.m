//
//  OrderAmountViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/27.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderAmountViewCell.h"

@interface OrderAmountViewCell ()
@property (nonatomic,retain)UILabel *amountLabel;
@property (nonatomic,retain)UILabel *couponLabel;
@property (nonatomic,retain)UILabel *freightLabel;
@property (nonatomic,retain)UILabel *paymentLabel;
@end

@implementation OrderAmountViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

- (void)setOrder:(OrderModel *)order
{
    _amountLabel.text = [NSString stringWithFormat:@"¥%.2f",[order.totalAmount floatValue]];
    _couponLabel.text = [NSString stringWithFormat:@"¥%.2f",[order.preferential floatValue]];
    _paymentLabel.text = [NSString stringWithFormat:@"¥%.2f",[order.orderAmount floatValue]];
    _freightLabel.text = [NSString stringWithFormat:@"¥%.2f",[order.postage floatValue]];
}

- (void)setupUI
{
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"商品总额";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label1.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.top.equalTo(18);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"优惠";
    label2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label2.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(label1);
        make.top.equalTo(label1.bottom).offset(16);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"运费";
    label3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label3.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(label2);
        make.top.equalTo(label2.bottom).offset(16);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self);
        make.height.equalTo(1);
        make.top.equalTo(label3.bottom).offset(17);
    }];
    
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.text = @"¥460.00";
    _amountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _amountLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_amountLabel];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-20);
        make.top.equalTo(label1);
    }];
    
    _couponLabel = [[UILabel alloc] init];
    _couponLabel.text = @"¥41.00";
    _couponLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _couponLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_couponLabel];
    [_couponLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.amountLabel);
        make.top.equalTo(label2);
    }];
    
    _freightLabel = [[UILabel alloc] init];
    _freightLabel.text = [NSString stringWithFormat:@"¥%.2f",Freight_Charges];
    _freightLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _freightLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_freightLabel];
    [_freightLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.amountLabel);
        make.top.equalTo(label3);
    }];
    
    
    _paymentLabel = [[UILabel alloc] init];
    _paymentLabel.text = @"¥800.80";
    _paymentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    _paymentLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [self addSubview:_paymentLabel];
    [_paymentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-15);
        make.top.equalTo(line.bottom).offset(8);
    }];
    
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"实付款：";
    label4.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label4.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0];
    [self addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.paymentLabel.left).offset(-10);
        make.centerY.equalTo(self.paymentLabel);
    }];
    
}
@end
