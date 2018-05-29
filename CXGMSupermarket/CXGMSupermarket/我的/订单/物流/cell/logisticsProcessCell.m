//
//  logisticsProcessCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/29.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "logisticsProcessCell.h"


@interface logisticsProcessCell ()

@property(nonatomic,strong)UILabel* textLabel;
@property(nonatomic,strong)UILabel* timeLabel;
@end

@implementation logisticsProcessCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"订单已经提交到 菜鲜果美望京西苑店 等待确认";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(25);
        make.left.equalTo(57);
    }];
    _textLabel = label;
    
    
    label = [[UILabel alloc] init];
    label.text = @"2018-09-13     15:32:20";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.textLabel.bottom);
        make.left.equalTo(57);
    }];
    _timeLabel = label;
}
@end
