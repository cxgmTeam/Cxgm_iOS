//
//  HTMLViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/8/21.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "HTMLViewController.h"

@interface HTMLViewController ()
@property(nonatomic,strong) UIWebView* webView;
@end

@implementation HTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [UIWebView new];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:self.fileName withExtension:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    [_webView loadRequest:request];
    
}



@end
