//
//  DetailImagesFooterView.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DetailImagesFooterView.h"

@interface DetailImagesFooterView ()
@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation DetailImagesFooterView

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
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://gfs1.gomein.net.cn/T1Ro_vBmbv1RCvBVdK.jpg"]];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self);
//    }];
//}
@end
