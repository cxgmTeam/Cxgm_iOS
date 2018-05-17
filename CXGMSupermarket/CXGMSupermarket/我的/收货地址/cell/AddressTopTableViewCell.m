//
//  AddressTopTableViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/17.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AddressTopTableViewCell.h"

@interface AddressTopTableViewCell ()

@property(nonatomic,strong)UILabel* leftLabel;
@property(nonatomic,strong)UIButton* anchorBtn;
@property(nonatomic,strong)UIImageView* arrowView;
@property(nonatomic,strong)UIView* lineView;
@end

@implementation AddressTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 2;
        label.text = @"望京西园3号楼广安大厦";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.centerY.equalTo(self);
            make.width.equalTo(ScreenW-15-100);
        }];
        _leftLabel = label;
        
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        [self.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(-15);
            make.centerY.equalTo(self);
        }];
        _arrowView = imgView;
        
        UIButton* button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"location_address"] forState:UIControlStateNormal];
        [button setTitle:@"  重新定位" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [button setTitleColor:[UIColor colorWithRed:58/255.0 green:176/255.0 blue:242/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.right.equalTo(-10);
            make.height.equalTo(40);
            make.width.equalTo(100);
        }];
        _anchorBtn = button;
        
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(1);
            make.left.right.bottom.equalTo(self);
        }];
        _lineView = line;
        
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        NSDictionary* dic = [DeviceHelper sharedInstance].place.addressDictionary;
        _leftLabel.text = dic[@"Street"];
        
        _anchorBtn.hidden = NO;
        _arrowView.hidden = YES;
        _lineView.hidden = NO;
        
    }else{
        
        _leftLabel.text = @"附近地址";
        _anchorBtn.hidden = YES;
        _arrowView.hidden = NO;
        _lineView.hidden = YES;
    }
}

@end
