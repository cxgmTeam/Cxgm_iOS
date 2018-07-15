//
//  GoodsOneScreenShotCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/30.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsOneScreenShotCell.h"

@interface GoodsOneScreenShotCell ()
//显示照片
@property (nonatomic,retain) UIImageView *imageView;
//商品名
@property (nonatomic,retain) UILabel *nameLabel;
//规格
@property (nonatomic,retain) UILabel *sizeLabel;
//价格
@property (nonatomic,retain) UILabel *priceLabel;
@property (nonatomic,retain) UILabel *oldPriceLabel;
//数量
@property (nonatomic,retain)UILabel *numberLabel;
@end

@implementation GoodsOneScreenShotCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

- (void)setGoods:(GoodsModel *)goods
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:goods.productUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.nameLabel.text = goods.productName;
    self.sizeLabel.text = [NSString stringWithFormat:@"规格：%@g/%@",goods.weight,goods.unit];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[goods.price floatValue]];
    if ([goods.originalPrice floatValue] > 0)
    {
        _oldPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[goods.originalPrice floatValue]];
        
        NSUInteger length = [_oldPriceLabel.text length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_oldPriceLabel.text];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0] range:NSMakeRange(0, length)];
        [_oldPriceLabel setAttributedText:attri];
    }
    else
    {
        _oldPriceLabel.text = @"";
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"x%@",goods.productNum];
}

- (void)setupUI
{
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"placeholderImage"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(imageView.height);
    }];
    self.imageView = imageView;
    
    //商品名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.numberOfLines = 2;
    nameLabel.text = @"这里展示的是商品的名称一行显示不够折行展示巧克力西红柿500g";
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(imageView.right).offset(8);
        make.top.right.equalTo(self);
    }];
    self.nameLabel = nameLabel;
    
    //规格
    UILabel* sizeLabel = [[UILabel alloc]init];
    sizeLabel.text = @"规格：500g";
    sizeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    sizeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self addSubview:sizeLabel];
    [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.bottom).offset(2);
    }];
    self.sizeLabel = sizeLabel;
    
    //价格
    UILabel* priceLabel = [[UILabel alloc]init];
    priceLabel.text = @"¥ 19.90";
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    priceLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self);
        make.left.equalTo(nameLabel);
    }];
    self.priceLabel = priceLabel;
    
    
    _oldPriceLabel = [[UILabel alloc] init];
    _oldPriceLabel.text = @"¥ 89.9";
    _oldPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    _oldPriceLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    [self addSubview:_oldPriceLabel];
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.right).offset(6);
        make.bottom.equalTo(self.priceLabel);
    }];
    
    NSUInteger length = [_oldPriceLabel.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_oldPriceLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0] range:NSMakeRange(0, length)];
    [_oldPriceLabel setAttributedText:attri];
    
    
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.text = @"x1";
    _numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _numberLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self.priceLabel);
    }];
    
}
@end
