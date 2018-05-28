//
//  InvitationTableCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/28.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "InvitationTableCell.h"


@interface InvitationTableCell ()
@property(nonatomic,strong)UILabel* phoneLabel;
@property(nonatomic,strong)UILabel* dateLabel;
@end

@implementation InvitationTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"186****5120";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [UIColor colorWithRed:147/255.0 green:128/255.0 blue:98/255.0 alpha:1/1.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(12);
            make.left.equalTo(self);
            make.width.equalTo((ScreenW-30)/3.f);
        }];
        self.phoneLabel = label;
        
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"2018-03-12";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [UIColor colorWithRed:147/255.0 green:128/255.0 blue:98/255.0 alpha:1/1.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(12);
            make.left.equalTo(self.phoneLabel.right);
            make.width.equalTo((ScreenW-30)/3.f);
        }];
        self.dateLabel = label;
        
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"已得到";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [UIColor colorWithRed:147/255.0 green:128/255.0 blue:98/255.0 alpha:1/1.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(12);
            make.left.equalTo(self.dateLabel.right);
            make.width.equalTo((ScreenW-30)/3.f);
        }];
    }
    return self;
}

@end
