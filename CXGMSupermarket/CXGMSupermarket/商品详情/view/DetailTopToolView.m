//
//  DetailTopToolView.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DetailTopToolView.h"
#import "CartBadgeView.h"


@interface DetailTopToolView ()<CartBadgeDelegate>

@property (strong , nonatomic)CartBadgeView* cartBtn;

@property(nonatomic,strong)UIView* menuView;
@property(nonatomic,strong)UIView* redLine;
@property(nonatomic,strong)UIButton* lastBtn;
@property(nonatomic,assign)CGFloat btnWidth;
@property(nonatomic,assign)CGFloat redLineWidth;

@end

@implementation DetailTopToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setAlphaOfView:(CGFloat)alpha{
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    _menuView.alpha = alpha;
    _goodNameLabel.alpha = alpha;
    
}

- (void)selectButton:(NSInteger)index
{
    if (index+2 > _menuView.subviews.count) return;
    
    _lastBtn.selected = NO;
    
    UIButton *button = _menuView.subviews[index+2];
    if ([button isKindOfClass:[UIButton class]]) {
        button.selected = YES;
        _lastBtn = button;
        [_redLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lastBtn.frame.origin.x+(self.btnWidth-self.redLineWidth)/2.f);
        }];
    }
}


- (void)setupUI
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, STATUS_BAR_HEIGHT, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];

    
    _cartBtn = [CartBadgeView new];
    _cartBtn.delegate = self;
    [self addSubview:_cartBtn];
    [_cartBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(44, 44));
        make.right.equalTo(-20);
        make.top.equalTo(STATUS_BAR_HEIGHT);
    }];
    [_cartBtn.carButton setImage:[UIImage imageNamed:@"top_cart"] forState:UIControlStateNormal];

    
    _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, ScreenW, 45)];
    [self addSubview:_menuView];
    
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [_menuView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.menuView);
        make.height.equalTo(1);
    }];
    
    line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [_menuView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self.menuView);
        make.height.equalTo(1);
    }];

    NSArray* array = @[@"商品",@"详情",@"推荐"];
    
    _lastBtn = nil;
    _btnWidth = ScreenW/array.count;
    _redLineWidth = 53;
    
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
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"圣湖 青海特产老酸奶优质特惠 245...";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    label.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.menuView.top).offset(-7);
        make.centerX.equalTo(self.menuView);
        make.width.equalTo(ScreenW-105);
    }];
    _goodNameLabel = label;
}

- (void)clickButton:(UIButton *)button
{
    _lastBtn.selected = NO;
    button.selected = YES;
    _lastBtn = button;
    
    [_redLine mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(button.tag*self.btnWidth+(self.btnWidth-self.redLineWidth)/2.f);
    }];
    
    !_scrollCollectionView?:_scrollCollectionView(button.tag);
}

- (void)backButtonClicked:(id)sender
{
    !_backBtnClickBlock ? : _backBtnClickBlock();
}

#pragma mark-
- (void)shopCarButtonClickAction{
    !_gotoCartBlock?:_gotoCartBlock();
}

@end
