//
//  ShopFeatureViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "ShopFeatureViewCell.h"

@implementation ShopFeatureItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_selected"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(24);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"品质臻选";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(imageView.right).offset(5);
        }];
    }
    return self;
}
@end

@implementation ShopFeatureViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        ShopFeatureItem* item1 = [ShopFeatureItem new];
        item1.titleLabel.text = @"品质臻选";
        [self addSubview:item1];
        [item1 mas_makeConstraints:^(MASConstraintMaker* make){
            make.top.bottom.left.equalTo(self);
            make.width.equalTo(ScreenW/3.f);
        }];
        
        ShopFeatureItem* item2 = [ShopFeatureItem new];
        item2.titleLabel.text = @"优惠折扣";
        [self addSubview:item2];
        [item2 mas_makeConstraints:^(MASConstraintMaker* make){
            make.top.bottom.centerX.equalTo(self);
            make.width.equalTo(ScreenW/3.f);
        }];
        
        ShopFeatureItem* item3 = [ShopFeatureItem new];
        item3.titleLabel.text = @"当日送达";
        [self addSubview:item3];
        [item3 mas_makeConstraints:^(MASConstraintMaker* make){
            make.top.bottom.right.equalTo(self);
            make.width.equalTo(ScreenW/3.f);
        }];
    }
    return self;
}
@end
