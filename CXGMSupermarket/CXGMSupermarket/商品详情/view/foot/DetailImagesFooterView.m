//
//  DetailImagesFooterView.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/16.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DetailImagesFooterView.h"

@interface DetailImagesFooterView ()
@property(nonatomic,strong)UIWebView* webView;
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
    [_webView loadHTMLString:htmlString baseURL:nil];
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _webView = [UIWebView new];
    _webView.backgroundColor = [UIColor clearColor];
    [self addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
}


@end
