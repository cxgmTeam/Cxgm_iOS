//
//  BillReceiverViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "BillReceiverViewCell.h"

@interface BillReceiverViewCell ()
@property(nonatomic,strong)UILabel* phoneLabel;
@end

@implementation BillReceiverViewCell

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
    label.text = @"收票人信息";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.text = @"186****5120";
    _phoneLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _phoneLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_phoneLabel];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(label.right).offset(20);
        make.centerY.equalTo(self);
    }];

}
@end
