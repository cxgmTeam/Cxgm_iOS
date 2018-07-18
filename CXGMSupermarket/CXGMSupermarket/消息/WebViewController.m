//
//  WebViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/7/9.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView* webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
    
    if ([self.urlString containsString:@"http://"] || [self.urlString containsString:@"https://"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://" stringByAppendingString:self.urlString]]]];
    }
    
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
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
}
@end
