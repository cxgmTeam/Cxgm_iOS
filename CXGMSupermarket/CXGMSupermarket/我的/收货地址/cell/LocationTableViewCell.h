//
//  LocationTableViewCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/12.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell

@property(nonatomic,strong)LocationModel* location;

@property(nonatomic,assign)BOOL showPin;
@end
