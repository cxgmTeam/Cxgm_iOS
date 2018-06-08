//
//  LocationTableViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/12.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "LocationTableViewCell.h"
#import "WGS84TOGCJ02.h"

@interface LocationTableViewCell ()
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* addressLabel;

@property(nonatomic,strong)UIImageView* locationImage;
@end

@implementation LocationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"通州北苑";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.top.equalTo(5);
        }];
        _nameLabel = label;
        
        
        label = [[UILabel alloc] init];
        label.text = @"北京市通州区通州北苑通州北苑家园";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.top.equalTo(self.nameLabel.bottom).offset(6);
        }];
        _addressLabel = label;
        
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_pin"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.right.equalTo(-15);
        }];
        _locationImage = imageView;
    }
    return self;
}

- (void)setShowPin:(BOOL)showPin{
    _locationImage.hidden = !showPin;
}

- (void)setLocation:(LocationModel *)location{
    _nameLabel.text = location.name;
    _addressLabel.text = location.address;
    
    if (location.inScope) {
        _nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _addressLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    }else{
        _nameLabel.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1/1.0];
        _addressLabel.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1/1.0];
    }
}

@end
