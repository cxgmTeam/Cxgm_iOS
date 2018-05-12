//
//  RemainTimeHintHead.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/29.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "RemainTimeHintHead.h"

@interface RemainTimeHintHead ()
@property(nonatomic,strong)UILabel* timeLabel;
@end

@implementation RemainTimeHintHead

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:254/255.0 green:119/255.0 blue:119/255.0 alpha:1/1.0];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"温馨提示：请您在规定的时间内完成支付";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.left.equalTo(14);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"剩余时间  04:58";
    _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _timeLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.right.equalTo(-14);
    }];
}
@end
