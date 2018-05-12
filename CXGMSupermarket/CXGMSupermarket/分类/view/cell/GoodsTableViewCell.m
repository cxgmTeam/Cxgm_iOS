//
//  GoodsTableViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/17.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsTableViewCell.h"

@interface GoodsTableViewCell ()
@property(nonatomic,strong)UIImageView* iconView; //图片
@property(nonatomic,strong)UILabel* nameLabel;    //名字
@property(nonatomic,strong)UILabel* desLabel;     //描述
@property(nonatomic,strong)UILabel* countLabel;   //数量
@property(nonatomic,strong)UILabel* priceLabel;   //价格
@property(nonatomic,strong)UILabel* oldPriceLabel;//旧价格
@property(nonatomic,strong)UIButton* addBtn;      //添加按钮
@end

@implementation GoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconView = [UIImageView new];
        [self.contentView addSubview:_iconView];
        
        _nameLabel = [UILabel new];
        _nameLabel.text = @"禧美 无黑头加拿大北极虾 500g";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [self.contentView addSubview:_nameLabel];
        
        _desLabel = [UILabel new];
        _desLabel.text = @"副标题小子显示，只展示一行…";
        _desLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _desLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [self.contentView addSubview:_desLabel];
        
        
        _priceLabel = [UILabel new];
        _priceLabel.text = @"¥ 49.9";
        _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _priceLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [self.contentView addSubview:_priceLabel];
        
        
        _addBtn = [UIButton new];
        [_addBtn setImage:[UIImage imageNamed:@"add_goods"] forState:UIControlStateNormal];
        [self.contentView addSubview:_addBtn];
        
        UIView* line = [UIView new];
        line.backgroundColor = ColorE8E8E8E;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker* make){
            make.right.bottom.equalTo(self);
            make.left.equalTo(10);
            make.height.equalTo(1);
        }];
        
        _iconView.image = [UIImage imageNamed:@"category0"];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(14);
            make.top.equalTo(10);
            make.size.equalTo(CGSizeMake(69, 69));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.iconView);
            make.left.equalTo(self.iconView.right).offset(8);
            make.right.equalTo(-10);
        }];
        
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.nameLabel.bottom).offset(2);
            make.left.right.equalTo(self.nameLabel);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(-10);
            make.left.equalTo(self.nameLabel);
        }];
        
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.size.equalTo(CGSizeMake(40, 40));
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
    }
    return self;
}

@end
