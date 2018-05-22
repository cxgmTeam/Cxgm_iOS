//
//  OrderPaywayViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/30.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderPaywayViewCell.h"

@implementation OrderPaywayViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUP];
    }
    return self;
}

- (void)setupUP
{
    UIImageView* imgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wechat_pay"]];
    [self addSubview:imgView1];
    [imgView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(12);
        make.left.equalTo(15);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"微信支付";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label1.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0];
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(imgView1);
        make.left.equalTo(imgView1.right).offset(7);
    }];
    
    UIButton* btn1 = [UIButton new];
    [btn1 setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
    [self addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(40, 40));
        make.right.top.equalTo(self);
    }];
    btn1.selected = YES;

    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.centerY.equalTo(self);
        make.height.equalTo(1);
    }];
    
    UIImageView* imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alipay_pay"]];
    [self addSubview:imgView2];
    [imgView2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(-12);
        make.left.equalTo(15);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"支付宝支付";
    label2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label2.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0];
    [self addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(imgView2);
        make.left.equalTo(imgView2.right).offset(7);
    }];
    
    UIButton* btn2 = [UIButton new];
    [btn2 setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
    [self addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(40, 40));
        make.right.bottom.equalTo(self);
    }];

}
@end
