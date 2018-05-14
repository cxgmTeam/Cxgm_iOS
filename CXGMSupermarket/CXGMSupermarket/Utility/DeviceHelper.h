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
@property (nonatomic, strong) CLPlacemark *place;//用户定位地址

@property (nonatomic, strong) ShopModel *shop;//所选店铺的

+ (instancetype)sharedInstance;
@end
