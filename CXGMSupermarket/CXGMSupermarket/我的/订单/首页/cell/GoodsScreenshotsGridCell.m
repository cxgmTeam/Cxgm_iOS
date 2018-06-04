//
//  GoodsScreenshotsGridCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsScreenshotsGridCell.h"

@interface GoodsScreenshotsGridCell ()
@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation GoodsScreenshotsGridCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"placeholderImage"];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setGoods:(LZCartModel *)goods
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:goods.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}
@end
