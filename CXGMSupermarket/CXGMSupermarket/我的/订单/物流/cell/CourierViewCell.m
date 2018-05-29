//
//  CourierViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/29.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CourierViewCell.h"

@interface CourierViewCell ()

@property(nonatomic,strong)UILabel* statusLabel;
@property(nonatomic,strong)UILabel* orderNumLabel;
@end

@implementation CourierViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImageView* headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"courier_head"]];
    [self addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"物流状态： ";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(13);
        make.left.equalTo(headView.right).offset(10);
    }];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.text = @"正在配送";
    _statusLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _statusLabel.textColor = Color00A862;
    [self addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(13);
        make.left.equalTo(label.right);
    }];
    
    _orderNumLabel = [[UILabel alloc] init];
    _orderNumLabel.text = @"订单号：7978276562561991";
    _orderNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _orderNumLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_orderNumLabel];
    [_orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(-10);
        make.left.equalTo(headView.right).offset(10);
    }];
    
    UIButton* button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"courier_phone"] forState:UIControlStateNormal];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.height.equalTo(40);
        make.right.centerY.equalTo(self);
    }];
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapButton:(UIButton *)button
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"15101164085"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
