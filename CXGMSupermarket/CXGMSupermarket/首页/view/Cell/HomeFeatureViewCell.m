//
//  HomeFeatureViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/5/9.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "HomeFeatureViewCell.h"
#import "GradientLabel.h"

@interface FeatureItemView ()
@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation FeatureItemView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:250/255.0 green:251/255.0 blue:250/255.0 alpha:1/1.0];
        
        [self setupUI];
    }
    return self;
}

- (void)setAdvertisement:(AdvertisementModel *)advertisement{
    _advertisement = advertisement;
    
    _desLabel.text = advertisement.adverName;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:advertisement.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}

- (void)setupUI
{
    _desLabel = [[UILabel alloc] init];
    _desLabel.text = @"邂逅好物 发现理想生活";
    _desLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _desLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self addSubview:_desLabel];
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(29);
        make.left.equalTo(8);
    }];
    
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"temp_wine"];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(-7);
        make.left.equalTo(8);
        make.top.equalTo(70);
        make.right.equalTo(-15);
    }];
}

- (void)setImageViewFrame:(BOOL)flag
{
    if (flag) {
        [_imageView remakeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(95);
            make.right.equalTo(-9);
            make.height.equalTo((196-10*2-5)/2.f-6);
        }];
    }
}
@end


@interface HomeFeatureViewCell ()
@property(nonatomic,strong)FeatureItemView* leftItem;
@property(nonatomic,strong)GradientLabel* leftLabel;

@property(nonatomic,strong)FeatureItemView* rightTopItem;
@property(nonatomic,strong)GradientLabel* rightTopLabel;

@property(nonatomic,strong)FeatureItemView* rightDownItem;
@property(nonatomic,strong)GradientLabel* rightDownLabel;
@end


@implementation HomeFeatureViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setMotionArray:(NSArray *)motionArray{
    _motionArray = motionArray;
    
    for (NSInteger i = 0 ; i < motionArray.count ; i ++) {
        AdvertisementModel* model = motionArray[i];
        
        if (i == 0) {
            _leftItem.advertisement = model;
            _leftLabel.text = model.type;
        }
        else if (i == 1){
            _rightTopItem.advertisement = model;
            _rightTopLabel.text = model.type;
        }
        else if (i == 2){
            _rightDownItem.advertisement = model;
            _rightDownLabel.text = model.type;
        }
    }
}

- (void)setupUI
{
    _leftItem = [FeatureItemView new];
    _leftItem.desLabel.text = @"邂逅好物 发现理想生活";
    _leftItem.imageView.image = [UIImage imageNamed:@"temp_wine"];
    [self addSubview:_leftItem];
    [_leftItem mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(11);
        make.top.equalTo(10);
        make.bottom.equalTo(-22);
        make.width.equalTo((ScreenW-11*2)/2.f);
    }];
    {
        _leftLabel = [[GradientLabel alloc] initWithFrame:CGRectMake(8, 10, (ScreenW-11*2)/2.f, 20)];
        _leftLabel.text = @"发现好货";
        _leftLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _leftLabel.colors = @[(id)[UIColor colorWithHexString:@"1EB5F2"].CGColor,(id)[UIColor colorWithHexString:@"10C0BA"].CGColor];
        [_leftItem addSubview:_leftLabel];
        [_leftLabel setGradientLabel];
    }
    
    _rightTopItem = [FeatureItemView new];
    _rightTopItem.desLabel.text = @"十分惊艳来了！";
    _rightTopItem.imageView.image = [UIImage imageNamed:@"temp_milk"];
    [self addSubview:_rightTopItem];
    [_rightTopItem setImageViewFrame:YES];
    [_rightTopItem mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-11);
        make.top.equalTo(10);
        make.height.equalTo((196-10*2-5)/2.f);
        make.width.equalTo((ScreenW-11*2)/2.f);
    }];
    {
        _rightTopLabel = [[GradientLabel alloc] initWithFrame:CGRectMake(8, 10, 60, 20)];
        _rightTopLabel.text = @"新品首发";
        _rightTopLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _rightTopLabel.colors = @[(id)[UIColor colorWithHexString:@"FF0C44"].CGColor,(id)[UIColor colorWithHexString:@"F113D0"].CGColor];
        [_rightTopItem addSubview:_rightTopLabel];
        [_rightTopLabel setGradientLabel];
    }
    
    _rightDownItem = [FeatureItemView new];
    _rightDownItem.desLabel.text = @"好优选逛不停";
    _rightDownItem.imageView.image = [UIImage imageNamed:@"temp_sanitary"];
    [self addSubview:_rightDownItem];
    [_rightDownItem setImageViewFrame:YES];
    [_rightDownItem mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-11);
        make.bottom.equalTo(-22);
        make.height.equalTo((196-10*2-5)/2.f);
        make.width.equalTo((ScreenW-11*2)/2.f);
    }];
    {
        _rightDownLabel = [[GradientLabel alloc] initWithFrame:CGRectMake(8, 10, 60, 20)];
        _rightDownLabel.text = @"品牌闪购";
        _rightDownLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _rightDownLabel.colors = @[(id)[UIColor colorWithHexString:@"FF9F0C"].CGColor,(id)[UIColor colorWithHexString:@"F11313"].CGColor];
        [_rightDownItem addSubview:_rightDownLabel];
        [_rightDownLabel setGradientLabel];
    }
    
    UIView* bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = RGB(245,245,245);
    [self addSubview:bottomLineView];
    bottomLineView.frame = CGRectMake(0, self.dc_height - 12, ScreenW, 12);
}
@end
