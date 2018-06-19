//
//  MainViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/1.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"

#import "HomeViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)CLLocationManager* locationManager;//定位

@property(nonatomic,strong)UILabel* titleLabel;

@property(nonatomic,strong)HomeViewController* homeVC;

@property(nonatomic,assign)NSInteger  currentIndex;

@property(nonatomic,strong)UITabBarItem* cartItem;

@property(nonatomic,assign)NSInteger  requestCount;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    label.text = @"";
    self.navigationItem.titleView = label;
    self.titleLabel = label;
    
    NSArray* vc = @[@"HomeViewController",
                    @"CategoryViewController",
                    @"ShoppingCartController",
                    @"MyCenterViewController"];
    
    NSArray* title = @[@"首页",
                       @"分类",
                       @"购物车",
                       @"我的"];
    
    NSArray* image = @[@"tab_item0",
                       @"tab_item1",
                       @"tab_item2",
                       @"tab_item3"];
    
    NSArray* selectedImage = @[@"tab_item0_selected",
                               @"tab_item1_selected",
                               @"tab_item2_selected",
                               @"tab_item3_selected"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : PFR10Font,
                                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : PFR10Font,
                                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"00A862"]
                                                        } forState:UIControlStateSelected];
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSInteger i = 0; i < vc.count; i++)
    {
        NSString* string = vc[i];
        CustomViewController* controller = [NSClassFromString(string) new];
        if (i == 0) {
            self.homeVC = (HomeViewController *)controller;
        }
        CutomNavigationController *nav = [[CutomNavigationController alloc] initWithRootViewController:controller];
        if (i == vc.count-1) {
            nav.navigationBarHidden = YES;
        }
        
        UITabBarItem* barItem = [[UITabBarItem alloc]initWithTitle:title[i] image:[UIImage imageNamed:image[i]] selectedImage:[[UIImage imageNamed:selectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        barItem.tag = i;
        
        if (i == 2) {
            self.cartItem = barItem;
        }
        
        nav.tabBarItem = barItem;
        [array addObject:nav];
    }
    self.viewControllers = array;
    
    self.currentIndex = 0;
    
    //添加通知
    [self addNotification];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if (item.tag == 2 && ![UserInfoManager sharedInstance].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        vc.showCart = YES;
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    self.currentIndex = item.tag;
    
    switch (item.tag) {
        case 0:
            self.titleLabel.text = @"";
            break;
        case 1:
            self.titleLabel.text = @"分类";
            break;
        case 2:
            self.titleLabel.text = @"购物车";
            break;
        case 3:
            self.titleLabel.text = @"";
            break;
            
        default:
            break;
    }
}


#pragma mark-
- (void)addNotification
{
    //这个地方不能总是去刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocationCity:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWindowHomeNotify:) name:WindowHomePage_Notify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLoginVC:) name:ShowLoginVC_Notify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDontShowCart:) name:DontShowCart_Notify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopCartNumber) name:AddGoodsSuccess_Notify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopCartNumber) name:AddOrder_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopCartNumber) name:DeleteShopCart_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopCartNumber) name:LoginAccount_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopCartNumber) name:LogoutAccount_Success object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomePage:) name:AddedNewScope_Notify object:nil];
}


- (void)onWindowHomeNotify:(NSNotification *)notify{
    self.selectedIndex = 0;
    self.titleLabel.text = @"";
    
    self.currentIndex = self.selectedIndex;
}


- (void)presentLoginVC:(NSNotification *)notify{
    LoginViewController * vc = [LoginViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)onDontShowCart:(NSNotification *)notify{
    self.selectedIndex = self.currentIndex;
}

- (void)getShopCartNumber
{
    if (![UserInfoManager sharedInstance].isLogin){
        self.cartItem.badgeValue = nil;
        return;
    }
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    NSDictionary* dic = @{
                          @"pageNum":@"1",
                          @"pageSize":@"0",
                          @"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""
                          };

    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APIShopCartList] token:userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.code isEqualToString:@"200"]) {
            if ([model.listModel.total intValue]==0) {
                self.cartItem.badgeValue = nil;
            }else if ([model.listModel.total intValue]>99){
                self.cartItem.badgeValue = @"99+";
            }else{
                self.cartItem.badgeValue = [NSString stringWithFormat:@"%@",model.listModel.total];
            }
            
            [DeviceHelper sharedInstance].shopCartNum = model.listModel.total;
        }
    } failure:^(id JSON, NSError *error){

    }];
}

- (void)refreshHomePage:(NSNotification *)notify
{
    NSLog(@"%s",__func__);
    AddressModel* address = [DeviceHelper sharedInstance].defaultAddress;
    
    [self checkAddress:address.longitude dimension:address.dimension isLocation:NO];
}

