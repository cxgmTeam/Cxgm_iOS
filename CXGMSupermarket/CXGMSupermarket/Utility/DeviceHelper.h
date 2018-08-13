//
//  DeviceHelper.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define DeviceIDKey @"deviceID"

@interface DeviceHelper : NSObject

@property (nonatomic, strong) NSString *deviceID;//设备标识符

@property (nonatomic, strong) CLLocation *location;//用户定位地址

@property (nonatomic, strong) CLPlacemark *place;//用户定位含有店铺的地址 

@property (nonatomic, strong) AddressModel *defaultAddress;//用户的默认地址 也可能是地址列表中的第一个

@property (nonatomic, strong) ShopModel *shop;//所选店铺的

@property (nonatomic, strong) NSString * homeAddress;//首页显示是的送货地址

@property (nonatomic, assign) BOOL locationInScope ;//定位是否在派送范围内

@property (nonatomic, assign) BOOL showWineCategory ;//去掉列表中的"中外名酒"分类  NO是不显示 YES是显示

+ (instancetype)sharedInstance;

@end
