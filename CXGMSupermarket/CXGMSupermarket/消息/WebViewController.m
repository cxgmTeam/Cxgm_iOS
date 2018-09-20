//
//  WebViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/7/9.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "OCJSHelper.h"

#import "GoodsDetailViewController.h"
#import "AnotherCartViewController.h"
#import "CartBadgeView.h"

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate,CartBadgeDelegate>
@property(nonatomic,strong)WKWebView* webView;
@property(nonatomic,strong)OCJSHelper *ocjsHelper;
@property(nonatomic,assign)BOOL needLogin;
@property(nonatomic,strong)GoodsModel * goods;
@property(nonatomic,strong)NSMutableArray * shopCartList;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
    
    if ([self.urlString length] > 0)
    {
        if ([self.urlString containsString:@"http://"] || [self.urlString containsString:@"https://"]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        }else{
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://" stringByAppendingString:self.urlString]]]];
        }
    }
    
    self.shopCartList = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopCart) name:LoginAccount_Success object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.shopCartList removeAllObjects];
    if ([UserInfoManager sharedInstance].isLogin) {
        [self.shopCartList addObjectsFromArray:[DeviceHelper sharedInstance].shopCartList];
    }
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"%s  %@",__func__,[webView.URL absoluteString]) ;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)setUpUI
{
    
    CartBadgeView* cartBtn = [[CartBadgeView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    cartBtn.delegate = self;
    [cartBtn.carButton setImage:[UIImage imageNamed:@"top_cart"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cartBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    // 交互对象设置
    [config.userContentController addScriptMessageHandler:(id)self.ocjsHelper name:@"gotoGoodsDetail"];
    [config.userContentController addScriptMessageHandler:(id)self.ocjsHelper name:@"addGoodsToCart"];
    // 支持内嵌视频播放，不然网页中的视频无法播放
    config.allowsInlineMediaPlayback = YES;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.ocjsHelper.webView = self.webView;

    
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.webView.navigationDelegate = self;
    [self.webView setMultipleTouchEnabled:YES];
    [self.webView setAutoresizesSubviews:YES];
    [self.webView.scrollView setAlwaysBounceVertical:YES];
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}

- (OCJSHelper *)ocjsHelper {
    if (!_ocjsHelper) {
        _ocjsHelper = [[OCJSHelper alloc] initWithDelegate:(id)self vc:self];
    }
    return _ocjsHelper;
}

#pragma mark-
- (void)shopCarButtonClickAction
{
    if (![UserInfoManager sharedInstance].isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        return ;
    }
    
    AnotherCartViewController* vc = [AnotherCartViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-
- (void)showGoodsDetail:(NSString *)productId andShop:(NSString *)shopId
{
    GoodsDetailViewController* vc = [GoodsDetailViewController new];
    vc.goodsId = productId;
    vc.shopId = shopId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addGoodsToCart:(NSDictionary *)dic
{
    self.goods = [GoodsModel new];
    self.goods.name = dic[@"goodName"];
    self.goods.id = dic[@"productId"];
    self.goods.goodCode = dic[@"goodCode"];
    self.goods.productCategoryId = dic[@"categoryId"];
    self.goods.price = dic[@"price"];
    self.goods.shopId = dic[@"shopId"];
    

    self.needLogin = NO;
    if (![UserInfoManager sharedInstance].isLogin) {
        self.needLogin = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        return ;
    }else{
        [self addOrUpdateCart];
    }
    
}


- (void)addOrUpdateCart
{
    BOOL flag = NO;

    for (GoodsModel * model in self.shopCartList) {
        if ([model.goodCode isEqualToString:self.goods.goodCode]) {
            self.goods.shopCartNum = model.goodNum;
            self.goods.shopCartId = model.id;
            [self updateCart:self.goods];
            flag = YES;
            break;
        }
    }
    if (flag == NO) {
        [self addCart:self.goods];
    }
}

- (void)getShopCart
{
    if (!self.needLogin) return;
    
    if ([[DeviceHelper sharedInstance].shop.id length] == 0) return;
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    NSDictionary* dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APIShopCartList] token:userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [DataModel dataModelWith:JSON];
    
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            [DeviceHelper sharedInstance].shopCartList = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            [self.shopCartList addObjectsFromArray:[DeviceHelper sharedInstance].shopCartList];
            [wself addOrUpdateCart];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}


- (void)addCart:(GoodsModel *)goods
{
    NSDictionary* dic = @{
                          @"id":goods.id.length>0?goods.id:@"",
                          @"amount":goods.price.length>0?goods.price:@"",
                          @"goodCode":goods.goodCode.length>0?goods.goodCode:@"",
                          @"goodName":goods.name.length>0?goods.name:@"",
                          @"goodNum":@"1",
                          @"categoryId":goods.productCategoryId.length>0?goods.productCategoryId:@"",
                          @"shopId":goods.shopId.length>0?goods.shopId:[DeviceHelper sharedInstance].shop.id,
                          @"productId":goods.id.length>0?goods.id:@"",
                          };
    
    
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIShopAddCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{

                self.goods.id = [NSString stringWithFormat:@"%d",[(NSNumber *)model.data intValue]];
                self.goods.goodNum = @"1";
                [self.shopCartList addObject:self.goods];
                
                [MBProgressHUD MBProgressHUDWithView:self.view Str:@"添加成功！"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:AddGoodsSuccess_Notify object:nil userInfo:nil];
            });
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)updateCart:(GoodsModel *)goods
{
    CGFloat amount = (1+[goods.shopCartNum integerValue])*[goods.price floatValue];
    
    NSDictionary* dic = @{@"id":goods.shopCartId.length>0?goods.shopCartId:@"",
                          @"amount":[NSString stringWithFormat:@"%.2f",amount],
                          @"goodCode":goods.goodCode.length>0?goods.goodCode:@"",
                          @"goodName":goods.name.length>0?goods.name:@"",
                          @"goodNum":[NSString stringWithFormat:@"%d",1+[goods.shopCartNum intValue]],
                          @"categoryId":goods.productCategoryId.length>0?goods.productCategoryId:@"",
                          @"shopId":goods.shopId.length>0?goods.shopId:[DeviceHelper sharedInstance].shop.id,
                          @"productId":goods.id.length>0?goods.id:@""
                          };
    
    
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIUpdateCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{

                for (GoodsModel * model in self.shopCartList) {
                    if ([model.goodCode isEqualToString:self.goods.goodCode]) {
                        model.goodNum = [NSString stringWithFormat:@"%d",[model.goodNum intValue]+1];
                        break;
                    }
                }
                
                [MBProgressHUD MBProgressHUDWithView:self.view Str:@"添加成功！"];

                [[NSNotificationCenter defaultCenter] postNotificationName:AddGoodsSuccess_Notify object:nil userInfo:nil];
            });
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}



#pragma mark - WKUIDelegate

// 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
        textField.placeholder = defaultText;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}


#pragma mark-
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"gotoGoodsDetail"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"addGoodsToCart"];
}
@end
