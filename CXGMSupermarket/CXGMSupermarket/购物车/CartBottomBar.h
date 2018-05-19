//
//  CartBottomBar.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/19.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartBottomBar : UIView

@property (strong,nonatomic)UIButton *allSellectedButton;
@property (strong,nonatomic)UILabel *totlePriceLabel;
@property (strong,nonatomic)UILabel *preferentialLabel;//优惠
@property (strong,nonatomic)UIButton *checkOutButton;

@end
