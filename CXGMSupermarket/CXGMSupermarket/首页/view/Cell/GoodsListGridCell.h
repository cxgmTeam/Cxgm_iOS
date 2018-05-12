//
//  GoodsListGridCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsListGridCell : UICollectionViewCell
@property(nonatomic,assign)BOOL showOldPrice;
@property(nonatomic,strong)GoodsModel* goodsModel;
@end
