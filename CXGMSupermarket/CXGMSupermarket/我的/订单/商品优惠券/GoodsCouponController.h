//
//  GoodsCouponController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/21.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterSubViewController.h"

@interface GoodsCouponController : MyCenterSubViewController

@property (strong , nonatomic)NSArray *listArray;

@property (copy , nonatomic)void(^selectCoupon)(CouponsModel * model);
@end
