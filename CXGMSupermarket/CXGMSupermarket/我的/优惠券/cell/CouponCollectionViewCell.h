//
//  CouponCollectionViewCell.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponItem.h"

@interface CouponCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) CouponItem *couponItem;
@property (nonatomic, copy) dispatch_block_t expandClick;
@end
