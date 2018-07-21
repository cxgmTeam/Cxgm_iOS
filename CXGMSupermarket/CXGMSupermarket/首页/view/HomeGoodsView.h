//
//  HomeGoodsView.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGoodsView : UIView
@property(nonatomic,copy)void(^showSubCategoryVC)(NSArray *array);
@property(nonatomic,copy)void(^showGoodsDetailVC)(GoodsModel* model);
@property(nonatomic,copy)void(^showBusinessDetailVC)(AdBannarModel* model);
@property(nonatomic,copy)void(^showAdvertiseDetailVC)(AdvertisementModel* model);
@property(nonatomic,copy)void(^showHYNoticeView)(BOOL show);

//主要是刷新 shopCartNum 和 shopCartId
- (void)requestGoodsList;
@end
