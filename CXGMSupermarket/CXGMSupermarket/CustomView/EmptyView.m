//
//  EmptyView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/7/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "EmptyView.h"



@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"custom_empty"]];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(0);
            make.centerX.equalTo(self);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"这里空空如也哦~";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.imageView.bottom).offset(10);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}

@end
