//
//  UserInfoManager.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/5/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : JSONModel
@property (nonatomic,strong)NSString<Optional> * id;
@property (nonatomic,strong)NSString<Optional> * userName;
@property (nonatomic,strong)NSString<Optional> * userPwd;
@property (nonatomic,strong)NSString<Optional> * mobile;
@property (nonatomic,strong)NSString<Optional> * headUrl;
@property (nonatomic,strong)NSString<Optional> * token;
@property (nonatomic,strong)NSString<Optional> * createTime;
@end

@interface UserInfoManager : NSObject
+ (UserInfoManager *)sharedInstance;

@property(nonatomic,strong)UserInfo* userInfo;
@property(nonatomic,assign)BOOL isLogin;

//登录后保存用户信息
- (void)saveUserInfo:(NSDictionary *)json;
//用户是否已经登录 如果登录直接显示登录状态
- (BOOL)isLogin;
//退出登录
- (void)deleteUserInfo;
@end