#pragma mark- 定位


- (void)getAddressList
{
    //当前地址不在配送范围内，未登录请求不到地址列表
    if (![UserInfoManager sharedInstance].isLogin){
        
        [DeviceHelper sharedInstance].place = nil;
        [self.homeVC setupMainUI:NO];
    
        return;
    }
    

    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[LoginBaseURL stringByAppendingString:APIAddressList] token:userInfo.token parameters:nil success:^(id JSON, NSError *error){

        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = [AddressModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            if (array.count > 0)
            {
                AddressModel* address;
                //这里是默认地址  还需要判断最后一个地址
                if (self.requestCount == 0) {
                    address = [array firstObject];
                    
                    [DeviceHelper sharedInstance].defaultAddress = address;
                    
                    self.requestCount = 1;
                }else{
                    address = [array lastObject];
                    
                    [DeviceHelper sharedInstance].defaultAddress = address;
                    
                    self.requestCount = 2;
                }
                
                [wself checkAddress:address.longitude dimension:address.dimension isLocation:NO];
            }else{

                [DeviceHelper sharedInstance].place = nil;
                [DeviceHelper sharedInstance].defaultAddress = nil;
                [self.homeVC setupMainUI:NO];
            }
        }
        
    } failure:^(id JSON, NSError *error){

    }];
}

/*
 第一规则是
 1.实际地址在配送范围 显示实际地址
 2.不在配送范围显示最后一次送达地址，首页展示该地址对应的店铺首页
 3.不在配送范围 又没有配送过 显示不在配送范围
 */

- (void)startLocationCity:(NSNotification *)notify
{
    self.requestCount = 0;
    
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
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *loc = [locations firstObject];
//维度：loc.coordinate.latitude
//经度：loc.coordinate.longitude
    
    [DeviceHelper sharedInstance].location = loc;
    
    NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    NSLog(@"locations.count  %ld",locations.count);
    
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[loc coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
        
        [self checkAddress:[NSString stringWithFormat:@"%lf",coord.longitude] dimension:[NSString stringWithFormat:@"%lf",coord.latitude] isLocation:YES];
    }
    else
    {
        [self checkAddress:[NSString stringWithFormat:@"%lf",loc.coordinate.longitude] dimension:[NSString stringWithFormat:@"%lf",loc.coordinate.latitude] isLocation:YES];
    }
    
    
    // 保存 Device 的现语言
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                            objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                              forKey:@"AppleLanguages"];
    WEAKSELF;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       if(!error){
                           for (CLPlacemark *place in placemarks) {
                               NSLog(@"placemark.addressDictionary  %@",place.addressDictionary);
                               
                               [self.locationManager stopUpdatingLocation];
                               
                               [DeviceHelper sharedInstance].place = place;
                               
                               [weakSelf.homeVC setNoticeLocation];
                               
                               NSString *city = place.locality;
                               NSString *administrativeArea = place.administrativeArea;
                               if ([city isEqualToString:administrativeArea]) {

                               }
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
        
        [self locationFailed];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


- (void)checkAddress:(NSString *)longitude dimension:(NSString *)dimension isLocation:(BOOL)location
{
    NSDictionary* dic = @{
                          @"longitude":longitude,
                          @"dimension":dimension
                          };
    WEAKSELF;
    //data为空代表不在配送范围内
    [AFNetAPIClient POST:[LoginBaseURL stringByAppendingString:APICheckAddress] token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray *)model.data;
            //在配送范围内
            if (array.count > 0) {
                [DeviceHelper sharedInstance].shop = [[ShopModel alloc] initWithDictionary:[array firstObject] error:nil];
                
                [weakSelf getShopCartNumber];
                
                [weakSelf.homeVC setupMainUI:YES];
            }else{
                //这个地方要出去
                if (location || self.requestCount == 1) {
                    [weakSelf getAddressList];
                }else{
                    
                    [DeviceHelper sharedInstance].place = nil;
                    [DeviceHelper sharedInstance].defaultAddress = nil;
                    [weakSelf.homeVC setupMainUI:NO];
                }
            }
        }else{
            [DeviceHelper sharedInstance].place = nil;
            [weakSelf.homeVC setupMainUI:NO];
        }
    } failure:^(id JSON, NSError *error){
        [DeviceHelper sharedInstance].place = nil;
        [weakSelf.homeVC setupMainUI:NO];
    }];
}

- (void)locationFailed
{
    [self.homeVC setupMainUI:NO];
}

#pragma mark-
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
