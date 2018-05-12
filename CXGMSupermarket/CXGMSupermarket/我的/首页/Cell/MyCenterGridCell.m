//
//  MyCenterGridCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterGridCell.h"

@interface MyCenterGridCell ()
@property(nonatomic,strong)UIImageView* imgView;
@property(nonatomic,strong)UILabel* titleLabel;
@end

@implementation MyCenterGridCell

- (void)setImage:(NSString *)imageName title:(NSString *)title{
    _imgView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = title;
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
    _titleLabel.text = @"轻松退";
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_titleLabel];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(12);
        make.centerX.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.imgView.bottom).offset(3);
        make.centerX.equalTo(self);
    }];

}
@end
