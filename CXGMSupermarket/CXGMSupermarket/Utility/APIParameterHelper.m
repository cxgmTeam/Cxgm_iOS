//
//  APIParameterHelper.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/4.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "APIParameterHelper.h"

@implementation APIParameterHelper
//获取验证码
+(NSDictionary *)sendSMSMessage:(NSString *)phone{
    return @{@"phone":phone};
}
//校验验证码
+(NSDictionary *)validaSMSMessage:(NSString *)phone checkcode:(NSString *)checkcode{
    return @{@"phone":phone,@"checkcode":checkcode};
}




//用户登录
+(NSDictionary *)userLogin:(NSString *)userAccount mobileValidCode:(NSString *)mobileValidCode{
    return @{@"userAccount":userAccount,@"mobileValidCode":mobileValidCode};
}
//新增用户地址
+(NSDictionary *)addAddress:(NSString *)address area:(NSString *)area dimension:(NSString *)dimension longitude:(NSString *)longitude phone:(NSString *)phone realName:(NSString *)realName userId:(NSString *)userId{
    return @{@"address":address,@"area":area,@"dimension":dimension,@"longitude":longitude,@"phone":phone,@"realName":realName,@"userId":userId};
}//修改用户地址
+(NSDictionary *)updateAddress:(NSString *)address area:(NSString *)area dimension:(NSString *)dimension longitude:(NSString *)longitude phone:(NSString *)phone realName:(NSString *)realName userId:(NSString *)userId{
    return @{@"address":address,@"area":area,@"dimension":dimension,@"longitude":longitude,@"phone":phone,@"realName":realName,@"userId":userId};
}
//判断用户配送地址是否在配送范围
+(NSDictionary *)checkAddress:(NSString *)longitude dimension:(NSString *)dimension{
    return @{@"longitude":longitude,@"dimension":dimension};
}
//根据用户ID和地址ID删除用户地址接口
+(NSDictionary *)deleteAddress:(NSString *)userId addressId:(NSString *)addressId{
    return @{@"userId":userId,@"addressId":addressId};
}
//版本控制
+(NSDictionary *)visionControl:(NSString *)visionCode{
    return @{@"visionCode":visionCode};
}



/*首页相关接口*/
//根据门店ID查询首页精品推荐
+(NSDictionary *)findHotProduct:(NSString *)shopId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize{
    return @{@"shopId":shopId,@"pageNum":pageNum,@"pageSize":pageSize};
}
//根据门店ID查询首页新品上市
+(NSDictionary *)findNewProduct:(NSString *)shopId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize{
     return @{@"shopId":shopId,@"pageNum":pageNum,@"pageSize":pageSize};
}
//根据门店ID查询商品一级分类
+(NSDictionary *)findFirstCategory:(NSString *)shopId{
    return @{@"shopId":shopId};
}
//根据门店ID和一级分类查询商品二级分类
+(NSDictionary *)findSecondCategory:(NSString *)shopId productCategoryId:(NSString *)productCategoryId{
    return @{@"shopId":shopId,@"productCategoryId":productCategoryId};
}
//根据门店ID和商品二级类别ID查询商品信息
+(NSDictionary *)findProductByCategory:(NSString *)shopId productCategoryTwoId:(NSString *)productCategoryTwoId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize{
    return @{@"shopId":shopId,@"productCategoryTwoId":productCategoryTwoId,@"pageNum":pageNum,@"pageSize":pageSize};
}


//根据用户查询优惠券
+(NSDictionary *)findCoupons:(NSString *)pageNum pageSize:(NSString *)pageSize{
    return @{@"pageNum":pageNum,@"pageSize":pageSize};
}
//优惠券兑换
+(NSDictionary *)exchangeCoupons:(NSString *)couponCode{
    return @{@"couponCode":couponCode};
}


//我的订单列表
+(NSDictionary *)orderList:(NSString *)pageNum pageSize:(NSString *)pageSize{
    return @{@"pageNum":pageNum,@"pageSize":pageSize};
}
//用户下单接口
+(NSDictionary *)addOrder:(NSString *)orderAmount orderNum:(NSString *)orderNum orderTime:(NSString *)orderTime payType:(NSString *)payType productList:(NSArray *)productList remarks:(NSString *)remarks status:(NSString *)status storeId:(NSString *)storeId userId:(NSString *)userId{
    return @{@"orderAmount":orderAmount,@"orderNum":orderNum,@"orderTime":orderTime,@"payType":payType,@"productList":productList,@"remarks":remarks,@"status":status,@"storeId":storeId,@"userId":userId};
}
//删除订单
+(NSDictionary *)deleteOrder:(NSString *)orderId{
    return @{@"orderId":orderId};
}



/*购物车相关*/
//我的购物车列表
+(NSDictionary *)shopCartList:(NSString *)pageNum pageSize:(NSString *)pageSize{
    return @{@"pageNum":pageNum,@"pageSize":pageSize};
}
//商品添加到购物车接口
+(NSDictionary *)shopAddCart:(NSDictionary *)shopCart{
    return @{@"shopCart":shopCart};
}
//购物车移除商品接口
+(NSDictionary *)deleteShopCart:(NSString *)shopCartIds shopCartId:(NSString *)shopCartId{
    return @{@"shopCartIds":shopCartIds,@"shopCartId":shopCartId};
}
//修改购物车接口
+(NSDictionary *)updateCart:(NSDictionary *)shopCart{
    return @{@"shopCart":shopCart};
}
@end
