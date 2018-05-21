//
//  CartBottomBar.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/19.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CartBottomBar.h"

@interface CartBottomBar ()



@end

@implementation CartBottomBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, ScreenW, 1);
    lineView.backgroundColor = ColorE8E8E8E;
    [self addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    selectAll.frame = CGRectMake(7, 5, 80,  40);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"goods_unselect"] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
    [selectAll setTitleColor: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [self addSubview:selectAll];
    self.allSellectedButton = selectAll;

    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    btn.frame = CGRectMake(ScreenW - 118, 0, 118, 50);
    [btn setTitle:@"去结算(3)" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self addSubview:btn];
    self.checkOutButton = btn;
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.text = @"合计：¥0.0";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(5);
        make.left.equalTo(80);
    }];
    self.totlePriceLabel = label;
    
    //优惠
    label = [[UILabel alloc]init];
    label.text = @"总额：¥0.00   优惠：¥0.00  ";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(-5);
        make.left.equalTo(80);
    }];
    self.preferentialLabel = label;
}

@end
