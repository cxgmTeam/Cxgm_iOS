//
//  WGS84TOGCJ02.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/14.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGS84TOGCJ02 : NSObject
//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc; 
@end
