//
//  AddAddressViewCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAddressViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView* arrow;
- (void)setHeadTitle:(NSString *)title;

@property(nonatomic,strong)UITextField* textField;
@end
