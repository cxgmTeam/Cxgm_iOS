//
//  PaymentViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@property(nonatomic,strong)UIButton* payButon;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付订单";
    
    
    
}

- (void)setupMainUI
{
    [self.payButon mas_makeConstraints:^(MASConstraintMaker *make){
        
    }];
}


- (UIButton *)payButon{
    if (!_payButon) {
        _payButon = [UIButton new];
        _payButon.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [_payButon setTitle:@"确认支付￥642.14" forState:UIControlStateNormal];
        _payButon.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [_payButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_payButon];
    }
    return _payButon;
}
@end
