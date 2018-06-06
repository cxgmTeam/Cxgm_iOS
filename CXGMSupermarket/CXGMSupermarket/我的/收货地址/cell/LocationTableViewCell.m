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

- (void)setLocation:(LocationModel *)location{
    _nameLabel.text = location.name;
    _addressLabel.text = location.address;
    
    
    
    
    
    CLLocation *curLocation = [DeviceHelper sharedInstance].location;
    
    
    NSLog(@"定位  latitude %f  longitude  %f",curLocation.coordinate.latitude,curLocation.coordinate.longitude);
    
    NSLog(@"列表  latitude %f  longitude  %f",location.latitude,location.longitude);
    
    
    
    if (![WGS84TOGCJ02 isLocationOutOfChina:[curLocation coordinate]]) {
        //转换后的coord
        
        CLLocationCoordinate2D tempCoords = CLLocationCoordinate2DMake(location.latitude,location.longitude);
        
        CLLocationCoordinate2D coords = [WGS84TOGCJ02 transformFromWGSToGCJ:tempCoords];
        
        CLLocationCoordinate2D curCoord = [WGS84TOGCJ02 transformFromWGSToGCJ:[curLocation coordinate]];
        
        NSLog(@"定位转换  latitude %f  longitude  %f",curCoord.latitude,curCoord.longitude);
        
        if (curCoord.latitude == coords.latitude && curCoord.longitude == coords.longitude) {
            _locationImage.hidden = NO;
        }else{
            _locationImage.hidden = YES;
        }
    }
    else
    {
        if (curLocation.coordinate.latitude == location.latitude && curLocation.coordinate.longitude == location.longitude) {
            _locationImage.hidden = NO;
        }else{
            _locationImage.hidden = YES;
        }
    }
    
    
    if (location.inScope) {
        _nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _addressLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    }else{
        _nameLabel.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1/1.0];
        _addressLabel.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1/1.0];
    }
}

@end
