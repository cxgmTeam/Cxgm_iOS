//
//  CatoryGridViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/21.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CatoryGridViewCell.h"

@interface CatoryGridViewCell ()
@property(nonatomic,strong)UIImageView* imgView;
@property(nonatomic,strong)UILabel* titleLabel;
@end


@implementation CatoryGridViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = PFR15Font;
    _titleLabel.textColor = Color333333;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"生鲜";
    [self addSubview:_titleLabel];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(90, 70));
        make.top.centerX.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.imgView.bottom).offset(3);
        make.centerX.equalTo(self);
    }];
}

- (void)setImage:(NSString *)imgName title:(NSString *)title{
    _imgView.image = [UIImage imageNamed:imgName];
    _titleLabel.text = title;
}
@end
