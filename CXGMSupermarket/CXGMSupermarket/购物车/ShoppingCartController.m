//
//  ShoppingCartController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/10.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "ShoppingCartController.h"

#import "OrderConfirmViewController.h"

#import "ShopCartView.h"

@interface ShoppingCartController ()

@property (strong,nonatomic)ShopCartView * cartView;;

@end

@implementation ShoppingCartController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    
    UIButton* editBtn = [UIButton new];
    [editBtn setTitle:@"删除" forState:UIControlStateNormal];
    [editBtn setTitleColor:Color333333 forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [editBtn addTarget:self action:@selector(onTapDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
 
    
    _cartView = [[ShopCartView alloc] init];
    [self.view addSubview:_cartView];
    [_cartView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(-TAB_BAR_HEIGHT);
    }];
    
    typeof(self) __weak wself = self;
    _cartView.gotoConfirmOrder = ^{
        OrderConfirmViewController* vc = [OrderConfirmViewController new];
        [wself.navigationController pushViewController:vc animated:YES];
    };
}

- (void)onTapDeleteBtn:(id)sender
{
    [self.cartView deleteSelectedGoods];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.cartView retsetSelectedStatus];
}

@end
