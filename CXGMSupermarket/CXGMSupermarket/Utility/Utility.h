//
//  Utility.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
#pragma 正则校验手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber;

// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
// JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//把手机号第4-7位变成星号
+(NSString*)phoneNumToAsterisk:(NSString*)phoneNum;

+(NSString *)formateDate:(long)ms;

#pragma mark-
+ (void)CXGMPostRequest:(NSString *)requestUrl token:(NSString *)token parameter:(NSDictionary *)dict success:(void (^)(id JSON, NSError *error))success failure:(void (^)(id JSON, NSError *error))failure;

//是否在配送范围
+ (BOOL)checkAddress:(NSString *)longitude dimension:(NSString *)dimension;
@end
