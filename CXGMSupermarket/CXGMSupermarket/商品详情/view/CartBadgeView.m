//
//  CartBadgeView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/31.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CartBadgeView.h"

@interface CartBadgeView ()
@property (nonatomic, strong)UIButton *carButton;
@property (nonatomic, strong)UILabel *countLabel;
@end

@implementation CartBadgeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.carButton];
    }
    return self;
}

- (UIButton *)carButton{
    if (!_carButton) {
        _carButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _carButton.frame = CGRectMake(0, 8, 32, 32);
        [_carButton setImage:[UIImage imageNamed:@"top_cart"] forState:UIControlStateNormal];
        [_carButton addTarget:self action:@selector(shopCarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carButton;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 5, 20, 20)];
        _countLabel.backgroundColor = [UIColor redColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.layer.cornerRadius = 10;
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.layer.masksToBounds = YES;
        [self addSubview:_countLabel];
    }
    return _countLabel;
}
// 为购物车设置角标内数值
- (void)setShopCarCount:(NSString *)count{
    if ([count integerValue] == 0) {
        if (_countLabel) {
            [_countLabel removeFromSuperview];
            _countLabel = nil;
        }
        return;
    }
    if ([count integerValue] > 99) {
        self.countLabel.text = @"99+";
    }else{
        self.countLabel.text = count;
    }
    [self shakeView:_countLabel];
}
// 实现的代理方法
- (void)shopCarButtonAction{
    [self.delegate shopCarButtonClickAction];
}
// 实现抖动效果
-(void)shakeView:(UIView*)viewToShake
{
    CGFloat t =2.0;
    CGAffineTransform translateRight =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

@end
