//
//  MidAdGoodsViewCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

//ScreenW*159/375.f+212
@interface MidAdGoodsViewCell : UICollectionViewCell

@property(nonatomic,copy)void(^showGoodsDetail)(GoodsModel *model) ;

@property(nonatomic,copy)void(^tapAdImageHandler)(void) ;

@property(nonatomic,strong)AdBannarModel* adBannar;
@end
