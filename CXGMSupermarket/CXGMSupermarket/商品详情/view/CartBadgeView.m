//
//  CartBadgeView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/31.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CartBadgeView.h"

@interface CartBadgeView ()

@property (nonatomic, strong)UILabel *countLabel;
@end

@implementation CartBadgeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.carButton];
        
        [self getShopCartNumber];
        
        [self addNotification];
    }
    return self;
}



- (UIButton *)carButton{
    if (!_carButton) {
        _carButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _carButton.frame = CGRectMake(0, 0, 44, 44);
        [_carButton addTarget:self action:@selector(shopCarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carButton;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 20, 20)];
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

#pragma mark-
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopCartNumber) name:AddGoodsSuccess_Notify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopCartNumber) name:AddOrder_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopCartNumber) name:DeleteShopCart_Success object:nil];
}

- (void)getShopCartNumber
{
    if (![UserInfoManager sharedInstance].isLogin) return;
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    NSDictionary* dic = @{
                          @"pageNum":@"1",
                          @"pageSize":@"1"
                          };
    
    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APIShopCartList] token:userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.code isEqualToString:@"200"]) {

            [self setShopCarCount:model.listModel.total];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
