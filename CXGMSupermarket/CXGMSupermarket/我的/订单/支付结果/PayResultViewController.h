//
//  PayResultViewController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterSubViewController.h"

@interface PayResultViewController : MyCenterSubViewController
@property(nonatomic,assign)BOOL paySuccess;

@property(nonatomic,strong)NSString* orderAmount;
@property(nonatomic,strong)NSString* orderId;
@end
