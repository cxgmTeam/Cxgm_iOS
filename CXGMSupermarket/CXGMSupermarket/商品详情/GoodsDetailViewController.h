//
//  GoodsDetailViewController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CustomDetailViewController.h"

@interface GoodsDetailViewController : CustomDetailViewController
@property(nonatomic,strong)NSString* goodsId;
@property(nonatomic,strong)NSString* shopId;

@property(nonatomic,assign)BOOL fromShopCart;//是否点击的购物车
@end
