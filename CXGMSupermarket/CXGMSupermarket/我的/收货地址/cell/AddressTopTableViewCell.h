//
//  AddressTopTableViewCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/17.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTopTableViewCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath* indexPath;

@property(nonatomic,strong)UILabel* leftLabel;

@property(nonatomic,copy)dispatch_block_t relocationHandler;
@end
