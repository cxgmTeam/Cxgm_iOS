//
//  SelectTimeController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeItem : NSObject
@property(nonatomic,strong)NSString* title;
@property(nonatomic,assign)BOOL selected;
@end

@interface LeftTableCell : UITableViewCell

@property(nonatomic,strong)UILabel* dayLabel;
@end

@interface RightTabelCell : UITableViewCell
@property(nonatomic,strong)TimeItem* timeItem;
@end

@interface SelectTimeController : UIViewController

@property (assign , nonatomic)BOOL isToday;
@property (strong , nonatomic)NSArray * dataArray;

@property(nonatomic,copy)void(^selectedTimeFinish)(NSString *time);
@end
