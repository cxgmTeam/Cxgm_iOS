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

@property(nonatomic,copy)void(^selectedAddress)(LocationModel *model);

@end
