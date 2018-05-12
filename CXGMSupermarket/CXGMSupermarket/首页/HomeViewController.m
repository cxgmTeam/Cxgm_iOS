//
//  HomeViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/10.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "HomeViewController.h"
#import "GoodsDetailViewController.h"
#import "SubCategoryController.h"

#import "HomeGoodsView.h"
#import "HomeShopsView.h"

#import "SearchViewController.h"

@interface HomeViewController ()
@property(nonatomic,strong)HomeGoodsView* goodsView;
@property(nonatomic,strong)HomeShopsView* shopsView;

@property(nonatomic,strong)UIView* topView;
@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _goodsView = [HomeGoodsView new];
    [self.view addSubview:_goodsView];
    [_goodsView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    typeof(self) __weak wself = self;
    _goodsView.showSubCategoryVC = ^{
        SubCategoryController* vc = [SubCategoryController new];
//        vc.title = wself.categoryNames[indexPath.item];
        [wself.navigationController pushViewController:vc animated:YES];
    };
    
    _goodsView.showGoodsDetailVC = ^{
        GoodsDetailViewController* vc = [GoodsDetailViewController new];
        [wself.navigationController pushViewController:vc animated:YES];
    };
    

//    _shopsView = [HomeShopsView new];
//    [self.view addSubview:_shopsView];
//    [_shopsView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.edges.equalTo(self.view);
//    }];
    
    [self setupTopBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _topView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _topView.hidden = YES;
}

- (void)setupTopBar
{
    UIButton* locationBtn = [UIButton new];
    [locationBtn setImage:[UIImage imageNamed:@"order_address"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];
    
    UIButton* messageBtn = [UIButton new];
    [messageBtn setImage:[UIImage imageNamed:@"top_message"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(50, (44-28)/2, ScreenW-100, 28)];
    [self.navigationController.navigationBar addSubview:_topView];
    
    CustomTextField* textField = [CustomTextField new];
    textField.layer.cornerRadius = 14;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:242/255.0 alpha:1/1.0];
    textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"top_searchBar_search"];
    textField.leftView = imgView;
    textField.placeholder = @"特惠三文鱼";
    [_topView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.topView);
    }];
    
    UIButton* btn = [UIButton new];
    [_topView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.topView);
    }];
    [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapButton:(id)sender
{
    SearchViewController* vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
