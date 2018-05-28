//
//  InvitationViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "InvitationViewController.h"
#import "InvitationTableHead.h"

#import "InvitationTableCell.h"

@interface InvitationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView* colorView;
@property(nonatomic,strong)UITableView* tableView;
@end

@implementation InvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请有礼";
    
    [self setupUI];
}


#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InvitationTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationTableCell"];
    if (!cell) {
        cell = [[InvitationTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InvitationTableCell"];
    }
    return cell;
}

- (void)setupUI
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myCenter_invite"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(ScreenW*736/750.f);
    }];
    
    UIView* whiteView = [UIView new];
    whiteView.layer.cornerRadius = 4;
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(166);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(imageView.bottom).offset(32);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"邀请新人送30元";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(whiteView);
        make.top.equalTo(25);
    }];
    
    label = [[UILabel alloc] init];
    label.numberOfLines = 2;
    label.text = @"邀请新用户下单签收，即得30元红包，新用户另得60元新人礼包";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.width.equalTo(ScreenW-60);
        make.top.equalTo(59);
    }];
    
    UIButton *button = [UIButton new];
    button.layer.cornerRadius = 4;
    button.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [button setTitle:@"立即邀请" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [whiteView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(11);
        make.right.equalTo(-11);
        make.height.equalTo(42);
        make.bottom.equalTo(-25);
    }];
    
    label = [[UILabel alloc] init];
    label.text = @"您已邀请 12 位好友";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:51/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(whiteView.bottom).offset(25);
        make.centerX.equalTo(whiteView);
    }];
    
    _colorView = [[UIView alloc] init];
    _colorView.layer.cornerRadius = 7;
    _colorView.backgroundColor = [UIColor colorWithRed:255/255.0 green:238/255.0 blue:208/255.0 alpha:1/1.0];
    [self.view addSubview:_colorView];
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.bottom).offset(10);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(-15);
    }];
    
    InvitationTableHead* head = [InvitationTableHead new];
    [_colorView addSubview:head];
    [head mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.colorView);
        make.height.equalTo(45);
    }];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 12+20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_colorView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(head.bottom);
        make.left.right.bottom.equalTo(self.colorView);
    }];
}

@end
