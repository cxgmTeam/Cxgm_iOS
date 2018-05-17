//
//  HomeShopViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "HomeShopViewCell.h"

@interface HomeShopViewCell ()
@property(nonatomic,strong)UILabel* shopNameLabel;
@property(nonatomic,strong)UILabel* shopAddressLabel;
@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation HomeShopViewCell


- (void)setShopModel:(ShopModel *)shopModel
{
    _shopNameLabel.text = shopModel.shopName;
    _shopAddressLabel.text = shopModel.shopAddress;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:shopModel.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.text = @"菜鲜果美望京西苑店";
    _shopNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    _shopNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_shopNameLabel];
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(13);
        make.left.equalTo(15);
    }];
    
    UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_location"]];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.shopNameLabel.bottom).offset(6);
        make.left.equalTo(15);
    }];
    
    _shopAddressLabel = [[UILabel alloc] init];
    _shopAddressLabel.text = @"北京市朝阳区望京西苑街道路128号院";
    _shopAddressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _shopAddressLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:_shopAddressLabel];
    [_shopAddressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.shopNameLabel.bottom).offset(2);
        make.left.equalTo(28);
    }];

    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"placeholderImage"];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(66);
    }];
}
@end
