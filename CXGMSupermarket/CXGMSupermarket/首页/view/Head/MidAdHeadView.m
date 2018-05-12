//
//  MidAdHeadView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MidAdHeadView.h"

#define HomeBottomViewGIFImage @"http://gfs8.gomein.net.cn/T1RbW_BmdT1RCvBVdK.gif"


@interface MidAdHeadView ()
/* imageView */
@property (strong , nonatomic)UIImageView *adImageView;
@end

@implementation MidAdHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        
        [self setUpBase];
        
    }
    return self;
}

- (void)setUpUI
{
    
    _adImageView = [[UIImageView alloc] init];
    _adImageView.layer.cornerRadius = 4;
    _adImageView.image = [UIImage imageNamed:@"temp_meat"];
//    [_adImageView sd_setImageWithURL:[NSURL URLWithString:HomeBottomViewGIFImage] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _adImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_adImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (void)setUpBase
{
    self.backgroundColor = [UIColor whiteColor];
}

@end
