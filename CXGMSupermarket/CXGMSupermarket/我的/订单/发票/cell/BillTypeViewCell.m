//
//  BillTypeViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "BillTypeViewCell.h"
#import "BillCustomButton.h"

@interface BillTypeViewCell ()
@property(nonatomic,strong)BillCustomButton* commonBtn;
@property(nonatomic,strong)BillCustomButton* electronicBtn;
@end

@implementation BillTypeViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"发票类型";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(12);
        make.left.equalTo(15);
    }];
    
    _commonBtn = [[BillCustomButton alloc] initWithFrame:CGRectZero withTitle:@"普通发票"];
    _commonBtn.tag = 1;
    [self addSubview:_commonBtn];
    [_commonBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.bottom.equalTo(-15);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    [_commonBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _electronicBtn = [[BillCustomButton alloc] initWithFrame:CGRectZero withTitle:@"电子发票"];
    _electronicBtn.tag = 2;
    [self addSubview:_electronicBtn];
    [_electronicBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.commonBtn.right).offset(10);
        make.bottom.equalTo(-15);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    _electronicBtn.selected = YES;
    [_electronicBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapButton:(BillCustomButton *)button
{
    NSString* type = @"1";
    
    if (button.tag == 1) {
        _commonBtn.selected = YES;
        _electronicBtn.selected = NO;
        type = @"0";
    }else{
        _commonBtn.selected = NO;
        _electronicBtn.selected = YES;
        type = @"1";
    }
    
    !_selectReceiptType?:_selectReceiptType(type);
}
@end
