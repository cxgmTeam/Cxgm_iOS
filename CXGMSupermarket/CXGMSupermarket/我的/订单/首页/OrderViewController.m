//
//  OrderViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderListViewController.h"

@interface OrderViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView* menuView;
@property(nonatomic,strong)UIView* redLine;
@property(nonatomic,strong)UIButton* lastBtn;
@property(nonatomic,assign)CGFloat btnWidth;
@property(nonatomic,assign)CGFloat redLineWidth;
@property(nonatomic,strong)UIScrollView* scrollView;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    NSArray* array = @[@"全部",@"待付款",@"配送中",@"已完成",@"申请售后"];
    
    _menuView = [UIView new];
    _menuView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(45);
    }];
    
    
    _lastBtn = nil;
    _btnWidth = ScreenW/array.count;
    _redLineWidth = _btnWidth;
    
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton* btn = [UIButton new];
        btn.tag = i;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:Color00A862 forState:UIControlStateSelected];
        [btn setTitleColor:Color999999 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(i*self.btnWidth);
            make.top.bottom.equalTo(self.menuView);
            make.width.equalTo(self.btnWidth);
        }];
        if (i == 0) {
            _lastBtn = btn;
            _lastBtn.selected = YES;
        }
    }
    
    
    _redLine = [UIView new];
    _redLine.backgroundColor = Color00A862;
    [_menuView addSubview:_redLine];
    [_redLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(3);
        make.width.equalTo(self.redLineWidth);
        make.left.equalTo((self.btnWidth-self.redLineWidth)/2.f);
        make.bottom.equalTo(self.menuView);
    }];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, ScreenW, ScreenH-NAVIGATION_BAR_HEIGHT-45-TAB_BAR_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.menuView.bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    _scrollView.contentSize = CGSizeMake(array.count*ScreenW, 0);
    
    
    //0待支付，1待配送（已支付），2配送中，3已完成，4退货
    for (NSInteger i = 0; i < array.count; i++) {
        OrderListViewController* vc = [OrderListViewController new];
        if (i == 0 || i == 1) {
            vc.status = i-1;
        }else{
            vc.status = i;
        }
        [_scrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(i*ScreenW, 0, ScreenW, ScreenH-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-45);
        [self addChildViewController:vc];
    }
    
    //定位页面
    UIButton *button = _menuView.subviews[self.pageIndex];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [_redLine mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(button.tag*self.btnWidth+(self.btnWidth-self.redLineWidth)/2.f);
    }];

}

- (void)clickButton:(UIButton *)button
{
    _lastBtn.selected = NO;
    button.selected = YES;
    _lastBtn = button;
    
    [_redLine mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(button.tag*self.btnWidth+(self.btnWidth-self.redLineWidth)/2.f);
    }];
    
    //下方大的滑动视图的滚动
    CGFloat offsetX = button.tag * _scrollView.frame.size.width;
    CGFloat offsetY = _scrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [_scrollView setContentOffset:offset animated:YES];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / _scrollView.frame.size.width;
    
    _lastBtn.selected = NO;
    UIButton *button = _menuView.subviews[index];
    if ([button isKindOfClass:[UIButton class]]) {
        button.selected = YES;
        _lastBtn = button;
        [_redLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lastBtn.frame.origin.x+(self.btnWidth-self.redLineWidth)/2.f);
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < -50) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
