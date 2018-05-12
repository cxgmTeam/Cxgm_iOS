//
//  DetailShowTypeCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DetailShowTypeCell.h"

@interface DetailShowTypeCell ()
@property(nonatomic,strong)UIView* bottomLine;
@end

@implementation DetailShowTypeCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _leftTitleLable = [[UILabel alloc] init];
    _leftTitleLable.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _leftTitleLable.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_leftTitleLable];
    
    _iconImageView = [[UIImageView alloc] init];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:14];;
    [self addSubview:_contentLabel];
    
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_hintLabel];
    
    _indicateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_indicateButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    _isHasindicateButton = YES;
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor colorWithHexString:@"f2f3f4"];
    [self addSubview:_bottomLine];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_leftTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:10];
        make.centerY.mas_equalTo(self);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self.leftTitleLable.right)setOffset:30];
        make.centerY.mas_equalTo(self);
    }];
    
    if (_isHasindicateButton) {
        [self addSubview:_indicateButton];
        [_indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(self)setOffset:-10];
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.centerY.mas_equalTo(self);
        }];
    }
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}
@end
