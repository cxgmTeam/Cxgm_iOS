//
//  DeviceHelper.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DeviceHelper.h"

@implementation DeviceHelper

+ (instancetype)sharedInstance
{
    static DeviceHelper *deviceInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceInstance = [[DeviceHelper alloc] init];
        deviceInstance.deviceID = [DeviceHelper keyChain:DeviceIDKey];
        if (!deviceInstance.deviceID) {
            deviceInstance.deviceID = [[UIDevice currentDevice].identifierForVendor UUIDString];
            [DeviceHelper saveKeychain:DeviceIDKey value:deviceInstance.deviceID];
        }
    });
    return deviceInstance;
}

- (id)init{
    if (self = [super init]) {

        self.shopCartNum = @"0";
    }
    return self;
}


#pragma mark- 有关uuid
//提取保存的uuid
+ (id)keyChain:(NSString *)key
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {}
        @finally {}
    }
    if (keyData)CFRelease(keyData);
    return ret;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}
+ (NSString *)keychainErrorToString: (NSInteger)error {
    NSString *msg = [NSString stringWithFormat:@"%ld",(long)error];
    switch (error) {
        case errSecSuccess:
            msg = NSLocalizedString(@"SUCCESS", nil);
            break;
        case errSecDuplicateItem:
            msg = NSLocalizedString(@"ERROR_ITEM_ALREADY_EXISTS", nil);
            break;
        case errSecItemNotFound :
            msg = NSLocalizedString(@"ERROR_ITEM_NOT_FOUND", nil);
            break;
        case -26276: // this error will be replaced by errSecAuthFailed
            msg = NSLocalizedString(@"ERROR_ITEM_AUTHENTICATION_FAILED", nil);
            
        default:
            break;
    }
    return msg;
}
//保存uuid
+ (void)saveKeychain:(NSString *)key value:(id)sValue
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:sValue] forKey:(__bridge id)kSecValueData];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainQuery,NULL);
    [self keychainErrorToString:status];
}

@end
