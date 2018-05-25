//
//  BillTypeViewCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTypeViewCell : UICollectionViewCell

@property(nonatomic,copy)void(^selectReceiptType)(NSString *type);
@end
