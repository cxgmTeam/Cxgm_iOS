//
//  AddressViewController.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterSubViewController.h"

@interface AddressViewController : MyCenterSubViewController

@property(nonatomic,assign)BOOL chooseAddress;//提交订单的时候需要选择地址
@property(strong,nonatomic) NSMutableArray * pointsArr;//查询到的范围点集

@property(nonatomic,copy)void(^selectedAddress)(AddressModel* address);

@property(nonatomic,assign)BOOL needNewAddress;//需要添加新地址，寻找店铺
@end
