//
//  CouponViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponListViewController.h"

@interface CouponViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView* menuView;
@property(nonatomic,strong)UIView* redLine;
@property(nonatomic,strong)UIButton* lastBtn;
@property(nonatomic,assign)CGFloat btnWidth;
@property(nonatomic,assign)CGFloat redLineWidth;
@property(nonatomic,strong)UIScrollView* scrollView;


@property(nonatomic,strong)UIButton* leftBtn;
@property(nonatomic,strong)UIButton* rightBtn;

@property(nonatomic,strong)CouponListViewController* leftVC;
@property(nonatomic,strong)CouponListViewController* rightVC;
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    
    [self setupMenuView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, ScreenW, ScreenH-NAVIGATION_BAR_HEIGHT-45)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    _scrollView.contentSize = CGSizeMake(2*ScreenW, 0);
    
    
    for (NSInteger i = 0; i < 2; i++) {
        CouponListViewController* vc = [CouponListViewController new];
        vc.isExpire = i==1?YES:NO;
        vc.delegate = self;
        [_scrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(i*ScreenW, 0, ScreenW, _scrollView.bounds.size.height);
        [self addChildViewController:vc];
        if (i == 0) {
            self.leftVC = vc;
        }else{
            self.rightVC = vc;
        }
    }
}

- (void)exchangeCoupons:(NSString *)code
{
    if (code.length == 0) return;
    
    NSDictionary* dic = @{@"couponCode":code};
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIExchangeCoupons] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];

        if ([model.code isEqualToString:@"200"]) {
            if (!model.data) {
                [MBProgressHUD MBProgressHUDWithView:self.view Str:@"二维码已失效"];
            }else{
                [wself.leftVC refreshList];
                [wself.rightVC refreshList];
            }
        }
        
    } failure:^(id JSON, NSError *error){
        
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

#pragma mark-
- (void)restButtonTitle:(NSDictionary *)value
{
    NSNumber * number = value[@"number"];
    
    if (![value[@"status"] boolValue]) {
        [self.leftBtn setTitle:[NSString stringWithFormat:@"可用（%zd）",[number integerValue]] forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:[NSString stringWithFormat:@"不可用（%zd）",[number integerValue]] forState:UIControlStateNormal];
    }
}

#pragma mark- init
- (void)setupMenuView
{
    NSArray* array = @[@"可用（0）",@"不可用（0）"];
    
    _menuView = [UIView new];
    _menuView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(45);
    }];
    
    //竖线
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(8);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(1, 45-16));
    }];
    
    
    _lastBtn = nil;
    _btnWidth = ScreenW/array.count;
    _redLineWidth = 84;
    
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
            
            self.leftBtn = btn;
        }else{
            self.rightBtn = btn;
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
}


@end
