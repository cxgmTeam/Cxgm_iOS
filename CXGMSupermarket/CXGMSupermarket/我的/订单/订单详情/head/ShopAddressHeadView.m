//
//  ShopAddressHeadView.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "ShopAddressHeadView.h"

@interface ShopAddressHeadView ()
@property(nonatomic,strong)UILabel *shopNameLabel;
@property(nonatomic,strong)UILabel *shopAddressLabel;
@end

@implementation ShopAddressHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_store"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.left.equalTo(16);
    }];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.text = @"菜鲜果美朝阳大悦城店";
    _shopNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    _shopNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_shopNameLabel];
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(15);
        make.left.equalTo(imageView.right).offset(10);
    }];
    
    _shopAddressLabel = [[UILabel alloc] init];
    _shopAddressLabel.text = @"北京市朝阳区望京西苑街道路128号院";
    _shopAddressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _shopAddressLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:_shopAddressLabel];
    [_shopAddressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.shopNameLabel.bottom).offset(2);
        make.left.equalTo(self.shopNameLabel);
    }];
}
@end
