//
//  SettingTableViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/12.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell ()

@end

@implementation SettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"开启通知";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.left.equalTo(15);
    }];
    _leftLabel = label;
    
    
    label = [[UILabel alloc] init];
    label.text = @"v1.0";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.right.equalTo(-15);
    }];
    _rightLabel = label;
    
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-15);
        make.centerY.equalTo(self);
    }];
    _arrowView = imgView;
    
    UISwitch* btn = [UISwitch new];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(50, 20));
        make.right.equalTo(-15);
        make.top.equalTo(7);
    }];
    _switchButton = btn;
    [_switchButton setOn: YES];

}
@end
