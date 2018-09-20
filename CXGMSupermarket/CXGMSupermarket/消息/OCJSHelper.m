//
//  OCJSHelper.m
//  WKWebViewDemo
//
//  Created by hujunhua on 2016/11/17.
//  Copyright © 2016年 hujunhua. All rights reserved.
//

#import "OCJSHelper.h"

@interface OCJSHelper()
@property (nonatomic, weak) UIViewController *vc;
@end

@implementation OCJSHelper

- (instancetype)initWithDelegate:(id<OCJSHelperDelegate>)delegate vc:(UIViewController *)vc; {
    if (self = [super init]) {
        self.delegate = delegate;
        self.vc = vc;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@, %s", self.class, __func__);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:message.body];
    NSLog(@"JS交互参数：%@", dic);
    
    if ([message.name isEqualToString:@"gotoGoodsDetail"] && [dic isKindOfClass:[NSDictionary class]]) {

        dispatch_async(dispatch_get_main_queue(), ^{

            NSString *productId = dic[@"productId"];
            NSString *shopId = dic[@"shopId"];

            [self.delegate showGoodsDetail:productId andShop:shopId];

        });
    }
    else if ([message.name isEqualToString:@"addGoodsToCart"] && [dic isKindOfClass:[NSDictionary class]]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate addGoodsToCart:dic];
            
        });
    }
    else
    {
        return;
    }
}


@end
