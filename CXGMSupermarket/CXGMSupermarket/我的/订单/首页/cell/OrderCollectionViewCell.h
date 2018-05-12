//
//  OrderCollectionViewCell.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"

@interface OrderCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)OrderItem* orderItem;

@property(nonatomic,copy)dispatch_block_t tapBuyButton;;
@end
