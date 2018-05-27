//
//  BillHeadViewCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillHeadViewCell : UICollectionViewCell

@property(nonatomic,strong)ReceiptItem* receipt;

@property(nonatomic,strong)UITextField* companyNameTextField;
@property(nonatomic,strong)UITextField* dutyParagraphTextField;

@property(nonatomic,copy)void(^selectReceiptHead)(BOOL isOpen);
@end
