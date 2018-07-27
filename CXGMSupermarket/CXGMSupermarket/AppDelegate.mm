//
//  AppDelegate.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/1.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "IQKeyboardManager.h"
#import <UMShare/UMShare.h>
#import "CutomNavigationController.h"

#import <BaiduMapAPI_Map/BMKMapView.h>

#import "WXApi.h"
#import "WXApiManager.h"

#import <AlipaySDK/AlipaySDK.h>

#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#import <UMAnalytics/MobClick.h>


@interface AppDelegate ()<BMKGeneralDelegate,UNUserNotificationCenterDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)  BMKMapManager* mapManager;

@property(nonatomic,strong)CLLocationManager* locationManager;//定位

@property(nonatomic,assign)BOOL isLaunchedByNotification;
@property(nonatomic,strong)NSDictionary* userInfo;//通知
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self initThirdKeyboard];
    
    [self configBaiduMap];
    
    [self startUmengPush:launchOptions];
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *mvc = [[MainViewController alloc] init];
    
    self.window.rootViewController = mvc;
    [self.window makeKeyAndVisible];
    
    
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    [WXApi registerApp:@"wxd2f7d73babd9de68"];
    
    
    return YES;
}

- (void)initThirdKeyboard{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

- (void)configBaiduMap
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
//    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
//        NSLog(@"经纬度类型设置成功");
//    } else {
//        NSLog(@"经纬度类型设置失败");
//    }
    //这里使用的社区馆的key
    BOOL ret = [_mapManager start:@"owFG03WzSgLmFh7uyGuUzEIIfHWOnDUG" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}


- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark- 友盟推送
-(void)startUmengPush:(NSDictionary *)launchOptions
{
    // 配置友盟SDK产品并并统一初始化
    // [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO.
    
//    [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
    
    [UMConfigure initWithAppkey:@"5b2c9d5d8f4a9d6fa1000018" channel:@"App Store"];
    
    
    NSString* deviceID =  [UMConfigure deviceIDForIntegration];
    if ([deviceID isKindOfClass:[NSString class]]) {
        NSLog(@"服务器端成功返回deviceID  %@",deviceID);
    }
    else{
        NSLog(@"服务器端还没有返回deviceID");
    }

    /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
    
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    // [MobClick setScenarioType:E_UM_GAME];  // optional: 游戏场景设置
    

    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标等
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 用户选择了接收Push消息
            NSLog(@"用户选择了接收+++++Push消息");
            self.isLaunchedByNotification = YES;
        }else{
            // 用户拒绝接收Push消息
            NSLog(@"用户拒绝接收------Push消息");
            self.isLaunchedByNotification = NO;
        }
    }];
    
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        
    }
}

//iOS10以下使用这两个方法接收通知，
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@">>>>>>>>>iOS10  userInfo  %@",userInfo);
    
    [self saveRemoteNotification:userInfo];
    
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
}

//收到推送后调用的方法（iOS 10 以下）
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSLog(@"<<<<<<<<<iOS10  userInfo  %@",userInfo);
    
    [self saveRemoteNotification:userInfo];
    
    
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
        
//    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [self showNotificationAlert:userInfo];
    }
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

//收到推送后调用的方法（iOS 10 及以上）
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler

API_AVAILABLE(ios(10.0)){

    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSLog(@"》》》》》》》》》iOS10  willPresentNotification   userInfo  %@  \n content %@",userInfo,notification.request.content);

    [self saveRemoteNotification:userInfo];
    
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            
            NSLog(@"willPresentNotification-------11");
            
            [self showNotificationAlert:userInfo];
            
            
            //应用处于前台时的远程推送接受
            //关闭U-Push自带的弹出框
            [UMessage setAutoAlert:NO];
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
        }else{
            //应用处于前台时的本地推送接受
            
            NSLog(@"willPresentNotification-------22");
        }
    } else {
        // Fallback on earlier versions
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
        
        NSLog(@"willPresentNotification-------33");
    } else {
        // Fallback on earlier versions
        
        NSLog(@"willPresentNotification-------44");
    }
}


//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler

