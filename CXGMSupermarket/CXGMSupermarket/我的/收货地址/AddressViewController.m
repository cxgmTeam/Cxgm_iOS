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

#import <CoreLocation/CoreLocation.h>

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

@property (strong , nonatomic)UITableView *tableView;

@property (strong , nonatomic)NSMutableArray *addressList;

@property(nonatomic,strong)CLLocationManager* locationManager;//定位

@property (nonatomic, strong) CLPlacemark *currentPlace;

@end


@implementation AddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收货地址";
    
    UIView* bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(TAB_BAR_HEIGHT);
    }];
    
    UIButton* addBtn = [UIButton new];
    addBtn.backgroundColor = Color00A862;
    [addBtn setTitle:@"新增收获地址" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [bottomView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.equalTo(bottomView);
        make.height.equalTo(49);
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
    
    [self startLocation];
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
        if ([model.data isKindOfClass:[NSArray class]])
        {
            NSArray* array = [AddressModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            [self.addressList addObjectsFromArray:array];
            //首页是不在配送范围之内
            
            NSLog(@"[DeviceHelper sharedInstance].place %@",[DeviceHelper sharedInstance].place);
            NSLog(@"[DeviceHelper sharedInstance].defaultAddress %@",[DeviceHelper sharedInstance].defaultAddress);
            if (array.count > 0 && (self.needNewAddress && ![DeviceHelper sharedInstance].defaultAddress)) {
                //测试发现最新地址在下面
                [DeviceHelper sharedInstance].defaultAddress = [array lastObject];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:AddedNewScope_Notify object:nil];
            }
            
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
    if (self.chooseAddress) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.chooseAddress) {
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
    
    if (self.chooseAddress)
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
        
        AddressModel* address = self.addressList[indexPath.row];
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([address.dimension doubleValue],[address.longitude doubleValue]);
        BOOL flag = [Utility mutableBoundConrtolAction:self.pointsArr myCoordinate:coords];
        address.inScope = flag == YES? @"1":@"0";
        cell.isInScope = flag;
        
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
            
            if (indexPath.row == 0) {
                cell.leftLabel.text = [self.currentPlace.addressDictionary objectForKey:@"Street"];
            }
            
            typeof(self) __weak wself = self;
            cell.relocationHandler = ^{
                [wself startLocation];
            };
            
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
    
    if (self.chooseAddress)
    {
        AddressModel* address = self.addressList[indexPath.row];
        if (![address.inScope boolValue]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"该地址不在当前店铺配送范围内"]; return;
        }
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
    if (self.chooseAddress) {
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
    if (self.chooseAddress) {
        return 0;
    }
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.chooseAddress) {
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

#pragma mark-
- (void)startLocation{

    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1000.0f;
    }
    //定位服务是否可用
    BOOL enable=[CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    int status=[CLLocationManager authorizationStatus];
    if(!enable || status<3){
        //请求权限
        [self.locationManager requestWhenInUseAuthorization];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *loc = [locations firstObject];

    // 保存 Device 的现语言
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                            objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                              forKey:@"AppleLanguages"];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       if(!error){
                           for (CLPlacemark *place in placemarks) {
//                               NSLog(@"placemark.addressDictionary  %@",place.addressDictionary);
                               
                               [self.locationManager stopUpdatingLocation];
                               
                               self.currentPlace = place;
                               
                               NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                               
                               [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                               
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }
                       }
                       // 还原Device 的语言
                       [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
                   }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    
    switch([error code]) {
        case kCLErrorDenied:
        {
            errorString = @"Access to Location Services denied by user";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"前往设置打开定位功能" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorLocationUnknown:
            errorString = @"Location data unavailable";
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
    if (errorString) {
        NSLog(@"定位失败信息  %@",errorString);
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
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
