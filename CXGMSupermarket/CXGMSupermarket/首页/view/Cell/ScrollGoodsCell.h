//
//  ScrollGoodsCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollGoodsCell : UICollectionViewCell
@property(nonatomic,copy)dispatch_block_t showGoodsDetail;
@property(nonatomic,strong)NSArray* goodsList;
@end
