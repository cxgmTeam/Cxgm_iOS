//
//  SelectSpecificationController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSpecificationController : UIViewController

@property(nonatomic,strong)GoodsModel* goods;

@property(nonatomic,copy)void(^selectFinished)(NSInteger number);
@end
