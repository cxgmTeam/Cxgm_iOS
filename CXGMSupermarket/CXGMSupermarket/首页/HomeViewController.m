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
#import "AddressViewController.h"

#import "HYNoticeView.h"
#import "MessageViewController.h"

@interface HomeViewController ()
@property(nonatomic,strong)HomeGoodsView* goodsView;
@property(nonatomic,strong)HomeShopsView* shopsView;

@property(nonatomic,strong)UIView* topView;

@property(nonatomic,strong)HYNoticeView *noticeHot;
@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTopBar];
    
    
    _noticeHot = [[HYNoticeView alloc] initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT-25, SCREENW*0.6, 40) text:@"送货至西城区德胜门国际大厦五层" position:HYNoticeViewPositionTopLeft];
    [_noticeHot showType:HYNoticeTypeTestHot inView:self.navigationController.navigationBar];
}

- (void)setupMainUI:(BOOL)inScope
{
    if (inScope)
    {
        if (_shopsView.superview) {
            [_shopsView removeFromSuperview];
            _shopsView = nil;
        }
        
        if (!_goodsView)
        {
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
            
            _goodsView.showGoodsDetailVC = ^(GoodsModel *model){
                GoodsDetailViewController* vc = [GoodsDetailViewController new];
                vc.goodsId = model.id;
                [wself.navigationController pushViewController:vc animated:YES];
            };
        }
    }
    else
    {
        if (_goodsView.superview) {
            [_goodsView removeFromSuperview];
            _goodsView = nil;
        }
        
        if (!_shopsView)
        {
            _shopsView = [HomeShopsView new];
            [self.view addSubview:_shopsView];
            [_shopsView mas_makeConstraints:^(MASConstraintMaker *make){
                make.edges.equalTo(self.view);
            }];
            typeof(self) __weak wself = self;
            _shopsView.selectShopHandler = ^{
                [wself setupMainUI:YES];
            };
        }
    }
    
    [self.view bringSubviewToFront:_noticeHot];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _topView.hidden = NO;
    _noticeHot.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _topView.hidden = YES;
    _noticeHot.hidden = YES;
}

- (void)setupTopBar
{
    UIButton* locationBtn = [UIButton new];
    [locationBtn setImage:[UIImage imageNamed:@"order_address"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(showAddressVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];

    
    UIButton* messageBtn = [UIButton new];
    [messageBtn setImage:[UIImage imageNamed:@"top_message"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(showMessageVC:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)showAddressVC:(id)sender
{
    AddressViewController* vc = [AddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMessageVC:(id)sender
{
    MessageViewController* vc = [MessageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTapButton:(id)sender
{
    SearchViewController* vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
