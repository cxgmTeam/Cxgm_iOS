//
//  PaymentButton.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/23.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentButton : UIControl

@property(nonatomic,strong)UIImageView* markView;

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image title:(NSString *)title;

@end

