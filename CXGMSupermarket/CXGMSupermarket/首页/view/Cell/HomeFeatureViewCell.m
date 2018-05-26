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
    }];
}

- (void)setImageViewFrame:(BOOL)flag
{
    if (flag) {
        [_imageView remakeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.right.equalTo(-9);
        }];
    }
}
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
    
    
}

- (void)setupUI
{
    FeatureItemView* leftItem = [FeatureItemView new];
    leftItem.desLabel.text = @"邂逅好物 发现理想生活";
    leftItem.imageView.image = [UIImage imageNamed:@"temp_wine"];
    [self addSubview:leftItem];
    [leftItem mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(11);
        make.top.equalTo(10);
        make.bottom.equalTo(-22);
        make.width.equalTo((ScreenW-11*2)/2.f);
    }];
    {
        GradientLabel* label = [[GradientLabel alloc] initWithFrame:CGRectMake(8, 10, 60, 20)];
        label.text = @"发现好货";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.colors = @[(id)[UIColor colorWithHexString:@"1EB5F2"].CGColor,(id)[UIColor colorWithHexString:@"10C0BA"].CGColor];
        [leftItem addSubview:label];
        [label setGradientLabel];
    }
    
    FeatureItemView* rightTopItem = [FeatureItemView new];
    rightTopItem.desLabel.text = @"十分惊艳来了！";
    rightTopItem.imageView.image = [UIImage imageNamed:@"temp_milk"];
    [self addSubview:rightTopItem];
    [rightTopItem setImageViewFrame:YES];
    [rightTopItem mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-11);
        make.top.equalTo(10);
        make.height.equalTo((196-10*2-5)/2.f);
        make.width.equalTo((ScreenW-11*2)/2.f);
    }];
    {
        GradientLabel* label = [[GradientLabel alloc] initWithFrame:CGRectMake(8, 10, 60, 20)];
        label.text = @"新品首发";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.colors = @[(id)[UIColor colorWithHexString:@"FF0C44"].CGColor,(id)[UIColor colorWithHexString:@"F113D0"].CGColor];
        [rightTopItem addSubview:label];
        [label setGradientLabel];
    }
    
    FeatureItemView* rightDownItem = [FeatureItemView new];
    rightDownItem.desLabel.text = @"好优选逛不停";
    rightDownItem.imageView.image = [UIImage imageNamed:@"temp_sanitary"];
    [self addSubview:rightDownItem];
    [rightDownItem setImageViewFrame:YES];
    [rightDownItem mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-11);
        make.bottom.equalTo(-22);
        make.height.equalTo((196-10*2-5)/2.f);
        make.width.equalTo((ScreenW-11*2)/2.f);
    }];
    {
        GradientLabel* label = [[GradientLabel alloc] initWithFrame:CGRectMake(8, 10, 60, 20)];
        label.text = @"品牌闪购";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.colors = @[(id)[UIColor colorWithHexString:@"FF9F0C"].CGColor,(id)[UIColor colorWithHexString:@"F11313"].CGColor];
        [rightDownItem addSubview:label];
        [label setGradientLabel];
    }
    
    UIView* bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = RGB(245,245,245);
    [self addSubview:bottomLineView];
    bottomLineView.frame = CGRectMake(0, self.dc_height - 12, ScreenW, 12);
}
@end
