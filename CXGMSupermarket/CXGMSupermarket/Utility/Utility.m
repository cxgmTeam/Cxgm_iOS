//
//  Utility.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "Utility.h"

@implementation Utility
#pragma 正则校验手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber
{
    
    telNumber = [telNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNumber length] != 11) {
        return NO;
    }
    
    /**
     * 规则 -- 更新日期 2017-03-30
     * 手机号码: 13[0-9], 14[5,7,9], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     *
     * [数据卡]: 14号段以前为上网卡专属号段，如中国联通的是145，中国移动的是147,中国电信的是149等等。
     * [虚拟运营商]: 170[1700/1701/1702(电信)、1703/1705/1706(移动)、1704/1707/1708/1709(联通)]、171（联通）
     * [卫星通信]: 1349
     */
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147(数据卡),150,151,152,157,158,159,170[5],178,182,183,184,187,188
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[8])|(18[2-4,7-8]))\\d{8}|(170[5])\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145(数据卡),155,156,170[4,7-9],171,175,176,185,186
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[156])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149(数据卡),153,170[0-2],173,177,180,181,189
     */
    NSString *CT_NUM = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$";
    
    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    BOOL isMatch_CM = [pred_CM evaluateWithObject:telNumber];
    BOOL isMatch_CU = [pred_CU evaluateWithObject:telNumber];
    BOOL isMatch_CT = [pred_CT evaluateWithObject:telNumber];
    
    if (isMatch_CM || isMatch_CT || isMatch_CU) {
        return YES;
    }
    
    return NO;
}

// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

// JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//把手机号第4-7位变成星号
+(NSString*)phoneNumToAsterisk:(NSString*)phoneNum
{
    return[phoneNum stringByReplacingCharactersInRange:NSMakeRange(3,4)withString:@"****"];
}

+(NSString *)formateDate:(long)ms
{
    NSString* dateString = @"";
    
    int ss = 1000;
    int mi = ss * 60;
    int hh = mi * 60;
    int dd = hh * 24;
    
    
    long day = ms / dd;
    long hour = (ms - day * dd) / hh;
    long minute = (ms - day * dd - hour * hh) / mi;
    long second = (ms - day * dd - hour * hh - minute * mi) / ss;
    
    
    if (day>0) {
        dateString = [NSString stringWithFormat:@"%02ld:%02ld%02ld%02ld",day,hour,minute,second];
    }else if (hour>0){
        dateString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second];
    }else{
        dateString = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    }
    return dateString;
}

#pragma mark-
+ (void)CXGMPostRequest:(NSString *)requestUrl token:(NSString *)token parameter:(NSDictionary *)dict success:(void (^)(id JSON, NSError *error))success failure:(void (^)(id JSON, NSError *error))failure
{
    NSLog(@"\n\nCXGMPostRequest requestUrl = %@ \n %@",requestUrl,dict);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL* url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if (token.length > 0) {
        [postRequest setValue:token forHTTPHeaderField:@"token"];
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"\n\nCXGMPostRequest %@\n dic = %@",requestUrl,dic);
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            if (success) {
                success(dic,nil);
            }
        }else if ([[dic objectForKey:@"code"] integerValue] == 403){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UserInfoManager sharedInstance] deleteUserInfo];
                UIWindow* window = [UIApplication sharedApplication].keyWindow;
                [MBProgressHUD MBProgressHUDWithView:window Str:@"登录失效，请重新登录"];
            });

        }else{
            if (failure) {
                failure(dic,error);
            }
        }
    }];
    [dataTask resume];
}

//是否在配送范围
+ (BOOL)checkAddress:(NSString *)longitude dimension:(NSString *)dimension
{
    NSDictionary* dic = @{
                          @"longitude":longitude,
                          @"dimension":dimension
                          };
    __block BOOL flag = NO;
    //data为空代表不在配送范围内
    [AFNetAPIClient POST:[LoginBaseURL stringByAppendingString:APICheckAddress] token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model  = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray *)model.data;
            flag = array.count>0?YES:NO;
        }
    } failure:^(id JSON, NSError *error){
        
    }];
    return flag;
}



@end
