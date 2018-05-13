//
//  HomeGoodsView.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGoodsView : UIView
@property(nonatomic,copy)dispatch_block_t showSubCategoryVC;
@property(nonatomic,copy)void(^showGoodsDetailVC)(GoodsModel* model);
@end
