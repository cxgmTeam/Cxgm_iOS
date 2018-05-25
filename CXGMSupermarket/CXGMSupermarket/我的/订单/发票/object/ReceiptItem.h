//
//  ReceiptItem.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptItem : NSObject

@property(nonatomic,strong)NSString* companyName;//公司名称
@property(nonatomic,strong)NSString* dutyParagraph;//公司税号

@property(nonatomic,strong)NSString* phone;
@property(nonatomic,strong)NSString* type;// 0 普通  1 电子

@property(nonatomic,assign)BOOL isOpen; //发票抬头部分是否展开

@end
