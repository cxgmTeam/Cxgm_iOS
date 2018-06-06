//
//  PaymentViewController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterSubViewController.h"

@interface PaymentViewController : MyCenterSubViewController
@property(nonatomic,strong)OrderModel* order;

//从确认订单传递过来的参数
@property(nonatomic,strong)NSString* orderAmount;
@property(nonatomic,strong)NSString* orderId;
@end
