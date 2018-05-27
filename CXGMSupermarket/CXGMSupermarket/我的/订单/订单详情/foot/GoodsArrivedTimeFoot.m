//
//  GoodsArrivedTimeFoot.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/27.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsArrivedTimeFoot.h"


@interface GoodsArrivedTimeFoot ()

@end

@implementation GoodsArrivedTimeFoot

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI
{
    
    UIView* whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self);
        make.height.equalTo(45);
    }];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_arrived_time"]];
    [whiteView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(whiteView);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(47, 248, 84, 20);
    label.text = @"预计收货时间";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(whiteView);
        make.left.equalTo(imageView.right).offset(15);
    }];
    
    UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [whiteView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(whiteView);
        make.right.equalTo(-15);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"今天 8:00-9:45";
    _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _timeLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(whiteView);
        make.right.equalTo(arrow.left).offset(-5);
    }];
}
@end
