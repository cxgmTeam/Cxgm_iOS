//
//  AddAddressViewController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterSubViewController.h"

@interface AddAddressViewController : MyCenterSubViewController
@property(nonatomic,strong)AddressModel* address;

@property(nonatomic,strong)LocationModel* selectedLoacation;

@property(nonatomic,assign)BOOL firstAddress;//新增第一个地址置成为默认地址
@end
