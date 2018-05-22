//
//  LZCartModel.h
//  LZCartViewController
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZCartModel : JSONModel
//自定义模型时,这三个属性必须有
@property (nonatomic,strong)NSString<Optional> * select;

@property (nonatomic,strong)NSString<Optional> * goodNum;
@property (nonatomic,strong)NSString<Optional> * price;

//下面的属性可根据自己的需求修改
@property (nonatomic,strong)NSString<Optional> * id;
@property (nonatomic,strong)NSString<Optional> * shopId;
@property (nonatomic,strong)NSString<Optional> * userId;
@property (nonatomic,strong)NSString<Optional> * goodName;
@property (nonatomic,strong)NSString<Optional> * goodCode;
@property (nonatomic,strong)NSString<Optional> * specifications;
@property (nonatomic,strong)NSString<Optional> * amount;
@property (nonatomic,strong)NSString<Optional> * imageUrl;
@property (nonatomic,strong)NSString<Optional> * coupon;
@property (nonatomic,strong)NSString<Optional> * couponId;

@property (nonatomic,strong)NSString<Optional> * originalPrice;
@property (nonatomic,strong)NSString<Optional> * categoryId;//同一个categoryId的金额计算出来

@end
