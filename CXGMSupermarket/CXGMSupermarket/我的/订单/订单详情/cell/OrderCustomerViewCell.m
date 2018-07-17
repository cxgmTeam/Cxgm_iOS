//
//  OrderCustomerViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/27.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderCustomerViewCell.h"

@interface OrderCustomerViewCell ()
@property(nonatomic,strong)UILabel* customerLbel;
@property(nonatomic,strong)UILabel* addressLbel;

@property(nonatomic,strong)UILabel* noAddressLbel;
@end

@implementation OrderCustomerViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

- (void)setAddress:(AddressModel *)address
{
    if (address){
        _noAddressLbel.hidden = YES;
        
        _customerLbel.text =[NSString stringWithFormat:@"%@            %@",address.realName,[Utility phoneNumToAsterisk:address.phone]];
        _addressLbel.text = [NSString stringWithFormat:@"收货地址：%@%@",address.area,address.address];
    }else{
        _noAddressLbel.hidden = NO;
        
        _customerLbel.text = @"";
        _addressLbel.text = @"";
    }
}

- (void)setupUI
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_address"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    _customerLbel = [[UILabel alloc] init];
    _customerLbel.text = @"彭先生            155****6650";
    _customerLbel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    _customerLbel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_customerLbel];
    [_customerLbel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(47);
        make.top.equalTo(15);
    }];
    
    _addressLbel = [[UILabel alloc] init];
    _addressLbel.numberOfLines = 2;
    _addressLbel.text = @"收货地址：北京市朝阳区国贸建外SOHO东区A座1710号";
    _addressLbel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _addressLbel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:_addressLbel];
    [_addressLbel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.customerLbel);
        make.width.equalTo(ScreenW-47-40);
        make.top.equalTo(self.customerLbel.bottom).offset(3);
    }];
    
    UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.right.equalTo(-15);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(1);
    }];
    
    
    _noAddressLbel = [[UILabel alloc] init];
    _noAddressLbel.text =  @"请新增收货地址";
    _noAddressLbel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    _noAddressLbel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_noAddressLbel];
    [_noAddressLbel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(47);
        make.centerY.equalTo(self);
    }];
    _noAddressLbel.hidden = YES;
    
}
@end
