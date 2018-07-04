//
//  MessageViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;

@property(nonatomic,strong)NSArray* titleArray;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    self.titleArray = @[@"限时抢购",
                        @"客服助手",
                        @"通知消息",
                        @"最新资讯"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}

#pragma mark-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageTableViewCell"];
    }
    cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"message_%ld",(long)indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 63;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end
