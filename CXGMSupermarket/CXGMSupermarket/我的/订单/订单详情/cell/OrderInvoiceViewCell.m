//
//  OrderInvoiceViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/27.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderInvoiceViewCell.h"

@interface OrderInvoiceViewCell ()
@property (nonatomic,retain)UILabel *numberLabel;
@property (nonatomic,retain)UILabel *timeLabel;
@property (nonatomic,retain)UILabel *paywayLabel;
@property (nonatomic,retain)UILabel *invoiceLabel;
@end

@implementation OrderInvoiceViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

- (void)setOrder:(OrderModel *)order
{
    _numberLabel.text = order.orderNum;
    _timeLabel.text = order.orderTime;
    
    _paywayLabel.text = @"";
    if ([order.payType isEqualToString:@"wx"]) {
        _paywayLabel.text = @"微信支付";
    }else if ([order.payType isEqualToString:@"zfb"]){
        _paywayLabel.text = @"支付宝支付";
    }
    
    _invoiceLabel.text = order.extractionType;

//    if (!order.receipt) {
//        _invoiceLabel.text = @"不开发票";
//    }else{
//
//    }
}


- (void)setupUI
{
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"订单编号：";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label1.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.top.equalTo(16);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"下单时间：";
    label2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label2.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(label1);
        make.top.equalTo(label1.bottom).offset(8);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"支付方式：";
    label3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label3.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(label1);
        make.top.equalTo(label2.bottom).offset(8);
    }];

    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self);
        make.height.equalTo(1);
        make.top.equalTo(label3.bottom).offset(15);
    }];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"配送方式：";
    label4.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label4.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(label1);
        make.top.equalTo(line.bottom).offset(12);
    }];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.text = @"660008978786";
    _numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _numberLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(85);
        make.top.equalTo(label1);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"2018-04-22   13:28:22";
    _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _timeLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.numberLabel);
        make.top.equalTo(label2);
    }];
    
    _paywayLabel = [[UILabel alloc] init];
    _paywayLabel.text = @"微信支付";
    _paywayLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _paywayLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_paywayLabel];
    [_paywayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.numberLabel);
        make.top.equalTo(label3);
    }];
    
    _invoiceLabel = [[UILabel alloc] init];
    _invoiceLabel.text = @"不开发票";
    _invoiceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _invoiceLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_invoiceLabel];
    [_invoiceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.numberLabel);
        make.top.equalTo(label4);
    }];

}
@end
