//
//  NoteInfoViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/7/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "NoteInfoViewCell.h"

@interface NoteInfoViewCell ()

@end

@implementation NoteInfoViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"备注信息:";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(15);
            make.width.equalTo(60);
        }];
        
        _textField = [UITextField new];
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textField.placeholder = @"添加备注信息";
        _textField.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(85);
            make.right.equalTo(-5);
            make.height.equalTo(30);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}
@end
