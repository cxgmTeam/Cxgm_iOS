//
//  CouponCollectionViewCell.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CouponCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) CouponsModel *coupons;
@property (nonatomic, copy) dispatch_block_t expandClick;

+ (CGFloat)heightForCell:(CouponsModel *)coupons;
@end
