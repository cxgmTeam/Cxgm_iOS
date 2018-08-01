//
//  SelectSpecificationController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "SelectSpecificationController.h"

#import "PurchaseCarAnimationTool.h"

@interface SelectSpecificationController ()
@property (nonatomic , strong)UIView* contentView;
@property (nonatomic , strong)UIImageView* iconView;
@property (strong , nonatomic)UILabel *goodPriceLabel;
@property (strong , nonatomic)UILabel *oldPriceLabel;
@property (strong , nonatomic)UILabel* unitLabel;
@property (strong , nonatomic)UILabel* selectedLabel;
@property (strong , nonatomic)UILabel* specificationLabel;
@property (strong , nonatomic)UILabel* numberLabel;
@end

@implementation SelectSpecificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMaskView:)]];
    
    
    UIView* bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(TAB_BAR_HEIGHT);
    }];
    
    
    UIButton* button = [UIButton new];
    button.backgroundColor = Color00A862;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.equalTo(bottomView);
        make.height.equalTo(49);
    }];
    [button addTarget:self action:@selector(onTapConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self setupUI];
}

- (void)setGoods:(GoodsModel *)goods
{
    _goods = goods;
}


- (void)onTapMaskView:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 点击按钮事件
- (void)onTapCloseBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addBtnClick:(UIButton*)button {
    
    NSInteger count = [self.numberLabel.text integerValue];
    count++;
    if (count>99) {
        return;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
    self.selectedLabel.text = [NSString stringWithFormat:@"已选：%ld",count];

}

- (void)cutBtnClick:(UIButton*)button {
    NSInteger count = [self.numberLabel.text integerValue];
    count--;
    if(count < 0){
        return ;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
    self.selectedLabel.text = [NSString stringWithFormat:@"已选：%ld份",count];
}

- (void)onTapConfirmBtn:(UIButton *)button
{
    NSInteger count = [self.numberLabel.text integerValue];
    
    typeof(self) __weak wself = self;
    
    CGRect imageViewRect = [self.contentView convertRect:self.iconView.frame toView:self.view];

    [[PurchaseCarAnimationTool shareTool] startAnimationandView:_iconView
                                                           rect:imageViewRect
                                                    finisnPoint:CGPointMake(ScreenW-44,STATUS_BAR_HEIGHT)
                                                    finishBlock:^(BOOL finish) {
                                                        
                                                        !wself.selectFinished?:wself.selectFinished(count);
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    }];

}


#pragma mark- init
-  (void)setupUI
{
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(-TAB_BAR_HEIGHT);
        make.height.equalTo(221);
    }];
    
    UIView* topBg = [UIView new];
    topBg.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1/1.0];
    [_contentView addSubview:topBg];
    [topBg mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(112);
    }];
    
    UIButton* closeBtn = [UIButton new];
    [closeBtn setImage:[UIImage imageNamed:@"close_fork"] forState:UIControlStateNormal];
    [topBg addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.right.equalTo(topBg);
        make.width.height.equalTo(44);
    }];
    [closeBtn addTarget:self action:@selector(onTapCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [_contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(1);
        make.top.equalTo(topBg.bottom).offset(45);
    }];
    
    _iconView = [UIImageView new];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:self.goods.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [_contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.height.equalTo(80);
        make.top.equalTo(17);
        make.left.equalTo(15);
    }];

    
    _goodPriceLabel = [[UILabel alloc] init];
    _goodPriceLabel.text =[NSString stringWithFormat:@"￥%.2f",[self.goods.price floatValue]] ;
    _goodPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
    _goodPriceLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [_contentView addSubview:_goodPriceLabel];
    [_goodPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.right).offset(15);
        make.top.mas_equalTo(self.iconView);
    }];
    
    _unitLabel = [UILabel new];
    _unitLabel.text = @"";
    if ([self.goods.unit length] > 0) {
        _unitLabel.text = [NSString stringWithFormat:@"/%@",self.goods.unit];
    }
    _unitLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _unitLabel.textColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1/1.0];
    [_contentView addSubview:_unitLabel];
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodPriceLabel.right);
        make.bottom.mas_equalTo(self.goodPriceLabel);
    }];
    
    _oldPriceLabel = [[UILabel alloc] init];
    _oldPriceLabel.text = @"¥ 89.9";
    _oldPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _oldPriceLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    [_contentView addSubview:_oldPriceLabel];
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.unitLabel.right).offset(11);
        make.bottom.mas_equalTo(self.goodPriceLabel);
    }];
    
    if ([self.goods.originalPrice floatValue]>0) {
        NSUInteger length = [_oldPriceLabel.text length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_oldPriceLabel.text];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0] range:NSMakeRange(0, length)];
        [_oldPriceLabel setAttributedText:attri];
    }else{
        _oldPriceLabel.text = @"";
    }


    _selectedLabel = [[UILabel alloc] init];
    _selectedLabel.text = @"已选：1";
    _selectedLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _selectedLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [_contentView addSubview:_selectedLabel];
    [_selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodPriceLabel.bottom).offset(25);
        make.left.mas_equalTo(self.goodPriceLabel);
    }];
    
    
    _specificationLabel = [[UILabel alloc] init];
    _specificationLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _specificationLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [_contentView addSubview:_specificationLabel];
    [_specificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBg.bottom).offset(14);
        make.left.mas_equalTo(self.iconView);
    }];
    
    if ([self.goods.weight length] > 0 && [self.goods.unit length] > 0)
    {
        if (![self.goods.weight isEqualToString:self.goods.unit])
        {
            if ([self.goods.unit isEqualToString:@"kg"] || [self.goods.unit isEqualToString:@"Kg"] || [self.goods.unit isEqualToString:@"KG"]) {
                
                _specificationLabel.text = [NSString stringWithFormat:@"规格：%@%@",self.goods.weight.length>0?self.goods.weight:@"0.0",self.goods.unit];
            }else{
                _specificationLabel.text = [NSString stringWithFormat:@"规格：%@/%@",self.goods.weight.length>0?self.goods.weight:@"0.0",self.goods.unit];
            }
            
        }else{
            _specificationLabel.text = [NSString stringWithFormat:@"规格：%@",self.goods.weight];
        }
    }
    else if ([self.goods.weight length] > 0 ){
        _specificationLabel.text = [NSString stringWithFormat:@"规格：%@",self.goods.weight];
    }
    else if ([self.goods.unit length] > 0 ){
        _specificationLabel.text = [NSString stringWithFormat:@"规格：%@",self.goods.unit];
    }
    else{
        _specificationLabel.text = @"规格：";
    }
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"购买数量 ";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [_contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.specificationLabel.bottom).offset(33);
        make.left.mas_equalTo(self.iconView);
    }];
    
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-15);
        make.bottom.equalTo(label);
        make.width.height.equalTo(25);
    }];
    
    //数量显示
    UILabel* numberLabel = [[UILabel alloc]init];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"1";
    numberLabel.font = [UIFont systemFontOfSize:15];
    [_contentView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(addBtn.left).offset(-5);
        make.bottom.equalTo(addBtn);
        make.width.equalTo(30);
        make.height.equalTo(25);
    }];
    self.numberLabel = numberLabel;
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:cutBtn];
    [cutBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(numberLabel.left);
        make.bottom.equalTo(addBtn);
        make.width.height.equalTo(25);
    }];


}

@end
