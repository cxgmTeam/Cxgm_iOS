//
//  MessageTableViewCell.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* descLabel;
@property(nonatomic,strong)UILabel* timeLabel;
@end
