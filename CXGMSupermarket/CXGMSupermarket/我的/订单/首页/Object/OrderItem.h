//
//  OrderItem.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OrderType) {
    ForShipping = 0,      //待配送      申请退货
    InShipping = 1,       //配送中      申请退货
    Finished = 2,         //完成        申请退货
    TimeoutCancel = 3,    //超时取消     再次购买
    ForPayment = 4,       //待付款      去支付
    Returning = 5,        //退货中      不显示按钮
    Returned = 6,         //已退货      不显示按钮
};

@interface OrderItem : NSObject
@property(nonatomic,assign)OrderType orderType;
@end
