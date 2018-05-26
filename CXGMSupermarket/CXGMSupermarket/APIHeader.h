//
//  APIHeader.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#ifndef APIHeader_h
#define APIHeader_h

//获取验证码
#define APISendSMS  @"/sendSMS"
//校验验证码
#define APIValidaSMS  @"/validaSMS"


//用户登录
#define APIUserLogin  @"/user/login"
//根据用户ID查询用户地址接口
#define APIAddressList  @"/user/addressList"
//新增用户地址
#define APIAddAddress  @"/user/addAddress"
//修改用户地址
#define APIUpdateAddress  @"/user/updateAddress"
//判断用户配送地址是否在配送范围
#define APICheckAddress  @"/user/checkAddress"
//根据用户ID和地址ID删除用户地址接口
#define APIDeleteAddress  @"/user/deleteAddress"
//版本控制接口
#define APIVisionControl  @"/user/visionControl"
//查看所有配送范围接口
#define APIFindAllPsfw  @"/user/findAllPsfw"


/*首页相关接口*/
//根据门店ID查询首页精品推荐
#define APIFindTopProduct  @"/homePage/findTopProduct"
//根据门店ID查询首页新品上市
#define APIFindNewProduct  @"/homePage/findNewProduct"
//根据门店ID查询首页热销推荐
#define APIFindHotProduct  @"/homePage/findHotProduct"
//查询所有门店列表
#define APIShopList  @"/user/shopList"
//根据门店ID查询首页广告
#define APIFindAdvertisement  @"/homePage/findAdvertisement"
//根据门店ID查询首页运营位置
#define APIFindMotion  @"/homePage/findMotion"
//根据商品ID查询商品详情
#define APIFindProductDetail  @"/homePage/findProductDetail"
//商品详情的猜你喜欢
#define APIPushProducts  @"/homePage/pushProducts"

/* 分类页面  */
//根据门店ID查询商品一级分类
#define APIFindFirstCategory  @"/homePage/findFirstCategory"
//根据门店ID和一级分类查询商品二级分类
#define APIFindSecondCategory  @"/homePage/findSecondCategory"
//根据门店ID和二级分类查询商品三级分类
#define APIFindThirdCategory  @"/homePage/findThirdCategory"

//根据门店ID和商品二级类别ID查询商品信息
#define APIFindProductByCategory  @"/homePage/findProductByCategory"


//根据用户查询优惠券
#define APIFindCoupons  @"/coupon/findCoupons"
//优惠券兑换
#define APIExchangeCoupons  @"/coupon/exchangeCoupons"
//根据用户ID和所选商品类别查询可用优惠券
#define APICheckCoupon  @"/order/checkCoupon"


//我的订单列表
#define APIOrderList  @"/order/list"
//用户下单接口
#define APIAddOrder  @"/order/addOrder"
//删除订单
#define APIDeleteOrder  @"/order/deleteOrder"



/*购物车相关*/
//我的购物车列表
#define APIShopCartList  @"/shopCart/list"
//商品添加到购物车接口
#define APIShopAddCart  @"/shopCart/addCart"
//购物车移除商品接口
#define APIDeleteShopCart  @"/shopCart/deleteShopCart"
//修改购物车接口
#define APIUpdateCart  @"/shopCart/updateCart"



#define LoginBaseURL  @"http://47.104.226.173:41207" //用户登录相关接口
#define OrderBaseURL  @"http://47.104.226.173:41203" //订单相关接口
#define HomeBaseURL  @"http://47.104.226.173:41202"  //首页及其他业务相关接口

#define AFNetAPIBaseURLString   LoginBaseURL


#endif /* APIHeader_h */
