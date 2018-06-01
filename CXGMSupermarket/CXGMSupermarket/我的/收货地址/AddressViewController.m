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
#import "NoAddressTableCell.h"

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
    
    typeof(self) __weak wself = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself getAddressList];
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
        
        [self.tableView.mj_header endRefreshing];
    } failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
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
    if (self.selectedAddress) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectedAddress) {
        return self.addressList.count;
    }else{
        if (section == 0) {
            return 2;
        }
        return self.addressList.count>0?self.addressList.count:1;;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* tableCell = nil;
    
    if (self.selectedAddress)
    {
        AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
        if (!cell) {
            cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressTableViewCell"];
        }
        if (indexPath.item < self.addressList.count) {
            cell.address = self.addressList[indexPath.item];
        }
        WEAKSELF;
        cell.updateAddress = ^{
            AddAddressViewController* vc = [AddAddressViewController new];
            vc.address = self.addressList[indexPath.row];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        cell.deleteAddress = ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该地址?删除后无法恢复!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf deleteAddress:self.addressList[indexPath.row] indexPath:indexPath];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        };
        
        cell.setDefaultAddress = ^(BOOL isDefault){
            [weakSelf updateAddress:self.addressList[indexPath.row] isDefault:isDefault];
        };
        tableCell = cell;
    }
    else
    {
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
            if (self.addressList.count == 0) {
                NoAddressTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NoAddressTableCell"];
                if (!cell) {
                    cell = [[NoAddressTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoAddressTableCell"];
                }
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
                cell.updateAddress = ^{
                    AddAddressViewController* vc = [AddAddressViewController new];
                    vc.address = self.addressList[indexPath.row];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                
                cell.deleteAddress = ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该地址?删除后无法恢复!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [weakSelf deleteAddress:self.addressList[indexPath.row] indexPath:indexPath];
                    }];
                    
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alert addAction:okAction];
                    [alert addAction:cancel];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                };
                
                cell.setDefaultAddress = ^(BOOL isDefault){
                    [weakSelf updateAddress:self.addressList[indexPath.row] isDefault:isDefault];
                };
                tableCell = cell;
            }
            
        }
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectedAddress)
    {
        AddressModel* address = self.addressList[indexPath.row];
        if (self.selectedAddress) {
            self.selectedAddress(address);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if (indexPath.section == 0 && indexPath.row == 1) {
            MapViewController* vc = [MapViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (self.selectedAddress) {
        height = 128+10;
    }
    else
    {
        if (indexPath.section == 0) {
            height = 45;
        }else{
            if (self.addressList.count == 0) {
                height = 45;
            }else{
                height = 128+10;
            }
        }
    }

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.selectedAddress) {
        return 0;
    }
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.selectedAddress) {
        return nil;
    }
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



#pragma mark-
- (void)deleteAddress:(AddressModel *)address indexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = @{@"addressId":address.id};
    [AFNetAPIClient POST:[LoginBaseURL stringByAppendingString:APIDeleteAddress] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        
        if ([model.code intValue] == 200) {
            [self.addressList removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
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
