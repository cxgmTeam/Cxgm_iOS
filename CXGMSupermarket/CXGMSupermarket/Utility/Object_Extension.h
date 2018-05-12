//
//  Object_Extension.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface Object_Extension : NSObject

@end

@interface MBProgressHUD (constructor)
+(void)MBProgressHUDWithView:(UIView *)view Str:(NSString *)str;
@end

@interface UIColor (Extension)
+ (UIColor *)randomColor;
+ (UIColor *)colorWithHexString:(NSString *)string;
@end

@interface CustomTextField: UITextField
@property (nonatomic,strong) UILabel * placeHolderLab;
@end

