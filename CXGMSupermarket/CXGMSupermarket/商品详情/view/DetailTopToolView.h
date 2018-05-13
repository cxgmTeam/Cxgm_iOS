//
//  DetailTopToolView.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTopToolView : UIView

@property(nonatomic,strong) UILabel* goodNameLabel;

@property (nonatomic, copy) dispatch_block_t backBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t gotoCartBlock;

@property (nonatomic, copy) void(^scrollCollectionView)(NSInteger section);//联动collectionView
- (void)selectButton:(NSInteger)index;
- (void)setAlphaOfView:(CGFloat)alpha;
@end
