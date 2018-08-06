//
//  EmployeesViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/7/1.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "EmployeesViewController.h"
#import <WebKit/WebKit.h>

@interface EmployeesViewController ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView* webView;
@end

@implementation EmployeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"员工入口";
    
    self.webView = [WKWebView new];

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
    
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://47.104.226.173"]];
    [self.webView loadRequest:request];
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSURL *url = webView.URL;
    NSString *scheme = [url scheme];
    
     if (![scheme isEqualToString:@"tel"]) {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    UIApplication *app = [UIApplication sharedApplication];
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;


    if ([scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    /* 这句话一定要实现 不然会异常 */
    decisionHandler(actionPolicy);
}

@end
