//
//  AddressHeadView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/14.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AddressHeadView.h"

@implementation AddressHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"当前定位";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(15);
        }];
        _titleLabel = label;
    }
    return self;
}
@end
