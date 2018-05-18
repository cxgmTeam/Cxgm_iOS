//
//  OrderListViewController.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController
@property(nonatomic,assign)NSInteger status;//空 全部  0待支付，1待配送（已支付），2配送中，3已完成，4退货
@end
