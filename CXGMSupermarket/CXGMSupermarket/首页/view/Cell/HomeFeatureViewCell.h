//
//  HomeFeatureViewCell.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/5/9.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeatureItemView : UIView
@property(nonatomic,strong)UILabel* desLabel;
@property(nonatomic,strong)AdvertisementModel* advertisement;
- (void)setImageViewFrame:(BOOL)flag;
@end


@interface HomeFeatureViewCell : UICollectionViewCell

@property(nonatomic,strong)NSArray* motionArray;
@end
