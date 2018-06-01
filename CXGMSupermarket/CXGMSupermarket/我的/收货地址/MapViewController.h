//
//  MapViewController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterSubViewController.h"
#import "LocationTableViewCell.h"

@interface MapViewController : MyCenterSubViewController

//点击新增地址进入
@property(nonatomic,copy)void(^selectedAddress)(LocationModel *model);

//点击附近地址进入
@property(nonatomic,copy)void(^toAddAddress)(LocationModel *model);

@end
