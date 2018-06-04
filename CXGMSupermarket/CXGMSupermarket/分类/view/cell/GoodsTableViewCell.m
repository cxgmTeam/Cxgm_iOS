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

- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:goodsModel.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    _nameLabel.text = goodsModel.name;
    _desLabel.text = @"";
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[goodsModel.price floatValue]];
    
//    if ([goodsModel.price floatValue] != [goodsModel.originalPrice floatValue] && [goodsModel.originalPrice floatValue] > 0)
//    {
//        _oldPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.originalPrice floatValue]];
//        
//        NSUInteger length = [_oldPriceLabel.text length];
//        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_oldPriceLabel.text];
//        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
//        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0] range:NSMakeRange(0, length)];
//        [_oldPriceLabel setAttributedText:attri];
//    }
//    else
//    {
//        _oldPriceLabel.text = @"";
//    }
    
}

- (void)onTapAddBtn:(UIButton *)button
{
    if (![UserInfoManager sharedInstance].isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        return;
    }
    
    if (!self.goodsModel) return;
    
    if ([self.goodsModel.shopCartNum intValue] > 0) {
        [self updateCart:self.goodsModel];
    }else{
        [self addCart:self.goodsModel];
    }
}



- (void)addCart:(GoodsModel *)goods
{
    NSDictionary* dic = @{@"amount":goods.price.length>0?goods.price:@"",
                          @"goodCode":goods.goodCode.length>0?goods.goodCode:@"",
                          @"goodName":goods.name.length>0?goods.name:@"",
                          @"goodNum":@"1",
                          @"categoryId":goods.productCategoryId.length>0?goods.productCategoryId:@"",
                          @"shopId":goods.shopId.length>0?goods.shopId:@"",
                          @"productId":goods.id.length>0?goods.id:@""
                          };
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIShopAddCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
                [MBProgressHUD MBProgressHUDWithView:controller.view Str:@"添加成功！"];
                
                self.goodsModel.shopCartNum = [NSString stringWithFormat:@"%d",[self.goodsModel.shopCartNum intValue]+1];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:AddGoodsSuccess_Notify object:nil];
            });
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)updateCart:(GoodsModel *)goods
{
    CGFloat amount = (1+[goods.shopCartNum integerValue])*[goods.price floatValue];
    
    NSDictionary* dic = @{@"id":goods.shopCartId.length>0?goods.shopCartId:@"",
                          @"amount":[NSString stringWithFormat:@"%.2f",amount],
                          @"goodCode":goods.goodCode.length>0?goods.goodCode:@"",
                          @"goodName":goods.name.length>0?goods.name:@"",
                          @"goodNum":[NSString stringWithFormat:@"%d",1+[goods.shopCartNum intValue]],
                          @"categoryId":goods.productCategoryId.length>0?goods.productCategoryId:@"",
                          @"shopId":goods.shopId.length>0?goods.shopId:@""
                          };
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIUpdateCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
                [MBProgressHUD MBProgressHUDWithView:controller.view Str:@"添加成功！"];
                
                self.goodsModel.shopCartNum = [NSString stringWithFormat:@"%d",[self.goodsModel.shopCartNum intValue]+1];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:AddGoodsSuccess_Notify object:nil];
            });
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}


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
        [_addBtn addTarget:self action:@selector(onTapAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView* line = [UIView new];
        line.backgroundColor = ColorE8E8E8E;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker* make){
            make.right.bottom.equalTo(self);
            make.left.equalTo(10);
            make.height.equalTo(1);
        }];
        

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
