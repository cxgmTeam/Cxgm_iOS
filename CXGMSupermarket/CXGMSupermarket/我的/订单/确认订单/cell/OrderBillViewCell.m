//
//  OrderBillViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/30.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderBillViewCell.h"

@interface OrderBillViewCell ()
@property(nonatomic,strong)UILabel* valueLabel;
@end

@implementation OrderBillViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUP];
    }
    return self;
}

- (void)setupUP
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"发票";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.left.equalTo(15);
    }];
    
//    UIImageView* arrow = [UIImageView new];
//    arrow.image = [UIImage imageNamed:@"arrow_right"];
//    [self addSubview:arrow];
//    [arrow mas_makeConstraints:^(MASConstraintMaker *make){
//        make.right.equalTo(-15);
//        make.centerY.equalTo(self);
//    }];
    
    UIButton* btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-5);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];

    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.text = @"不开发票";
    _valueLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _valueLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(btn.left).offset(-10);
        make.centerY.equalTo(self);
    }];
}

- (void)onTapButton:(id)sender
{
    !_gotoOrderBillPage?:_gotoOrderBillPage();
}
@end
