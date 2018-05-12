//
//  MyCenterCollectionCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterCollectionCell.h"

@interface MyCenterCollectionCell ()
@property(nonatomic,strong)UIImageView* imgView;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* subTitleLabel;
@end

@implementation MyCenterCollectionCell

- (void)setImage:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle{
    _imgView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = title;
    _subTitleLabel.text = subTitle;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _imgView = [UIImageView new];
    [self addSubview:_imgView];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"邀请有礼";
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.text = @"新鲜生鲜水果邀请好友共享！";
    _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _subTitleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self addSubview:_subTitleLabel];
    
    UIImageView* arrow = [UIImageView new];
    arrow.image = [UIImage imageNamed:@"arrow_right"];
    [self addSubview:arrow];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(13);
        make.centerY.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.imgView.right).offset(8);
        make.centerY.equalTo(self);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.titleLabel.right).offset(10);
        make.centerY.equalTo(self);
    }];
    
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-10);
        make.centerY.equalTo(self);
    }];
}
@end
