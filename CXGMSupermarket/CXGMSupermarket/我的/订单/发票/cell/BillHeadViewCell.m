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

@property(nonatomic,strong)BillCustomButton* personBtn;
@property(nonatomic,strong)BillCustomButton* companyBtn;


@end

@implementation BillHeadViewCell

- (void)setReceipt:(ReceiptItem *)receipt
{
    _personBtn.selected = !receipt.isOpen;
    _companyBtn.selected = receipt.isOpen;
    
    _bottomView.hidden = !receipt.isOpen;
}

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
    
    _personBtn = [[BillCustomButton alloc] initWithFrame:CGRectZero withTitle:@"个人"];
    _personBtn.tag = 1;
    [self addSubview:_personBtn];
    [_personBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.top.equalTo(label.bottom).offset(10);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    _personBtn.selected = YES;
    [_personBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _companyBtn = [[BillCustomButton alloc] initWithFrame:CGRectZero withTitle:@"公司"];
    _companyBtn.tag = 2;
    [self addSubview:_companyBtn];
    [_companyBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.personBtn.right).offset(10);
        make.top.equalTo(label.bottom).offset(10);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    [_companyBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomView = [UIView new];
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(190-84);
    }];
    {
        _companyNameTextField = [UITextField new];
        _companyNameTextField.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1/1.0];
        _companyNameTextField.text = @"请在此填写准确的抬头名称";
        _companyNameTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _companyNameTextField.textColor = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1/1.0];
        [_bottomView addSubview:_companyNameTextField];
        [_companyNameTextField mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.bottomView);
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        }];
        
        _dutyParagraphTextField = [UITextField new];
        _dutyParagraphTextField.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1/1.0];
        _dutyParagraphTextField.text = @"请在此填写纳税人识别号";
        _dutyParagraphTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _dutyParagraphTextField.textColor = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1/1.0];
        [_bottomView addSubview:_dutyParagraphTextField];
        [_dutyParagraphTextField mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.companyNameTextField.bottom).offset(10);
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        }];
    }
//    _bottomView.hidden = YES;
}
     
     
 - (void)onTapButton:(BillCustomButton *)button
 {
     if (button.tag == 1) {
         _personBtn.selected = YES;
         _companyBtn.selected = NO;
         
         _bottomView.hidden = YES;
     }else{
         _personBtn.selected = NO;
         _companyBtn.selected = YES;
         
         _bottomView.hidden = NO;
     }
     !_selectReceiptHead?:_selectReceiptHead(!_bottomView.hidden);
 }
@end
