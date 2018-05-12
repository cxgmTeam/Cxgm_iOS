//
//  GoodsTableHead.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/17.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsTableHead.h"

@implementation GoodsTableHead

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        UIView* bgView = [UIView new];
        bgView.backgroundColor = [UIColor colorWithHexString:@"FAFBFA"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.equalTo(10);
            make.right.bottom.equalTo(self);
        }];
        
        _contentLabel = [UILabel new];
        _contentLabel.textColor = Color666666;
        _contentLabel.font = PFR13Font;
        _contentLabel.text = @"吃青菜";
        [bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.centerY.equalTo(bgView);
        }];
    }
    return self;
}

@end
