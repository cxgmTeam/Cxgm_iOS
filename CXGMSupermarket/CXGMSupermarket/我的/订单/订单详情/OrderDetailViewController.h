//
//  OrderDetailViewController.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterSubViewController.h"
#import "OrderItem.h"

@interface OrderDetailViewController : MyCenterSubViewController
@property(nonatomic,strong)OrderItem* orderItem;
@end
