//
//  AddressViewController.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterSubViewController.h"

@interface AddressViewController : MyCenterSubViewController

@property(nonatomic,assign)BOOL selectAddress;

@property(nonatomic,copy)void(^selectedAddress)(AddressModel* address);

@end
