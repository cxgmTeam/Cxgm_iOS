//
//  CouponCollectionViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CouponCollectionViewCell.h"

@interface CouponCollectionViewCell ()
@property(nonatomic,strong)UIImageView* stateImageView;
@property(nonatomic,strong)UILabel* valueLabel;     //面额
@property(nonatomic,strong)UILabel* conditionLabel; //使用条件
@property(nonatomic,strong)UILabel* scopeLabel;     //使用范围
@property(nonatomic,strong)UILabel* timeLabel;      //时间段
@property(nonatomic,strong)UIButton* useBtton;      //立即使用按钮
@property(nonatomic,strong)UIButton* openBtn;       //展开按钮

@property(nonatomic,strong)UIView* bottomView;      //下部
@property(nonatomic,strong)UILabel* explainLabel;   //说明
@end

@implementation CouponCollectionViewCell

- (void)setCoupons:(CouponsModel *)coupons{
    if ([coupons.isOpen boolValue]) {
        [_openBtn setImage:[UIImage imageNamed:@"order_open"] forState:UIControlStateNormal];
    }else{
        [_openBtn setImage:[UIImage imageNamed:@"order_fold"] forState:UIControlStateNormal];
    }
    _bottomView.hidden = ![coupons.isOpen boolValue];
    
    if (coupons.isExpire) {
        _stateImageView.image = [UIImage imageNamed:@"coupon_useless"];
    }else{
        _stateImageView.image = [UIImage imageNamed:@"coupon_bg"];
    }
    _useBtton.hidden = [coupons.isExpire boolValue];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    _stateImageView = [UIImageView new];
    _stateImageView.contentMode = UIViewContentModeScaleAspectFit;
    _stateImageView.image = [UIImage imageNamed:@"coupon_bg"];
    [self addSubview:_stateImageView];
    [_stateImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.equalTo(self);
        make.size.equalTo(CGSizeMake(119, 100));
    }];
    
    UIView* whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.top.equalTo(self);
        make.height.equalTo(100);
        make.left.equalTo(self.stateImageView.right);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(31, 157, 12, 28);
    label.text = @"¥";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(21);
        make.top.equalTo(34);
    }];
    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.text = @"100";
    _valueLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:38];
    _valueLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(label.right);
        make.bottom.equalTo(label).offset(5);
    }];
    
    _conditionLabel = [[UILabel alloc] init];
    _conditionLabel.frame = CGRectMake(30, 192, 76, 18);
    _conditionLabel.text = @"满500元可用";
    _conditionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _conditionLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:_conditionLabel];
    [_conditionLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.stateImageView);
        make.bottom.equalTo(self.stateImageView.bottom).offset(-13);
    }];
    
    _scopeLabel = [[UILabel alloc] init];
    _scopeLabel.text = @"仅限某某店铺某类商品使用";
    _scopeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _scopeLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_scopeLabel];
    [_scopeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(13);
        make.left.equalTo(self.stateImageView.right).offset(10);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"2017.05.04-2017.02.88";
    _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    _timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.scopeLabel.bottom).offset(18);
        make.left.equalTo(self.scopeLabel);
    }];
    
    label = [[UILabel alloc] init];
    label.text = @"详细规则";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(whiteView.bottom).offset(-5);
        make.left.equalTo(self.scopeLabel);
    }];
    
    
    _useBtton = [UIButton new];
    _useBtton.layer.cornerRadius = 11;
    _useBtton.layer.borderColor = Color00A862.CGColor;
    _useBtton.layer.borderWidth = 1;
    [_useBtton setTitle:@"立即使用" forState:UIControlStateNormal];
    _useBtton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [_useBtton setTitleColor:Color00A862 forState:UIControlStateNormal];
    [self addSubview:_useBtton];
    [_useBtton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-10);
        make.top.equalTo(46);
        make.size.equalTo(CGSizeMake(62, 22));
    }];
    
    [self drawDottedLine];
    
    _openBtn = [UIButton new];
    [_openBtn setImage:[UIImage imageNamed:@"order_fold"] forState:UIControlStateNormal];
    [self addSubview:_openBtn];
    [_openBtn addTarget:self action:@selector(onTapOpenBtn) forControlEvents:UIControlEventTouchUpInside];
    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self);
        make.bottom.equalTo(self.stateImageView);
        make.size.equalTo(CGSizeMake(40, 30));
    }];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(100);
        make.left.right.equalTo(self);
        make.height.equalTo(40);
    }];
    {
        
        UIView* line = [UIView new];
        line.backgroundColor = ColorE8E8E8E;
        [_bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(1);
            make.top.left.right.equalTo(self.bottomView);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"限品类：金科购买某某店的某类商品";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [_bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(10);
            make.centerY.equalTo(self.bottomView);
        }];
    }
    _bottomView.hidden = YES;
}

- (void)drawDottedLine{
    // 要显示虚线的view
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.frame = CGRectMake(119+10, 70, ScreenW-156, 1);
    [self addSubview:lineView];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[UIColor colorWithHexString:@"efefef"].CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1], nil ,nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (void)onTapOpenBtn{
    !_expandClick?:_expandClick();
}

@end
