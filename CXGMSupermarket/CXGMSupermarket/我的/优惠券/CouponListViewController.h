//
//  CouponListViewController.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponListViewController : UIViewController
@property(nonatomic,assign)BOOL isExpire;//过期

@property(nonatomic,weak)id delegate;
@end
