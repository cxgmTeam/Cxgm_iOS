//
//  AddressTableViewCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/17.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

@property(nonatomic,strong)AddressModel* address;

@property(nonatomic,copy)dispatch_block_t updateAddress;
@property(nonatomic,copy)dispatch_block_t deleteAddress;

@property(nonatomic,copy)void(^setDefaultAddress)(BOOL isDefault);

@property(nonatomic,assign)BOOL isInScope;

@end
