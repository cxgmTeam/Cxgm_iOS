//
//  UserInfoManager.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/5/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfo

@end

@implementation UserInfoManager

+ (UserInfoManager *)sharedInstance {
    static UserInfoManager * s_instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        s_instance = [[UserInfoManager alloc] init];
        
    });
    return s_instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.userInfo = nil;
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* jsonStr = [userDefaults objectForKey:BackupUserInfo];
        NSDictionary* dic = [Utility dictionaryWithJsonString:jsonStr];
        if (dic) {
            self.userInfo = [[UserInfo alloc] initWithDictionary:dic error:nil];
        }
    }
    return self;
}

- (void)saveUserInfo:(NSDictionary *)json
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* jonStr = [Utility convertToJsonData:json];
    
    [userDefaults setObject:jonStr forKey:BackupUserInfo];
    [userDefaults synchronize];
}

- (BOOL)isLogin{
    if (self.userInfo == nil) {
        return NO;
    }
    return YES;
}

//退出登录
- (void)deleteUserInfo{
    self.userInfo = nil;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:BackupUserInfo];
}

@end

