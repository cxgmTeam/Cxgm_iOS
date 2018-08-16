//
//  HelpViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/8/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心";
    
    UIWebView* webView = [UIWebView new];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    

    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"help.html" withExtension:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    [webView loadRequest:request];
}



@end
