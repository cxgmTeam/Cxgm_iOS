//
//  ShippingModeCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/9/25.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "ShippingModeCell.h"

@interface ShippingModeCell ()
@property(nonatomic,strong)UIButton* leftBtn;
@property(nonatomic,strong)UIButton* rightBtn;
@end

@implementation ShippingModeCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUP];
    }
    return self;
}

- (void)setupUP
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"取货方式";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.left.equalTo(15);
    }];
    
    _leftBtn = [UIButton new];
    _leftBtn.tag = 1;
    [_leftBtn setImage:[UIImage imageNamed:@"goods_unselect"] forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
    [_leftBtn setTitle:@"  配送" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(100, 44));
        make.centerY.equalTo(self);
        make.left.equalTo(label.right).offset(15);
    }];
    [_leftBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.selected = YES;
    
    
    _rightBtn = [UIButton new];
    _rightBtn.tag = 2;
    [_rightBtn setImage:[UIImage imageNamed:@"goods_unselect"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
    [_rightBtn setTitle:@"  自取" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(100, 44));
        make.centerY.equalTo(self);
        make.left.equalTo(self.leftBtn.right).offset(15);
    }];
    [_rightBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapButton:(UIButton *)button
{
    if (button.tag == 1) {
        _leftBtn.selected = YES;
        _rightBtn.selected = NO;
        !_selectShippingMode?:_selectShippingMode(@"配送");
    }else{
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
        !_selectShippingMode?:_selectShippingMode(@"自取");
    }
}
@end
