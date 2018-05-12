//
//  AFNetAPIClient.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#define ImageFile   @"UIImage"
#define MP4File     @"MP4"
#define MP3File     @"MP3"

@interface AFNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (NSURLSessionDataTask *)GET:(NSString *)Function
                        token:(NSString*)token
                   parameters:(id)parameters
                      success:(void (^)(id JSON, NSError *error))success
                      failure:(void (^)(id JSON, NSError *error))failure;

+ (NSURLSessionDataTask *)POST:(NSString *)Function
                        token:(NSString*)token
                    parameters:(id)parameters 
                       success:(void (^)(id JSON, NSError *error))success
                       failure:(void (^)(id JSON, NSError *error))failure;


//上传 图片 音频 视频
+ (NSURLSessionDataTask *)PostMediaData:(NSString *)Function
                             parameters:(NSDictionary *) parameters
                              mediaData:(NSArray *)mediaDatas
                                success:(void (^)(id JSON, NSError *error))success
                                failure:(void (^)(id JSON, NSError *error))failure;
@end