API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    
    NSLog(@"》》》》》》》》》iOS10  didReceiveNotificationResponse   userInfo  %@ \n content  %@",userInfo,response.notification.request.content);
    
    [self saveRemoteNotification:userInfo];

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        NSLog(@"didReceiveNotificationResponse-------1");
        //程序关闭状态点击推送消息打开

        if (self.isLaunchedByNotification) {
            [self showNotificationAlert:userInfo];
        }
        else
        {//前台运行
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                [self showNotificationAlert:userInfo];
            }
            else{//后台挂起时
                [self openRemoteNotifyDetail:userInfo];
            }
        }
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
        
        NSLog(@"didReceiveNotificationResponse-------2");
    }
    
    
}
///// 用户同意接收通知后，会调用此程序
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
//    NSLog(@"deviceToken >>>>  %@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                  stringByReplacingOccurrencesOfString: @">" withString: @""]
//                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

//成功注册registerUserNotificationSettings:后，回调的方法
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
}

/// 注册失败调用
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}
#pragma mark-
- (void)showNotificationAlert:(NSDictionary *)userInfo
{
    if (![userInfo isKindOfClass:[NSDictionary class]]) return;
        
    
    NSString* title = @"";
    NSString* message = @"";
    
    NSDictionary* apsDic = [userInfo objectForKey:@"aps"];
    
    if (apsDic)
    {
        NSString* alert = [apsDic objectForKey:@"alert"];
        title = [apsDic objectForKey:@"alert"];
        if ([alert length] >0)
        {
            NSString* string  = [userInfo objectForKey:alert];
            if ([string isKindOfClass:[NSString class]]) {
                NSArray* array = [Utility toArrayOrNSDictionary:string];
                
                if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                    
                    NSDictionary* dictionary = [array firstObject];
                    message = [dictionary objectForKey:@"content"];
                    
                    self.userInfo = dictionary;
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                        message:message
                                                                       delegate:self
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"查看",nil];
                    [alertView show];
                }
            }
        }
    }
}

- (void)saveRemoteNotification:(NSDictionary *)userInfo
{
    NSMutableArray * contentArray = [NSMutableArray array];
    [contentArray addObject:userInfo];
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSArray* array = [userDefault objectForKey:RemoteNotification_KEY];
    if (array.count > 0) {
        [contentArray addObjectsFromArray:array];
    }
    
    [userDefault setObject:contentArray forKey:RemoteNotification_KEY];
    [userDefault synchronize];
}

- (void)openRemoteNotifyDetail:(NSDictionary *)userInfo
{
    if (![userInfo isKindOfClass:[NSDictionary class]]) return;
    
    NSDictionary* apsDic = [userInfo objectForKey:@"aps"];
    if (apsDic)
    {
        NSString* alert = [apsDic objectForKey:@"alert"];
        if ([alert length] > 0)
        {
            NSString* string  = [userInfo objectForKey:alert];
            if ([string isKindOfClass:[NSString class]]) {
                NSArray* array = [Utility toArrayOrNSDictionary:string];
                
                if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                    
                    NSDictionary* dictionary = [array firstObject];
                    self.userInfo = dictionary;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Show_RemoteNotification object:nil userInfo:self.userInfo];
                    
                }
            }
        }
    }
}


#pragma mark-
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Show_RemoteNotification object:nil userInfo:self.userInfo];
        
    }
}
#pragma mark-
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    if ([url.host isEqualToString:@"safepay"]) {
        
        // 支付跳转支付宝钱包进行支付，处理支付结果
        __block BOOL paySuccess = NO;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if ([resultDic[@"resultStatus"] intValue]==9000) {
                //进入充值列表页面
                NSLog(@"支付成功");
                
                paySuccess = YES;
                
            }
            else{
                NSString *resultMes = resultDic[@"memo"];
                resultMes = (resultMes.length<=0?@"支付失败":resultMes);
                NSLog(@"%@",resultMes);
                
                paySuccess = NO;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:Show_PayResult object:nil userInfo:@{@"paySuccess":[NSNumber numberWithBool:paySuccess]}];
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"pay"])
    {
        //微信支付，处理支付结果
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}



@end
