//
//  CartBadgeView.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/31.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartBadgeDelegate <NSObject>
// 代理的方法，在此方法内，完成按钮的点击事件。
- (void)shopCarButtonClickAction;
@end

@interface CartBadgeView : UIView
@property (nonatomic, assign)id<CartBadgeDelegate> delegate;
// 为购物车设置角标内数值
- (void)setShopCarCount:(NSString *)count;
@end
