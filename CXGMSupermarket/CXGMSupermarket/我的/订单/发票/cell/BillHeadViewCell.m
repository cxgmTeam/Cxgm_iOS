//
//  BillHeadViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "BillHeadViewCell.h"
#import "BillCustomButton.h"

@interface BillHeadViewCell ()
@property(nonatomic,strong)UIView* bottomView;
@end

@implementation BillHeadViewCell

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
    label.text = @"发票抬头";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(12);
        make.left.equalTo(15);
    }];
    
    BillCustomButton* commonBtn = [[BillCustomButton alloc] initWithFrame:CGRectZero withTitle:@"个人"];
    [self addSubview:commonBtn];
    [commonBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.top.equalTo(label.bottom).offset(10);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    
    BillCustomButton* electronicBtn = [[BillCustomButton alloc] initWithFrame:CGRectZero withTitle:@"公司"];
    [self addSubview:electronicBtn];
    [electronicBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(commonBtn.right).offset(10);
        make.top.equalTo(label.bottom).offset(10);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    electronicBtn.selected = YES;
    
    
    _bottomView = [UIView new];
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(190-84);
    }];
    {
        UITextField* textField1 = [UITextField new];
        textField1.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1/1.0];
        textField1.text = @"请在此填写准确的抬头名称";
        textField1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        textField1.textColor = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1/1.0];
        [_bottomView addSubview:textField1];
        [self addSubview:textField1];
        [textField1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.bottomView);
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        }];
        
        UITextField* textField2 = [UITextField new];
        textField2.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1/1.0];
        textField2.text = @"请在此填写纳税人识别号";
        textField2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        textField2.textColor = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1/1.0];
        [_bottomView addSubview:textField2];
        [self addSubview:textField2];
        [textField2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(textField1.bottom).offset(10);
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        }];
    }
}
@end
