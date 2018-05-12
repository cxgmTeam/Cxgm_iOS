//
//  PayResultViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "PayResultViewController.h"
#import "OrderDetailViewController.h"

@interface PayResultViewController ()

@end

@implementation PayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"支付成功";
    
    [self setupUI];
}

- (void)setupUI
{
    UIButton* btn1 = [UIButton new];
    btn1.layer.borderColor =Color00A862.CGColor;
    btn1.layer.borderWidth = 1;
    btn1.layer.cornerRadius = 4;
    [btn1 setTitle:@"返回首页" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [btn1 setTitleColor:Color00A862 forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(42);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(-80);
    }];
    [btn1 addTarget:self action:@selector(gotoHomePage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn2= [UIButton new];
    btn2.backgroundColor = Color00A862;
    btn2.layer.cornerRadius = 4;
    [btn2 setTitle:@"查看订单" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(42);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(btn1.top).offset(-20);
    }];
    [btn2 addTarget:self action:@selector(gotoOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_success"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(20);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"支付成功";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(imageView.bottom).offset(10);
        make.left.equalTo(ScreenW/2.f-25);
    }];
    
    UIImageView* imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_successIcon"]];
    [self.view addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(label.left).offset(-5);
        make.centerY.equalTo(label);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"微信支付：¥189.80";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20];
    label1.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
}

- (void)gotoHomePage:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WindowHomePage_Notify object:nil];
}

- (void)gotoOrderDetail:(id)sender
{
    OrderDetailViewController* vc = [OrderDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
