//
//  CartEmptyTableCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/19.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CartEmptyTableCell.h"

@implementation CartEmptyTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIButton* button = [UIButton new];
    button.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [button setTitle:@"去逛逛" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:button];
    [button addTarget:self action:@selector(gotoWindowShopping:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(120, 42));
        make.center.equalTo(self);
    }];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车空空如也～";
    warnLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    warnLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self addSubview:warnLabel];
    [warnLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(button.top).offset(-24);
        make.centerX.equalTo(self);
    }];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_cart"]];
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(warnLabel.top).offset(-18);
        make.centerX.equalTo(self);
    }];
}

- (void)gotoWindowShopping:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:WindowHomePage_Notify object:nil];
}

@end
