//
//  NoAddressTableCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/6/1.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "NoAddressTableCell.h"

@implementation NoAddressTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"您还没有设置收货地址～";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(15);
        }];
    }
    return self;
}


@end
