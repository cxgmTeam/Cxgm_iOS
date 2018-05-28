//
//  InvitationTableHead.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/28.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "InvitationTableHead.h"

@implementation InvitationTableHead

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"好友手机号";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:131/255.0 green:108/255.0 blue:80/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.centerY.equalTo(self);
            make.width.equalTo((ScreenW-30)/3.f);
        }];
        
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"获得时间";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:131/255.0 green:108/255.0 blue:80/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(self);
            make.width.equalTo((ScreenW-30)/3.f);
        }];
        
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"是否得到红包";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:131/255.0 green:108/255.0 blue:80/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.right.equalTo(self);
            make.width.equalTo((ScreenW-30)/3.f);
        }];
        
    }
    return self;
}

@end
