//
//  WXApiManager.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/28.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"

@protocol WXApiManagerDelegate <NSObject>

@optional


@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

@end
