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

@property(nonatomic,strong)UIView* exchangeView;
@property(nonatomic,strong)CustomTextField* textField;

@property(nonatomic,strong)UIButton* leftBtn;
@property(nonatomic,strong)UIButton* rightBtn;
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    
    [self setupMenuView];
    
    [self setupExchangeView];
    

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45+54, ScreenW, ScreenH-NAVIGATION_BAR_HEIGHT-45-54)];
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
    }
    
    

    
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
- (void)exchangeCoupons:(id)sender
{
    if (_textField.text.length == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入正确的兑换码"]; return;
    }
    
    NSDictionary* dic = @{@"couponCode":_textField.text};
    //兑换之后该干嘛
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIExchangeCoupons] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        
    } failure:^(id JSON, NSError *error){
        
    }];
    
}

- (void)restButtonTitle:(NSDictionary *)value
{
    NSNumber * number = value[@"number"];
    
    if ([value[@"status"] boolValue]) {
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

- (void)setupExchangeView
{
    _exchangeView = [UIView new];
    [self.view addSubview:_exchangeView];
    [_exchangeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(54);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.menuView.bottom);
    }];
    
    UIButton* button = [UIButton new];
    button.backgroundColor = Color00A862;
    button.layer.cornerRadius = 4;
    [button setTitle:@"兑换" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_exchangeView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(70, 34));
        make.centerY.equalTo(self.exchangeView);
        make.right.equalTo(-15);
    }];
    [button addTarget:self action:@selector(exchangeCoupons:) forControlEvents:UIControlEventTouchUpInside];
    
    _textField = [CustomTextField new];
    _textField.layer.borderColor = [UIColor colorWithHexString:@"D8D8D8"].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.layer.cornerRadius = 4;
    _textField.placeholder = @"请输入优惠券兑换码";
    _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _textField.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [_exchangeView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(self.exchangeView);
        make.height.equalTo(34);
        make.right.equalTo(button.left).offset(-10);
    }];

}
@end
