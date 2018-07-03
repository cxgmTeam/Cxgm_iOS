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
@property(nonatomic,strong)UIScrollView* menuView;
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
    NSArray* array = @[@"全部",@"待支付",@"待配送",@"配送中",@"已完成",@"退货"];
    
    _menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
    _menuView.delegate = self;
    _menuView.pagingEnabled = YES;
    _menuView.backgroundColor = [UIColor whiteColor];
    _menuView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_menuView];
    
    
    _lastBtn = nil;
    _btnWidth = ScreenW/5;
    _redLineWidth = _btnWidth;
    
    for (NSInteger i = 0; i < array.count; i++)
    {
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(i*_btnWidth, 0, _btnWidth, 45)];
        btn.tag = i;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:Color00A862 forState:UIControlStateSelected];
        [btn setTitleColor:Color999999 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:btn];

        if (i == 0) {
            btn.selected = YES;
            _lastBtn = btn;
        }
    }
    
    _menuView.contentSize = CGSizeMake(_btnWidth * array.count, 45);
    
    
    
    _redLine = [UIView new];
    _redLine.backgroundColor = Color00A862;
    [_menuView addSubview:_redLine];
    [_redLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(0);
        make.top.equalTo(42);
        make.width.equalTo(self.btnWidth);
        make.height.equalTo(3);
    }];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, ScreenW, ScreenH-NAVIGATION_BAR_HEIGHT-45-TAB_BAR_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    _scrollView.contentSize = CGSizeMake(array.count*ScreenW, _scrollView.frame.size.height);
    
//空 全部  0待支付  1待配送  4配送中  5已完成  7退货
    for (NSInteger i = 0; i < array.count; i++) {
        OrderListViewController* vc = [OrderListViewController new];
        switch (i) {
            case 0://全部
                vc.status = -1;
                break;
            case 1://待支付
                vc.status = 0;
                break;
            case 2://待配送
                vc.status = 1;
                break;
            case 3://配送中
                vc.status = 4;
                break;
            case 4://已完成
                vc.status = 5;
                break;
            case 5://退货
                vc.status = 7;
                break;
                
            default:
                break;
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
    
    float xx = ScreenW * (button.tag - 1) * (_btnWidth / ScreenW) - _btnWidth;

    [_menuView scrollRectToVisible:CGRectMake(xx, 0, ScreenW, _menuView.frame.size.height) animated:YES];
    
    NSLog(@"=========xxx  %f",xx);
    
    //下方大的滑动视图的滚动
    CGFloat offsetX = button.tag * _scrollView.frame.size.width;
    CGFloat offsetY = _scrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [_scrollView setContentOffset:offset animated:YES];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        
        NSUInteger index = scrollView.contentOffset.x / _scrollView.frame.size.width;
        
        NSLog(@"scrollViewDidEndScrollingAnimation-------  %d",index);

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

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    if (scrollView == _scrollView) {
        NSLog(@"scrollViewDidEndDecelerating++++++");
        float xx = scrollView.contentOffset.x * (_btnWidth / ScreenW) - _btnWidth;
        [_menuView scrollRectToVisible:CGRectMake(xx, 0, ScreenW, _menuView.frame.size.height) animated:YES];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrollView.contentOffset.x < -50) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
