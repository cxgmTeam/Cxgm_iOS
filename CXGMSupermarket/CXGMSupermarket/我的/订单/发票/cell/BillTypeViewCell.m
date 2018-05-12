//
//  BillTypeViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "BillTypeViewCell.h"
#import "BillCustomButton.h"

@implementation BillTypeViewCell

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
    label.text = @"发票类型";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(12);
        make.left.equalTo(15);
    }];
    
    BillCustomButton* commonBtn = [[BillCustomButton alloc] initWithFrame:CGRectZero withTitle:@"普通发票"];
    [self addSubview:commonBtn];
    [commonBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.bottom.equalTo(-15);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    
    BillCustomButton* electronicBtn = [[BillCustomButton alloc] initWithFrame:CGRectZero withTitle:@"电子发票"];
    [self addSubview:electronicBtn];
    [electronicBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(commonBtn.right).offset(10);
        make.bottom.equalTo(-15);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    electronicBtn.selected = YES;
}
@end
