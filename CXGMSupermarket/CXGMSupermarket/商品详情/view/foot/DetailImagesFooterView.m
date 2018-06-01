//
//  DetailImagesFooterView.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DetailImagesFooterView.h"
#import <WebKit/WebKit.h>

@interface DetailImagesFooterView ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView* webView;
@end

@implementation DetailImagesFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setHtmlString:(NSString *)htmlString{
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"HTMLTemplate" ofType:@"html"];
    NSMutableString *html = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];

    NSRange contentRange = [html rangeOfString:@"{content}"];
    if (contentRange.location != NSNotFound) {
        [html replaceCharactersInRange:contentRange withString:htmlString];
    }

    [_webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:htmlPath]];
    
//    [_webView loadHTMLString:htmlString baseURL:nil];
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.webView = [WKWebView new];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.webView.navigationDelegate = self;
    [self.webView setMultipleTouchEnabled:YES];
    [self.webView setAutoresizesSubviews:YES];
    [self.webView.scrollView setAlwaysBounceVertical:YES];
    self.webView.scrollView.bounces = NO;
    [self addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
}


@end
