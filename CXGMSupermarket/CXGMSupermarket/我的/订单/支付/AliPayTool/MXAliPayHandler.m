/**
 支付宝调起支付类
 @create by 刘智援 2016-11-28
 
 @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
 @Github地址: https://github.com/lyoniOS
 */

#import "MXAliPayHandler.h"
#import "MXAlipayConfig.h"

@implementation MXAliPayHandler

+ (void)jumpToAliPay:(NSDictionary *)dict
{
    
    NSLog(@"jumpToAliPay ... \n\n %@",dict);
    
    NSString* biz_content = dict[@"biz_content"];
    
    NSString* content = [biz_content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* bizDic = [Utility dictionaryWithJsonString:content];


    //将商品信息赋予AlixPayOrder的成员变量
    Order* order    = [Order new];
    order.app_id    = dict[@"app_id"];// NOTE: app_id设置
    order.method    = dict[@"method"];  // NOTE: 支付接口名称
    order.charset = dict[@"charset"];       // NOTE: 参数编码格式
    

//    NSString* timeString = [dict[@"timestamp"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSArray* array = [timeString componentsSeparatedByString:@"+"];
//    
//    order.timestamp = [NSString stringWithFormat:@"%@ %@",array[0],array[1]];   // NOTE: 当前时间点
    
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    NSLog(@"order.timestamp  %@",order.timestamp);
    
    order.version   = dict[@"version"];      // NOTE: 支付版本
    order.sign_type = dict[@"sign_type"];      // NOTE: sign_type设置
    
    // NOTE: 商品数据
    order.biz_content                   = [BizContent new];
    order.biz_content.body              = bizDic[@"passback_params"];
    order.biz_content.subject           = bizDic[@"subject"];
    order.biz_content.out_trade_no      = bizDic[@"out_trade_no"];   //订单ID（由商家自行制定）
    order.biz_content.timeout_express   = bizDic[@"timeout_express"];;                   //超时时间设置
    order.biz_content.total_amount      = bizDic[@"total_amount"];                    //商品价格
    order.biz_content.product_code      = bizDic[@"product_code"];
    
    //将商品信息拼接成字符串
//    NSString *orderInfo         = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded  = [order orderInfoEncoded:YES];
//    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(MXAlipayPrivateKey);
//    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
//    if (signedString != nil)
    {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"CaiXianGuoMei";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, dict[@"sign"]];
        
        
        NSLog(@"orderString=====\n\n %@",orderString);
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            
            
            
            
        }];
    }
}

#pragma mark - Private Method

//==============产生随机订单号==============

+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
