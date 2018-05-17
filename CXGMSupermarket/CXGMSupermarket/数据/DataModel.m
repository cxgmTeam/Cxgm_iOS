//
//  DataModel.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DataModel.h"

@implementation ListModel

@end

@implementation DataModel

+(DataModel *)dataModelWith:(NSString *)JSON{
    DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
    if ([model.data isKindOfClass:[NSDictionary class]]) {
        model.listModel = [[ListModel alloc] initWithDictionary:(NSDictionary *)model.data error:nil];
    }
    return model;
}
@end

@implementation ShopModel

@end

@implementation CategoryModel

@end

@implementation GoodsModel

@end

@implementation CouponsModel

@end

@implementation AddressModel

@end



@implementation LocationModel

@end

