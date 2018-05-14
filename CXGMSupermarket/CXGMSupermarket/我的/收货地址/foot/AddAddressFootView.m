//
//  AddAddressFootView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AddAddressFootView.h"

@implementation AddAddressFootView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIButton* button = [UIButton new];
        button.layer.cornerRadius = 4;
        button.backgroundColor = Color00A862;
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [self addSubview:button];
        [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.size.equalTo(CGSizeMake(ScreenW-30, 42));
            make.left.equalTo(15);
            make.top.equalTo(20);
        }];
    }
    return self;
}

- (void)onTapButton:(id)sender
{
    !_saveUserAddress?:_saveUserAddress();
}
@end
