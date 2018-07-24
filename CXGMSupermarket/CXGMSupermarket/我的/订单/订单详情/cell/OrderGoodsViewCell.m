//
//  OrderGoodsViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/27.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderGoodsViewCell.h"

@interface OrderGoodsViewCell ()
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

@implementation OrderGoodsViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

- (void)setGoods:(GoodsModel *)goods
{
    _goods = goods;
    
    if (goods.imageUrl.length >0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:goods.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }else if (goods.productUrl.length > 0){
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:goods.productUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    
    if (goods.goodName.length > 0) {
        self.nameLabel.text = goods.goodName;
    }else{
        self.nameLabel.text = goods.productName;
    }
    
    NSLog(@"%s   %@",__func__,goods.weight);
    
    if ([goods.specifications length] == 0)
    {
        if ([goods.weight length] > 0 && [goods.unit length] > 0)
        {
            if (![goods.weight isEqualToString:goods.unit])
            {
                if ([goods.unit isEqualToString:@"kg"] || [goods.unit isEqualToString:@"Kg"] || [goods.unit isEqualToString:@"KG"]) {
                    
                    self.sizeLabel.text = [NSString stringWithFormat:@"规格：%@%@",goods.weight.length>0?goods.weight:@"0.0",goods.unit];
                }else{
                    self.sizeLabel.text = [NSString stringWithFormat:@"规格：%@/%@",goods.weight.length>0?goods.weight:@"0.0",goods.unit];
                }
                
            }else{
                self.sizeLabel.text = [NSString stringWithFormat:@"规格：%@",goods.weight];
            }
        }
        else if ([self.goods.weight length] > 0 ){
            self.sizeLabel.text = [NSString stringWithFormat:@"规格：%@",goods.weight];
        }
        else if ([self.goods.unit length] > 0 ){
            self.sizeLabel.text = [NSString stringWithFormat:@"规格：%@",goods.unit];
        }
        else{
            self.sizeLabel.text = @" ";
        }
    }else{
        self.sizeLabel.text = [NSString stringWithFormat:@"规格：%@",goods.specifications];
    }
    
    
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
    
    if (goods.goodNum.length > 0) {
        self.numberLabel.text = [NSString stringWithFormat:@"x%@",goods.goodNum];
    }else{
        self.numberLabel.text = [NSString stringWithFormat:@"x%@",goods.productNum];
    }
    
}

- (void)setupUI
{
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self);
        make.height.equalTo(1);
    }];
    
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"placeholderImage"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(78, 56));
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
        make.left.equalTo(imageView.right).offset(16);
        make.top.equalTo(14);
        make.width.equalTo(ScreenW-111-54);
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
        make.top.equalTo(sizeLabel.bottom).offset(2);
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
        make.right.equalTo(-15);
        make.bottom.equalTo(self.priceLabel);
    }];
    
}

@end
