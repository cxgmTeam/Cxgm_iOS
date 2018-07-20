//
//  TopLineFootView.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopLineFootView : UICollectionReusableView
@property(nonatomic,strong)NSArray* roTitles;

@property(nonatomic,copy)void(^showReportDetail)(NSInteger index);
@end
