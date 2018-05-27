//
//  SelectTimeController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "SelectTimeController.h"

@implementation TimeItem
@end


@implementation LeftTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"明日";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(self);
        }];
    }
    return self;
}
@end


@interface RightTabelCell ()
@property(nonatomic,strong)UILabel* contentLabel;
@property(nonatomic,strong)UIImageView* markView;
@end

@implementation RightTabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"09:00-18:00";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(12);
        }];
        _contentLabel = label;
        
        _markView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_selected"]];
        [self.contentView addSubview:_markView];
        [_markView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.right.equalTo(-10);
        }];
        
        UIView* line = [UIView new];
        line.backgroundColor = ColorE8E8E8E;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(12);
            make.right.equalTo(-12);
            make.bottom.equalTo(self);
            make.height.equalTo(1);
        }];
    }
    return self;
}

- (void)setTimeItem:(TimeItem *)timeItem
{
    _contentLabel.text = timeItem.title;
    if (timeItem.selected) {
        _contentLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    }else{
        _contentLabel.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    }
    
    _markView.hidden = !timeItem.selected;
}

@end






@interface SelectTimeController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* leftTable;
@property(nonatomic,strong)UITableView* rightTable;

@property(nonatomic,strong)NSMutableArray* rightArray;

@property(nonatomic,strong)TimeItem* selectItem;
@end

@implementation SelectTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMaskView:)]];
    

    UIButton* button = [UIButton new];
    button.backgroundColor = Color00A862;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];
    [button addTarget:self action:@selector(onTapConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightArray = [NSMutableArray array];
    
    TimeItem* item = [TimeItem new];
    item.title = @"09:00-18:00";
    item.selected = YES;
    [self.rightArray addObject:item];
    
    self.selectItem = item;
    
    item = [TimeItem new];
    item.title = @"18:00-22:00";
    item.selected = NO;
    [self.rightArray addObject:item];
    
    
    [self setupUI];
    
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

- (void)onTapConfirmBtn:(UIButton *)button
{
    !_selectedTimeFinish?:_selectedTimeFinish(self.selectItem.title);
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- UITabelView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTable) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* tableCell = nil;
    if (tableView == _leftTable) {
        LeftTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LeftTableCell"];
        if (!cell) {
            cell = [[LeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftTableCell"];
        }
        tableCell = cell;
    }else{
        RightTabelCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RightTabelCell"];
        if (!cell) {
            cell = [[RightTabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RightTabelCell"];
        }
        cell.timeItem = self.rightArray[indexPath.row];
        tableCell = cell;
    }
    
    return tableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTable) {
        return 45;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (TimeItem* item in self.rightArray) {
        item.selected = NO;
    }
    TimeItem* item = self.rightArray[indexPath.row];
    item.selected = YES;
    self.selectItem = item;
    
    [_rightTable reloadData];
}


#pragma mark- init
-  (void)setupUI
{
    UIView* contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(-50);
        make.height.equalTo(221);
    }];
    
    UIButton* closeBtn = [UIButton new];
    [closeBtn setImage:[UIImage imageNamed:@"close_fork"] forState:UIControlStateNormal];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.right.equalTo(contentView);
        make.width.height.equalTo(44);
    }];
    [closeBtn addTarget:self action:@selector(onTapCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"选择送达时间";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(contentView);
        make.top.equalTo(14);
    }];

    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(1);
        make.top.equalTo(45);
        make.left.right.equalTo(contentView);
    }];
    
    _leftTable = [UITableView new];
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _leftTable.backgroundColor = [UIColor colorWithHexString:@"F2F5F5"];
    [contentView addSubview:_leftTable];
    [_leftTable mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.bottom.equalTo(contentView);
        make.top.equalTo(line.bottom);
        make.width.equalTo(70);
    }];
    
    _rightTable = [UITableView new];
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [contentView addSubview:_rightTable];
    [_rightTable mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.bottom.equalTo(contentView);
        make.top.equalTo(self.leftTable);
        make.left.equalTo(self.leftTable.right);
    }];
    
}


@end
