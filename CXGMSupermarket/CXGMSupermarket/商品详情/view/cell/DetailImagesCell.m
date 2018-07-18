//
//  DetailImagesCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/7/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DetailImagesCell.h"
#import <WebKit/WebKit.h>

@interface DetailImagesCell ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView* webView;
@end

@implementation DetailImagesCell

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
        [html replaceCharactersInRange:contentRange withString:htmlString.length>0?htmlString:@""];
    }
    
    [_webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:htmlPath]];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
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
