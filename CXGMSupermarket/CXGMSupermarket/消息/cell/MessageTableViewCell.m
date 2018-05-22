//
//  MessageTableViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MessageTableViewCell.h"



@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _iconView = [UIImageView new];
    [self addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self);
        make.left.equalTo(12);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"限时抢购";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.iconView.right).offset(10);
        make.top.equalTo(10);
    }];
    _titleLabel = label;
    
    label = [[UILabel alloc] init];
    label.text = @"这里展示内容区域这里展示内容区域这里展示...";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.iconView.right).offset(10);
        make.bottom.equalTo(-10);
    }];
    _descLabel = label;
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.iconView.right).offset(10);
        make.height.equalTo(1);
        make.bottom.right.equalTo(self);
    }];
    
    label = [[UILabel alloc] init];
    label.text = @"11:30";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(14);
        make.right.equalTo(-15);
    }];
    _timeLabel = label;
    
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_clock"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(15);
        make.right.equalTo(self.timeLabel.left).offset(-5);
    }];
    
}
@end
