//
//  HomeViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/10.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "HomeViewController.h"
#import "GoodsDetailViewController.h"
#import "SubCategoryController.h"

#import "HomeGoodsView.h"
#import "HomeShopsView.h"

#import "SearchViewController.h"
#import "AddressViewController.h"

#import "MessageViewController.h"

#import "HYNoticeView.h"

#import "GoodsDetailViewController.h"
#import "WebViewController.h"


@interface HomeViewController ()
@property(nonatomic,strong)HomeGoodsView* goodsView;
@property(nonatomic,strong)HomeShopsView* shopsView;

@property(nonatomic,strong)UIView* topView;

@property(nonatomic,assign)BOOL inScope;

@property(nonatomic,strong)HYNoticeView *noticeHot;

@property(nonatomic,assign)BOOL isVisible;

@property(nonatomic,assign)BOOL needNewAddress;//需要添加新地址，寻找店铺
@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTopBar];
    
    [self setupMainUI:NO];
    
    [self setNoticeLocation];
    
    [self checkAppUpdate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRemoteNotification:) name:Show_RemoteNotification object:nil];

}

- (void)setNoticeLocation
{
    [_noticeHot removeFromSuperview];
    _noticeHot = nil;
    
    NSString* address = @"当前位置不在配送范围内，请选择收货地址";
    self.needNewAddress = YES;
    
    if ([DeviceHelper sharedInstance].defaultAddress) {
        AddressModel* defAddress = [DeviceHelper sharedInstance].defaultAddress;
        address = [@"送货至：" stringByAppendingString:defAddress.area] ;
        
        self.needNewAddress = NO;
        
    }
    else if ([DeviceHelper sharedInstance].place && [DeviceHelper sharedInstance].locationInScope)
    {
        NSDictionary* dic = [DeviceHelper sharedInstance].place.addressDictionary;
        if (dic[@"SubLocality"]) {
            address = [@"送货至：" stringByAppendingString:dic[@"SubLocality"]];
        }
         if (dic[@"Street"]) {
             address = [address stringByAppendingString:dic[@"Street"]] ;
         }
        
        self.needNewAddress = NO;
    
    }
    
    CGFloat width = [self sizeLabelWidth:address];
    CGRect frame = CGRectMake(10, NAVIGATION_BAR_HEIGHT-25, width, 30);
    if (iPhoneX) {
        frame = CGRectMake(10, NAVIGATION_BAR_HEIGHT-50, width, 30);
    }
    
    _noticeHot = [[HYNoticeView alloc] initWithFrame:frame text:address position:HYNoticeViewPositionTopLeft];
    [_noticeHot showType:HYNoticeTypeTestHot inView:self.navigationController.navigationBar];
}



