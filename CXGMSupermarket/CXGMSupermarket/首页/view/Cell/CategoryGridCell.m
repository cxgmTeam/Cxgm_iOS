//
//  CategoryGridCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CategoryGridCell.h"


#import "UIView+DCRolling.h"
#import "UIColor+DCColorChange.h"


@interface CategoryGridCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *gridImageView;
/* gridLabel */
@property (strong , nonatomic)UILabel *gridLabel;

@end

@implementation CategoryGridCell

- (void)setImage:(NSString *)imageName title:(NSString *)title{
    _gridImageView.image = [UIImage imageNamed:imageName];
    _gridLabel.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    _gridImageView = [[UIImageView alloc] init];
    _gridImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_gridImageView];

    
    _gridLabel = [[UILabel alloc] init];
    _gridLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _gridLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _gridLabel.text = @"生鲜";
    [self addSubview:_gridLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.centerX.mas_equalTo(self);
    }];
    
    [_gridLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self.gridImageView.mas_bottom)setOffset:6];
    }];
    
}
@end
