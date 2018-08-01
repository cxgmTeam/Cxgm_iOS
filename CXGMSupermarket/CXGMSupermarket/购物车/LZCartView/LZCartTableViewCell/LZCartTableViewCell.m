//
//  LZCartTableViewCell.m
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import "LZCartTableViewCell.h"
#import "LZConfigFile.h"


@interface LZCartTableViewCell ()
{
    LZNumberChangedBlock numberAddBlock;
    LZNumberChangedBlock numberCutBlock;
    LZCellSelectedBlock cellSelectedBlock;
}
//选中按钮
@property (nonatomic,strong) UIButton *selectBtn;
//显示照片
@property (nonatomic,strong) UIImageView *lzImageView;
//商品名
@property (nonatomic,strong) UILabel *nameLabel;
//规格
@property (nonatomic,strong) UILabel *sizeLabel;
//价格
@property (nonatomic,strong) UILabel *priceLabel;
//数量
@property (nonatomic,strong)UILabel *numberLabel;
//时间
@property (nonatomic,strong) UILabel *dateLabel;
//优惠活动
@property (nonatomic,strong) UILabel *activityLabel;
//小计
@property (nonatomic,strong) UILabel *subtotalLabel;

@property (nonatomic,strong)GoodsModel *goodsModel;

@end

@implementation LZCartTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}
#pragma mark - public method
- (void)reloadDataWithModel:(GoodsModel*)model {
    
    self.goodsModel = model;
    
    [self.lzImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.nameLabel.text = model.goodName;
    self.priceLabel.text = [NSString stringWithFormat: @"¥ %.2f",[model.price floatValue]];
    self.numberLabel.text = model.goodNum;
    self.sizeLabel.text = [NSString stringWithFormat:@"规格：%@",model.specifications];
    self.activityLabel.text = model.coupon;
    
    self.selectBtn.selected = [model.select boolValue];
    
    
    CGFloat amount =  [model.goodNum integerValue]*[model.price floatValue];
    self.subtotalLabel.text = [NSString stringWithFormat:@"小计：¥ %.2f",amount];
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:self.subtotalLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] range:NSMakeRange(0, 3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0] range:NSMakeRange(3,attrStr.length-3)];
    self.subtotalLabel.attributedText = attrStr;
}

- (void)numberAddWithBlock:(LZNumberChangedBlock)block {
    numberAddBlock = block;
}

- (void)numberCutWithBlock:(LZNumberChangedBlock)block {
    numberCutBlock = block;
}

- (void)cellSelectedWithBlock:(LZCellSelectedBlock)block {
    cellSelectedBlock = block;
}
#pragma mark - 重写setter方法
- (void)setLzNumber:(NSInteger)lzNumber {
    _lzNumber = lzNumber;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)lzNumber];
    
    CGFloat amount = lzNumber* [self.goodsModel.price floatValue];
    
    self.subtotalLabel.text = [NSString stringWithFormat:@"小计：¥ %.2f",amount];
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:self.subtotalLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] range:NSMakeRange(0, 3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0] range:NSMakeRange(3,attrStr.length-3)];
    self.subtotalLabel.attributedText = attrStr;
    
}

- (void)setLzSelected:(BOOL)lzSelected {
    _lzSelected = lzSelected;
    self.selectBtn.selected = lzSelected;
}
#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
}

- (void)addBtnClick:(UIButton*)button {
    
    NSInteger count = [self.numberLabel.text integerValue];
    count++;
    
    if (numberAddBlock) {
        numberAddBlock(count);
    }
}

- (void)cutBtnClick:(UIButton*)button {
    NSInteger count = [self.numberLabel.text integerValue];
    count--;
    if(count <= 0){
        return ;
    }

    if (numberCutBlock) {
        numberCutBlock(count);
    }
}
#pragma mark - 布局主视图
-(void)setupMainView {
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //选中按钮
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.bounds = CGRectMake(0, 0, 30, 30);
    [selectBtn setImage:[UIImage imageNamed:@"goods_unselect"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.equalTo(self);
        make.bottom.equalTo(-40);
        make.width.equalTo(60);
    }];
    self.selectBtn = selectBtn;
    

    //显示照片
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"placeholderImage"];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(selectBtn.right);
        make.top.equalTo(20);
        make.width.height.equalTo(84);
    }];
    self.lzImageView = imageView;
    
    //商品名
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.numberOfLines = 2;
    nameLabel.text = @"这里展示的是商品的名称一行显示不够折行展示巧克力西红柿500g";
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(imageView.right).offset(10);
        make.top.equalTo(10);
        make.right.equalTo(bgView).offset(-10);
    }];
    self.nameLabel = nameLabel;
    
    //规格
    UILabel* sizeLabel = [[UILabel alloc]init];
    sizeLabel.text = @"规格：500g";
    sizeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    sizeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [bgView addSubview:sizeLabel];
    [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.bottom).offset(2);
    }];
    self.sizeLabel = sizeLabel;

    
    //价格
    UILabel* priceLabel = [[UILabel alloc]init];
    priceLabel.text = @"¥ 19.90";
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    priceLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(sizeLabel.bottom).offset(9);
        make.left.equalTo(nameLabel);
    }];
    self.priceLabel = priceLabel;
    
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-5);
        make.bottom.equalTo(priceLabel).offset(5);
        make.width.height.equalTo(40);
    }];
    
    
    //数量显示
    UILabel* numberLabel = [[UILabel alloc]init];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"1";
    numberLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(addBtn.left);
        make.bottom.equalTo(priceLabel.bottom).offset(-3);
        make.width.equalTo(30);
        make.height.equalTo(25);
    }];
    self.numberLabel = numberLabel;
    
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cutBtn];
    [cutBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(numberLabel.left);
        make.bottom.equalTo(addBtn);
        make.width.height.equalTo(40);
    }];
    
    
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(bgView);
        make.height.equalTo(1);
        make.bottom.equalTo(-40);
    }];
    
    
    //活动
    UILabel* activityLabel = [[UILabel alloc]init];
    activityLabel.text = @"满100返20";
    activityLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    activityLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:activityLabel];
    [activityLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(selectBtn);
        make.bottom.equalTo(-10);
    }];
    self.activityLabel = activityLabel;
    
    
    //小计
    UILabel* subtotalLabel = [[UILabel alloc]init];
    subtotalLabel.text = @"小计：¥ 19.90";
    subtotalLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    subtotalLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:subtotalLabel];
    [subtotalLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(addBtn);
        make.bottom.equalTo(-10);
    }];
    self.subtotalLabel = subtotalLabel;
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:subtotalLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] range:NSMakeRange(0, 3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0] range:NSMakeRange(3,attrStr.length-3)];
    self.subtotalLabel.attributedText = attrStr;
    
}

@end