- (void)setupMainUI:(BOOL)inScope
{
    self.inScope = inScope;
    
    if (self.isVisible) {
        [self setNoticeLocation];
    }else{
        [_noticeHot removeFromSuperview];
        _noticeHot = nil;
    }
    
    
    if (inScope)
    {
        if (_shopsView.superview) {
            [_shopsView removeFromSuperview];
            _shopsView = nil;
        }
        
        if (!_goodsView)
        {
            _goodsView = [HomeGoodsView new];
            [self.view addSubview:_goodsView];
            [_goodsView mas_makeConstraints:^(MASConstraintMaker *make){
                make.edges.equalTo(self.view);
            }];

            
            typeof(self) __weak wself = self;
            _goodsView.showSubCategoryVC = ^(NSArray * array){
                SubCategoryController* vc = [SubCategoryController new];
                vc.categoryArr = array;
                [wself.navigationController pushViewController:vc animated:YES];
            };
            
            _goodsView.showGoodsDetailVC = ^(GoodsModel *model){
                GoodsDetailViewController* vc = [GoodsDetailViewController new];
                vc.goodsId = model.id;
                [wself.navigationController pushViewController:vc animated:YES];
            };
            _goodsView.showBusinessDetailVC = ^(AdBannarModel* model){
                if ([model.urlType isEqualToString:@"1"]) {
                    WebViewController* vc = [WebViewController new];
                    vc.urlString = model.productCode;
                    [wself.navigationController pushViewController:vc animated:YES];
                }
                if ([model.urlType isEqualToString:@"2"]){
                    GoodsDetailViewController* vc = [GoodsDetailViewController new];
                    vc.goodsId = model.productCode;
                    [wself.navigationController pushViewController:vc animated:YES];
                }
            };
            _goodsView.showAdvertiseDetailVC = ^(AdvertisementModel* ad){
                if ([ad.type isEqualToString:@"1"]) {
                    WebViewController* vc = [WebViewController new];
                    vc.urlString = ad.notifyUrl;
                    [wself.navigationController pushViewController:vc animated:YES];
                }
                if ([ad.type isEqualToString:@"2"]) {
                    GoodsDetailViewController* vc = [GoodsDetailViewController new];
                    vc.goodsId = ad.productCode;
                    [wself.navigationController pushViewController:vc animated:YES];
                }
            };

        }else{
            [_goodsView requestGoodsList];
        }
    }
    else
    {
        if (_goodsView.superview) {
            [_goodsView removeFromSuperview];
            _goodsView = nil;
        }
        
        if (!_shopsView)
        {
            _shopsView = [HomeShopsView new];
            [self.view addSubview:_shopsView];
            [_shopsView mas_makeConstraints:^(MASConstraintMaker *make){
                make.edges.equalTo(self.view);
            }];
            typeof(self) __weak wself = self;
            _shopsView.selectShopHandler = ^{
                [wself setupMainUI:YES];
            };
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    self.isVisible = YES;
    
    _topView.hidden = NO;
    
    [self setNoticeLocation];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    

    self.isVisible = NO;
    
    _topView.hidden = YES;
    
    [_noticeHot removeFromSuperview];
    _noticeHot = nil;
    

}

- (void)setupTopBar
{
    UIButton* locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [locationBtn setImage:[UIImage imageNamed:@"order_address_white"] forState:UIControlStateNormal];
    locationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [locationBtn addTarget:self action:@selector(showAddressVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];

    
    UIButton* messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [messageBtn setImage:[UIImage imageNamed:@"top_message"] forState:UIControlStateNormal];
    messageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [messageBtn addTarget:self action:@selector(showMessageVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(50, (44-28)/2, ScreenW-100, 28)];
    [self.navigationController.navigationBar addSubview:_topView];
    
    CustomTextField* textField = [CustomTextField new];
    textField.layer.cornerRadius = 14;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:242/255.0 alpha:1/1.0];
    textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"top_searchBar_search"];
    textField.leftView = imgView;
    textField.placeholder = @"特惠三文鱼";
    [_topView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.topView);
    }];
    
    UIButton* btn = [UIButton new];
    [_topView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.topView);
    }];
    [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showAddressVC:(id)sender
{
    AddressViewController* vc = [AddressViewController new];
    vc.needNewAddress = self.needNewAddress;
    typeof(self) __weak wself = self;
    vc.selectedAddress = ^(AddressModel * address){
        [DeviceHelper sharedInstance].defaultAddress = address;
        [wself setNoticeLocation];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMessageVC:(id)sender
{
    MessageViewController* vc = [MessageViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)onTapButton:(id)sender
{
    SearchViewController* vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showRemoteNotification:(NSNotification *)notify
{
    NSDictionary* dic = [notify userInfo];
    
    //type为0时跳转商品详情，type为1时直接打开H5连接
    if ([dic[@"type"] intValue] == 0)
    {
        GoodsDetailViewController* vc = [GoodsDetailViewController new];
        vc.goodsId = dic[@"goodcode"];
        vc.shopId = dic[@"shopId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([dic[@"type"] intValue] == 1)
    {
        WebViewController* vc = [WebViewController new];
        vc.urlString = dic[@"goodcode"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark-
- (CGFloat)sizeLabelWidth:(NSString *)text
{
    CGFloat titleWidth = SCREENW*0.6;
    
    if (text.length > 0) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]};
        
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        titleWidth = ceilf(textSize.width)+20;
    }
    if (titleWidth >= SCREENW) {
        titleWidth = SCREENW-20;
    }
    return titleWidth;
}

#pragma mark- 检查更新
-(void)checkAppUpdate
{
    NSString* appid = @"1394406457";
    NSDictionary* infoDict=[[NSBundle mainBundle] infoDictionary];
    NSString* nowVersion=[infoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appid]];
    NSString* file=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (!file) {
        return;
    }
    
    NSError *err = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[file dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if ([dict[@"resultCount"] integerValue] == 0) {
        return;
    }
    NSRange substr=[file rangeOfString:@"\"version\":\""];//判断是不是找到字符
    NSRange range1=NSMakeRange(substr.location+substr.length,10);
    NSRange substr2=[file rangeOfString:@"\""options:NSCaseInsensitiveSearch range:range1];
    NSRange range2=NSMakeRange(substr.location+substr.length,substr2.location-substr.location-substr.length);
    NSString*newVersion=[file substringWithRange:range2];
    
    NSLog(@"nowVersion %@   newVersion %@",nowVersion,newVersion);
    if (newVersion)
    {
        BOOL flag = [self compareEditionNumber:newVersion localNumber:nowVersion];
        if (flag) {
            [[[UIAlertView alloc] initWithTitle:@"发现新版本"
                                        message:@"是否前往App Store更新?"
                                       delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"更新", nil] show];
        }
    }
    
}

//输出YES（服务器大与本地） 输出NO（服务器小于本地）
- (BOOL)compareEditionNumber:(NSString *)serverNumberStr localNumber:(NSString*)localNumberStr {
    //剔除版本号字符串中的点
    serverNumberStr = [serverNumberStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    localNumberStr = [localNumberStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    //计算版本号位数差
    int placeMistake = (int)(serverNumberStr.length-localNumberStr.length);
    //根据placeMistake的绝对值判断两个版本号是否位数相等
    if (abs(placeMistake) == 0) {
        //位数相等
        return [serverNumberStr integerValue] > [localNumberStr integerValue];
    }else {
        //位数不等
        //multipleMistake差的倍数
        NSInteger multipleMistake = pow(10, abs(placeMistake));
        NSInteger server = [serverNumberStr integerValue];
        NSInteger local = [localNumberStr integerValue];
        if (server > local) {
            return server > local * multipleMistake;
        }else {
            return server * multipleMistake > local;
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        NSString* appid = @"1394406457";
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",appid ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark-
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
