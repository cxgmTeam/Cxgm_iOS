//
//  ShippingModeCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/9/25.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ShippingModeCell : UICollectionViewCell
@property(nonatomic,copy)void(^selectShippingMode)(NSString *mode);
@end


