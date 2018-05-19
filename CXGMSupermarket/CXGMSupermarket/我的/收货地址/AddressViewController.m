//
//  AddressViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AddressViewController.h"

#import "AddAddressViewController.h"

#import "MapViewController.h"

#import "AddressTopTableViewCell.h"
#import "AddressTableViewCell.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic)UITableView *tableView;

@property (strong , nonatomic)NSMutableArray *addressList;
@end


@implementation AddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    
    UIButton* addBtn = [UIButton new];
    addBtn.backgroundColor = Color00A862;
    [addBtn setTitle:@"新增收获地址" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];

    self.addressList = [NSMutableArray array];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(addBtn.top);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getAddressList];
}

- (void)getAddressList
{
    if (![UserInfoManager sharedInstance].isLogin) return;
    
    //点击设为默认 刷新列表会崩溃
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    
    [self.addressList removeAllObjects];

    [AFNetAPIClient GET:[LoginBaseURL stringByAppendingString:APIAddressList] token:userInfo.token parameters:nil success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = [AddressModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            [self.addressList addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    } failure:^(id JSON, NSError *error){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)onTapButton:(id)sender{
    if (![UserInfoManager sharedInstance].isLogin){
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        return;
    }
    
    AddAddressViewController* vc = [AddAddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return self.addressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* tableCell;
    if (indexPath.section == 0) {
        AddressTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTopTableViewCell"];
        if (!cell) {
            cell = [[AddressTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressTopTableViewCell"];
        }
        cell.indexPath = indexPath;
        tableCell = cell;
    }
    else
    {
        AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
        if (!cell) {
            cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressTableViewCell"];
        }
        if (indexPath.item < self.addressList.count) {
            cell.address = self.addressList[indexPath.item];
        }
        WEAKSELF;
        cell.updateAddress = ^(AddressModel *address){
            AddAddressViewController* vc = [AddAddressViewController new];
            vc.address = self.addressList[indexPath.row];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.setDefaultAddress = ^(BOOL isDefault){
            [weakSelf updateAddress:self.addressList[indexPath.row] isDefault:isDefault];
        };
        tableCell = cell;
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        MapViewController* vc = [MapViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 45;
    }else{
        height = 128+10;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 42)];
    head.backgroundColor = [UIColor colorWithHexString:@"f2f3f4"];
    UILabel *label = [[UILabel alloc] init];
    if (section == 0) {
        label.text = @"当前定位";
    }else{
        label.text = @"我的收获地址";
    }
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [head addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(head);
    }];
    return head;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AddressModel* address = self.addressList[indexPath.row];
        
        [self deleteAddress:address indexPath:indexPath];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return   UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)deleteAddress:(AddressModel *)address indexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = @{@"addressId":address.id};
    [AFNetAPIClient POST:[LoginBaseURL stringByAppendingString:APIDeleteAddress] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        
        if ([model.code intValue] == 200) {
            [self.addressList removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)updateAddress:(AddressModel *)address isDefault:(BOOL)flag
{
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    
    NSDictionary* dic = @{
                        @"id": address.id,
                        @"address": address.address,
                        @"area": address.area,
                        @"dimension": address.dimension,
                        @"longitude": address.longitude,
                        @"phone": address.phone,
                        @"realName": address.realName,
                        @"isDef": flag == YES?@"1":@"0",
                        };
    
    WEAKSELF;
    [Utility CXGMPostRequest:[LoginBaseURL stringByAppendingString:APIUpdateAddress] token:userInfo.token parameter:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            [weakSelf getAddressList];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

#pragma mark- init

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
