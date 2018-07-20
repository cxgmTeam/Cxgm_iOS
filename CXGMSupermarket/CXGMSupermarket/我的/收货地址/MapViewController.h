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

@property(nonatomic,assign)BOOL firstAddress;//新增第一个地址置成为默认地址
@end
