//
//  MyCenterHeadView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterHeadView.h"

@interface MyCenterHeadView ()
@property(nonatomic,strong)UIImageView* headView;
@property(nonatomic,strong)UILabel* nameLabel;
@end

@implementation MyCenterHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myCenter_topGg"]];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
    
    _headView = [UIImageView new];
    _headView.image = [UIImage imageNamed:@"myCenter_default_head"];
    [self addSubview:_headView];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"注册/登录";
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _nameLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:_nameLabel];
    

//    UIButton* editBtn = [UIButton new];
//    [editBtn setImage:[UIImage imageNamed:@"myCenter_edit"] forState:UIControlStateNormal];
//    [self addSubview:editBtn];
    
    
    _headView.layer.cornerRadius = 40;
    _headView.layer.masksToBounds = YES;
    [_headView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(80, 80));
        make.top.equalTo(55);
        make.centerX.equalTo(self);
    }];

    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self);
        make.top.equalTo(self.headView.bottom).offset(8);
    }];
    
//    [editBtn mas_makeConstraints:^(MASConstraintMaker *make){
//        make.size.equalTo(CGSizeMake(40, 40));
//        make.right.equalTo(-10);
//        make.top.equalTo(STATUS_BAR_HEIGHT);
//    }];
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLabel:)]];
}

- (void)onTapLabel:(UITapGestureRecognizer *)gesture{
    !_loginHander?:_loginHander();
}

- (void)refreshUI
{
    if ([UserInfoManager sharedInstance].isLogin) {
        UserInfo* user = [UserInfoManager sharedInstance].userInfo;
        _nameLabel.text = user.userName;
        [_headView sd_setImageWithURL:[NSURL URLWithString:user.headUrl] placeholderImage:[UIImage imageNamed:@"myCenter_default_head"]];
    }else{
        _nameLabel.text = @"注册/登录";
        _headView.image = [UIImage imageNamed:@"myCenter_default_head"];
    }
}
@end
