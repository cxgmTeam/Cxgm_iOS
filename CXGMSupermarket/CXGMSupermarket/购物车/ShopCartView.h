//
//  ShopCartView.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/19.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartView : UIView

//点击右上角的删除按钮调用
- (void)deleteSelectedGoods;

- (void)retsetSelectedStatus;

@property(nonatomic,copy)void(^gotoConfirmOrder)(NSArray* array) ;

@property(nonatomic,copy)void(^gotoGoodsDetail)(LZCartModel* model) ;
@end
