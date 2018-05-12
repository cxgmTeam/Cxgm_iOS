//
//  MyCenterHeadView.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCenterHeadView : UICollectionReusableView
@property(nonatomic,copy)dispatch_block_t loginHander;
- (void)refreshUI;
@end
