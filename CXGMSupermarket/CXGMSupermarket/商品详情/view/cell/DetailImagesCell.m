//
//  DetailImagesCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/7/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DetailImagesCell.h"

@interface DetailImagesCell ()


@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation DetailImagesCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        [self setUpUI];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl{
    
    _imageUrl = imageUrl;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}



- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _imageView = [UIImageView new];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
}

@end
