//
//  DeviceHelper.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DeviceIDKey @"deviceID"

@interface DeviceHelper : NSObject

@property (nonatomic, strong) NSString *deviceID;//设备标识符

+ (instancetype)sharedInstance;
@end
