//
//  AddressTableViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/17.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell ()

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIButton *selectedBtn;

@end

@implementation AddressTableViewCell

- (void)setAddress:(AddressModel *)address{
    _nameLabel.text = address.realName;
    
    if ([address.phone length] == 11) {
        _phoneLabel.text = [Utility phoneNumToAsterisk:address.phone];
    }else{
        _phoneLabel.text = address.phone;
    }
    
    _addressLabel.text = [address.area stringByAppendingString:address.address];
    _selectedBtn.selected = [address.isDef boolValue];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView* whiteView = [UIView new];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 10, 0));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"彭先生";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [whiteView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.top.equalTo(14);
        }];
        
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.text = @"186****5120";
        _phoneLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _phoneLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [whiteView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.nameLabel.right).offset(30);
            make.top.equalTo(self.nameLabel);
        }];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 2;
        _addressLabel.text = @"北京市朝阳区泰和一街博兴路交叉口 南海家园3号院5单元502室";
        _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _addressLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [whiteView addSubview:_addressLabel];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.bottom).offset(6);
            make.width.equalTo(ScreenW-30);
        }];
        
        UIView* line = [UIView new];
        line.backgroundColor = ColorE8E8E8E;
        [whiteView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.equalTo(self);
            make.top.equalTo(87);
            make.height.equalTo(1);
        }];
        
        _selectedBtn = [UIButton new];
        [_selectedBtn setImage:[UIImage imageNamed:@"goods_unselect"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
        [whiteView addSubview:_selectedBtn];
        [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(whiteView);
            make.left.equalTo(5);
            make.size.equalTo(CGSizeMake(40, 40));
        }];
        [_selectedBtn addTarget:self action:@selector(onTapSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"设为默认";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [whiteView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.selectedBtn);
            make.left.equalTo(self.selectedBtn.right);
        }];
        
        UIButton* deleteBtn = [UIButton new];
        [deleteBtn setTitle:@" 删除" forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"address_delete"] forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [deleteBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [whiteView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(whiteView);
            make.right.equalTo(-10);
            make.size.equalTo(CGSizeMake(50, 40));
        }];
        [deleteBtn addTarget:self action:@selector(onTapDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];

        
        UIButton* editBtn = [UIButton new];
        [editBtn setTitle:@" 编辑" forState:UIControlStateNormal];
        [editBtn setImage:[UIImage imageNamed:@"address_edit"] forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [editBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [whiteView addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(whiteView);
            make.right.equalTo(deleteBtn.left).offset(-10);
            make.size.equalTo(CGSizeMake(50, 40));
        }];
        [editBtn addTarget:self action:@selector(onTapEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)onTapSelectBtn:(id)sender
{
    _selectedBtn.selected = !_selectedBtn.selected;
    
    !_setDefaultAddress?:_setDefaultAddress(_selectedBtn.selected);
}

- (void)onTapDeleteBtn:(id)sender
{
    !_deleteAddress?:_deleteAddress();
}

- (void)onTapEditBtn:(id)sender
{
    !_updateAddress?:_updateAddress();
}

@end
