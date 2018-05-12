//
//  APIParameterHelper.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/4.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIParameterHelper : NSObject
//获取验证码
+(NSDictionary *)sendSMSMessage:(NSString *)phone;
//校验验证码
+(NSDictionary *)validaSMSMessage:(NSString *)phone checkcode:(NSString *)checkcode;



//用户登录
+(NSDictionary *)userLogin:(NSString *)userAccount mobileValidCode:(NSString *)mobileValidCode;
//新增用户地址
+(NSDictionary *)addAddress:(NSString *)address area:(NSString *)area dimension:(NSString *)dimension longitude:(NSString *)longitude phone:(NSString *)phone realName:(NSString *)realName userId:(NSString *)userId;
//修改用户地址
+(NSDictionary *)updateAddress:(NSString *)address area:(NSString *)area dimension:(NSString *)dimension longitude:(NSString *)longitude phone:(NSString *)phone realName:(NSString *)realName userId:(NSString *)userId;
//判断用户配送地址是否在配送范围
+(NSDictionary *)checkAddress:(NSString *)longitude dimension:(NSString *)dimension;
//根据用户ID和地址ID删除用户地址接口
+(NSDictionary *)deleteAddress:(NSString *)userId addressId:(NSString *)addressId;
//版本控制
+(NSDictionary *)visionControl:(NSString *)visionCode;




/*首页相关接口*/
//根据门店ID查询首页精品推荐
+(NSDictionary *)findHotProduct:(NSString *)shopId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize;
//根据门店ID查询首页新品上市
+(NSDictionary *)findNewProduct:(NSString *)shopId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize;
//根据门店ID查询商品一级分类
+(NSDictionary *)findFirstCategory:(NSString *)shopId;
//根据门店ID和一级分类查询商品二级分类
+(NSDictionary *)findSecondCategory:(NSString *)shopId productCategoryId:(NSString *)productCategoryId;
//根据门店ID和商品二级类别ID查询商品信息
+(NSDictionary *)findProductByCategory:(NSString *)shopId productCategoryTwoId:(NSString *)productCategoryTwoId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize;




//根据用户查询优惠券
+(NSDictionary *)findCoupons:(NSString *)pageNum pageSize:(NSString *)pageSize;
//优惠券兑换
+(NSDictionary *)exchangeCoupons:(NSString *)couponCode;



//我的订单列表
+(NSDictionary *)orderList:(NSString *)pageNum pageSize:(NSString *)pageSize;
//用户下单接口
+(NSDictionary *)addOrder:(NSString *)orderAmount orderNum:(NSString *)orderNum orderTime:(NSString *)orderTime payType:(NSString *)payType productList:(NSArray *)productList remarks:(NSString *)remarks status:(NSString *)status storeId:(NSString *)storeId userId:(NSString *)userId;
//删除订单
+(NSDictionary *)deleteOrder:(NSString *)orderId;


/*购物车相关*/
//我的购物车列表
+(NSDictionary *)shopCartList:(NSString *)pageNum pageSize:(NSString *)pageSize;
//商品添加到购物车接口
+(NSDictionary *)shopAddCart:(NSDictionary *)shopCart;
//购物车移除商品接口
+(NSDictionary *)deleteShopCart:(NSString *)shopCartIds shopCartId:(NSString *)shopCartId;
//修改购物车接口
+(NSDictionary *)updateCart:(NSDictionary *)shopCart;
@end
