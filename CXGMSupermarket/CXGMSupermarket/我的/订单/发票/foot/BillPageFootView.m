//
//  BillPageFootView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "BillPageFootView.h"

@implementation BillPageFootView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"温馨提示：";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.top.equalTo(15);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.numberOfLines = 0;
        label1.text = @"1、展示提示内容区域展示提示内容区域展示提示内容区域展示提示内容区域展示提示内容区域展示提示内容\n2、展示提示内容区域展示提示内容区域展示提示";
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label1.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [self addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.width.equalTo(ScreenW-30);
            make.top.equalTo(label.bottom).offset(10);
        }];
        
        UIButton* button = [UIButton new];
        button.layer.cornerRadius = 4;
        button.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(self);
            make.height.equalTo(42);
            make.left.equalTo(15);
            make.right.equalTo(-15);
        }];
    }
    return self;
}
@end
