//
//  ShoppingCartCollectionCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/12.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "ShoppingCartCollectionCell.h"

@interface ShoppingCartCollectionCell ()
@property(nonatomic,strong)UIImageView* iconView; //图片
@property(nonatomic,strong)UILabel* nameLabel;    //名字
@property(nonatomic,strong)UILabel* countLabel;   //数量
@property(nonatomic,strong)UILabel* desLabel;     //描述
@property(nonatomic,strong)UILabel* priceLabel;   //价格

@end

@implementation ShoppingCartCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _iconView = [UIImageView new];
        [self addSubview:_iconView];
        
        _nameLabel = [UILabel new];
        [self addSubview:_nameLabel];
        
        _countLabel = [UILabel new];
        [self addSubview:_countLabel];
        
        _desLabel = [UILabel new];
        [self addSubview:_desLabel];
        
        _priceLabel = [UILabel new];
        [self addSubview:_priceLabel];
        

        
    }
    return self;
}

@end
