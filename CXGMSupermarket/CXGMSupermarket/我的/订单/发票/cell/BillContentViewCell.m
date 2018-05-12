//
//  BillContentViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "BillContentViewCell.h"
#import "BillCustomButton.h"

@implementation BillContentViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"发票内容";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    BillCustomButton* commonBtn = [[BillCustomButton alloc] initWithFrame:CGRectZero withTitle:@"商品明细"];
    [self addSubview:commonBtn];
    [commonBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(label.right).offset(10);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    commonBtn.selected = YES;
}
@end
