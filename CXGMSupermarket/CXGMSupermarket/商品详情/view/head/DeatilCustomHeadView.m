//
//  DeatilCustomHeadView.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DeatilCustomHeadView.h"

@interface DeatilCustomHeadView ()
/* 顶部View */
@property (strong , nonatomic)UIView *topView;

@end

@implementation DeatilCustomHeadView
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
    
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor colorWithHexString:@"f2f3f4"];
    [self addSubview:_topView];
    
    
    _guessMarkLabel = [[UILabel alloc] init];
    _guessMarkLabel.text = @"猜你喜欢";
    _guessMarkLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_guessMarkLabel];
    
    
    UIView* bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"f2f3f4"];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [_guessMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
}

@end
