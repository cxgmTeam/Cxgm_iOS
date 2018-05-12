//
//  GoodsListGridCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsListGridCell.h"

@interface GoodsListGridCell ()
@property(nonatomic,strong)UIImageView* gridImageView; //图片
@property(nonatomic,strong)UILabel* nameLabel;    //名字
@property(nonatomic,strong)UILabel* priceLabel;   //价格
@property(nonatomic,strong)UILabel* oldPriceLabel;   //价格
@property(nonatomic,strong)UIButton* addBtn;      //添加按钮
@end

@implementation GoodsListGridCell

- (void)setShowOldPrice:(BOOL)showOldPrice{
    _oldPriceLabel.hidden = !showOldPrice;
}


- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    [_gridImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _nameLabel.text = goodsModel.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.price floatValue]];
    _oldPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.marketPrice floatValue]];
    
    NSUInteger length = [_oldPriceLabel.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_oldPriceLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0] range:NSMakeRange(0, length)];
    [_oldPriceLabel setAttributedText:attri];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI{
    _gridImageView = [UIImageView new];
    _gridImageView.image = [UIImage imageNamed:@"placeholderImage"];
    [self addSubview:_gridImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.numberOfLines = 2;
    _nameLabel.text = @"库尔勒香梨天然香果 果实饱满 真甜如蜜 120g";
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_nameLabel];

    _priceLabel = [UILabel new];
    _priceLabel.text = @"￥68.0";
    _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    _priceLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [self addSubview:_priceLabel];
    
    _oldPriceLabel = [[UILabel alloc] init];
    _oldPriceLabel.text = @"¥ 89.9";
    _oldPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    _oldPriceLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    [self addSubview:_oldPriceLabel];
    
    NSUInteger length = [_oldPriceLabel.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_oldPriceLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0] range:NSMakeRange(0, length)];
    [_oldPriceLabel setAttributedText:attri];
    
    _addBtn = [UIButton new];
    [_addBtn setImage:[UIImage imageNamed:@"add_goods"] forState:UIControlStateNormal];
    [self addSubview:_addBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.dc_width, self.dc_width));
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        [make.top.mas_equalTo(self.gridImageView.mas_bottom)setOffset:10];
    }];

    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.equalTo(self.gridImageView.bottom).offset(56);
    }];
    
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel.right).offset(10);
        make.top.equalTo(self.priceLabel);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.priceLabel.bottom);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}
@end
