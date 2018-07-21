//
//  AFNetAPIClient.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AFNetAPIClient.h"

@implementation AFNetAPIClient

+ (instancetype)sharedClient
{
    static AFNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFNetAPIBaseURLString]];
        
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        
//        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [_sharedClient.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];

        _sharedClient.requestSerializer.timeoutInterval = 10.f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
    });
    return _sharedClient;
}

+ (NSURLSessionDataTask *)GET:(NSString *)Function
                        token:(NSString*)token
                   parameters:(id)parameters
                      success:(void (^)(id JSON, NSError *error))success
                      failure:(void (^)(id JSON, NSError *error))failure
{
    AFNetAPIClient * manager = [self sharedClient];

    if (token != nil)
    {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    NSURLSessionDataTask * task = [manager GET:Function parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject){
        
        if (success) {
            
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\\\""];
            aString = [aString stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
            aString=[aString stringByReplacingOccurrencesOfString:@"&#183;" withString:@"."];
            
//            NSLog(@"\n\n%@ \n\n%@\n\n",[NSString stringWithFormat:@"%@",task.response.URL],aString);
            
            DataModel * model = [[DataModel alloc] initWithString:aString error:nil];
            
            if ([model.code  integerValue] == 403){
                [[UserInfoManager sharedInstance] deleteUserInfo];
                UIWindow* window = [UIApplication sharedApplication].keyWindow;
                [MBProgressHUD MBProgressHUDWithView:window Str:@"登录失效，请重新登录"];
            }
            else
            {
                success(aString,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"get failure error %@",error);
        if (failure) {
            failure(@"请求失败",nil);
        }
    }];
    return task;
}

+ (NSURLSessionDataTask *)POST:(NSString *)Function
                        token:(NSString*)token
                    parameters:(id)parameters
                       success:(void (^)(id JSON, NSError *error))success
                       failure:(void (^)(id JSON, NSError *error))failure
{
    AFNetAPIClient * manager = [self sharedClient];
    if (token.length > 0){
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    
    return [manager POST:Function parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"responseObject  Class   %@",[responseObject class]);
        if (success){
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            aString = [aString stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
            aString = [aString stringByReplacingOccurrencesOfString:@"&#183;" withString:@"."];
            aString = [aString stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
            aString = [aString stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
            
            NSLog(@"\n\n%@ \n%@\n\n%@\n\n",[NSString stringWithFormat:@"%@",task.response.URL],parameters,aString);
            
            DataModel * model = [[DataModel alloc] initWithString:aString error:nil];
            if ([model.code  integerValue] == 403){
                [[UserInfoManager sharedInstance] deleteUserInfo];
                UIWindow* window = [UIApplication sharedApplication].keyWindow;
                [MBProgressHUD MBProgressHUDWithView:window Str:@"登录失效，请重新登录"];
            }
            else
            {
                success(aString,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"AFNetAPIClient post error %@",error.debugDescription);
        if (failure) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            [MBProgressHUD MBProgressHUDWithView:window Str:@"请检查网络连接"];
            failure(@"请求失败",nil);
        }
    }];
}

+ (NSURLSessionDataTask *)PostMediaData:(NSString *)Function
                             parameters:(NSDictionary *) parameters
                              mediaData:(NSArray *)mediaDatas
                                success:(void (^)(id JSON, NSError *error))success
                                failure:(void (^)(id JSON, NSError *error))failure  //上传多媒体
{
    NSLog(@"=============%@/n%@",Function,parameters);
    
    AFNetAPIClient * manager = [self sharedClient];
    
    return   [manager POST:[AFNetAPIBaseURLString stringByAppendingString:Function] parameters:parameters constructingBodyWithBlock:^(id  _Nonnull formData) {
        
        if (mediaDatas.count >= 2 )
        {
            NSString *firstObj = [mediaDatas objectAtIndex:0];
            NSObject* dataObj = [mediaDatas objectAtIndex:1];
            if ([firstObj isEqualToString:ImageFile])
            {
                NSData *imagedata=[self resetSizeOfImageData:(UIImage *)dataObj maxSize:800];
                [formData appendPartWithFileData:imagedata name:@"file" fileName:@"image1.png" mimeType:@"image/jpeg"];
            }
            else if ([firstObj isEqualToString:MP4File])
            {
                [formData appendPartWithFileData:(NSData *)dataObj name:@"file" fileName:@"video1.mp4" mimeType:@"video/quicktime"];
            }
            else if ([firstObj isEqualToString:MP3File])
            {
                [formData appendPartWithFileData:(NSData *)dataObj name:@"file" fileName:@"audio1.mp3" mimeType:@"audio/mpeg3"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSLog(@"PostMediaData... success");
        
        NSString *aString = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
        aString = [aString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\\\""];
        aString=[aString stringByReplacingOccurrencesOfString:@"&#183;" withString:@"."];
        
        NSLog(@"PostMediaData  \n\n%@\n\n",aString);
        
        DataModel * model = [[DataModel alloc] initWithString:aString error:nil];
        if ([model.code intValue] == 200) {
            success(aString,nil);
        }
        else if ([model.code  integerValue] == 403){
            [[UserInfoManager sharedInstance] deleteUserInfo];
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            [MBProgressHUD MBProgressHUDWithView:window Str:@"登录失效，请重新登录"];
        }
        else
        {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            [MBProgressHUD MBProgressHUDWithView:window Str:model.msg];
            if (failure)
            {
                failure(aString,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"PostImage... failure");
        if (failure) {
//            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
//            [MBProgressHUD MBProgressHUDWithView:window Str:error.description];
            failure(@"请求失败",nil);
        }
    }];
}

#pragma mark-
//缓存数据
+(void)writeDiskWithData:(NSData *)data Path:(NSString*)path
{
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    NSString *fullNamespace = @"AFNetApiClient";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *_diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    
    if (![_fileManager fileExistsAtPath:_diskCachePath]) {
        [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    [_fileManager createFileAtPath:[_diskCachePath stringByAppendingPathComponent:[path stringByReplacingOccurrencesOfString:@"/" withString:@"."]] contents:data attributes:nil];
    
}
//读取缓存数据
+(NSString *)readFromDiskWithPath:(NSString*)path
{
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    NSString *fullNamespace = @"AFNetApiClient";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *_diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    NSString * filePath = [_diskCachePath stringByAppendingPathComponent:[path stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
    
    
    if ([_fileManager fileExistsAtPath:filePath]) {
        NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        return str;
    }
    return nil;
}

//先调整分辨率在计算压缩比例
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}
@end
