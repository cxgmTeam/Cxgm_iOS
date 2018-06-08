//
//  SettingViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/12.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSArray* titleArray;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    self.titleArray = @[@"开启通知",@"清除缓存",@"当前版本",@"关于我们"];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenW, 42)];
    
    UIButton* button = [UIButton new];
    button.layer.cornerRadius = 4;
    button.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [button setTitle:@"注销账号" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(20);
        make.height.equalTo(42);
        make.left.equalTo(25);
        make.width.equalTo(ScreenW-50);
    }];
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = view;
    
}

- (void)onTapButton:(id)sender
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:@"确认注销账号" preferredStyle:UIAlertControllerStyleAlert];
    
    WEAKSELF;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){

    }];
    [alter addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [[UserInfoManager sharedInstance] deleteUserInfo];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutAccount_Success object:nil];
    }];
    [alter addAction:okAction];
    
    [self presentViewController:alter animated:YES completion:nil];
}

#pragma mark-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    SettingTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.leftLabel.text = self.titleArray[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            cell.rightLabel.hidden = YES;
            cell.switchButton.hidden = NO;
            cell.arrowView.hidden = YES;
        }
            break;
        case 1:{
            cell.rightLabel.hidden = YES;
            cell.switchButton.hidden = YES;
            cell.arrowView.hidden = NO;
        }
            break;
        case 2:{
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            cell.rightLabel.text = [NSString stringWithFormat:@"V %@",appVersion];
            
            cell.rightLabel.hidden = NO;
            cell.switchButton.hidden = YES;
            cell.arrowView.hidden = YES;
        }
            break;
        case 3:{
            cell.rightLabel.hidden = YES;
            cell.switchButton.hidden = YES;
            cell.arrowView.hidden = NO;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [[[SDWebImageManager sharedManager] imageCache] clearMemory];
        [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:^{
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"清理完成"];
        }];

    }
}

@end
