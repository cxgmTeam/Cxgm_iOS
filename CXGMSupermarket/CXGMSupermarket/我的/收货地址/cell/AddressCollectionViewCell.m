//
//  AddressCollectionViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/27.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AddressCollectionViewCell.h"

@interface AddressCollectionViewCell ()
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIButton *selectedBtn;
@end

@implementation AddressCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"彭先生";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.top.equalTo(14);
        }];

        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.text = @"186****5120";
        _phoneLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _phoneLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [self addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.nameLabel.right).offset(30);
            make.top.equalTo(self.nameLabel);
        }];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 2;
        _addressLabel.text = @"北京市朝阳区泰和一街博兴路交叉口 南海家园3号院5单元502室";
        _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _addressLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [self addSubview:_addressLabel];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.bottom).offset(6);
            make.width.equalTo(ScreenW-30);
        }];
        
        UIView* line = [UIView new];
        line.backgroundColor = ColorE8E8E8E;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.equalTo(self);
            make.top.equalTo(87);
            make.height.equalTo(1);
        }];
        
        _selectedBtn = [UIButton new];
        [_selectedBtn setImage:[UIImage imageNamed:@"goods_unselect"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
        [self addSubview:_selectedBtn];
        [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(self);
            make.left.equalTo(5);
            make.size.equalTo(CGSizeMake(40, 40));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"设为默认";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.selectedBtn);
            make.left.equalTo(self.selectedBtn.right);
        }];
        
        UIButton* editBtn = [UIButton new];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [editBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [self addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(self);
            make.right.equalTo(-5);
            make.size.equalTo(CGSizeMake(40, 40));
        }];

    }
    return self;
}
@end
