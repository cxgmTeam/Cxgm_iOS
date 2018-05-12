//
//  DetailShowTypeCell.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailShowTypeCell : UICollectionViewCell
/** 是否有指示箭头 */
@property (nonatomic,assign)BOOL isHasindicateButton;
/* 指示按钮 */
@property (strong , nonatomic)UIButton *indicateButton;
/* 标题 */
@property (strong , nonatomic)UILabel *leftTitleLable;
/* 图片 */
@property (strong , nonatomic)UIImageView *iconImageView;
/* 内容 */
@property (strong , nonatomic)UILabel *contentLabel;
/* 提示 */
@property (strong , nonatomic)UILabel *hintLabel;
@end
