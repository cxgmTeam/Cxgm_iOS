//
//  Object_Extension.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "Object_Extension.h"

@implementation Object_Extension

@end

@implementation MBProgressHUD (constructor)

+(void)MBProgressHUDWithView:(UIView *)view Str:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.offset = CGPointZero;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.f];
    hud.label.text = str;
}

@end

@implementation UIColor (Extension)

+(UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

// 十六进制string加载颜色（[UIColor colorWithHexString:@"f5f5f5"]）
+ (UIColor *)colorWithHexString:(NSString *)string
{
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([pureHexString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *gString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *bString = [pureHexString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end

@implementation CustomTextField

-(UILabel *)_placeHolderLab
{
    if (_placeHolderLab == nil) {
        _placeHolderLab = [UILabel new];
        _placeHolderLab.text = self.placeholder;
        _placeHolderLab.font = self.font;
        _placeHolderLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
        _placeHolderLab.textAlignment = NSTextAlignmentLeft;
        CGRect diffRect = [self editingRectForBounds:self.bounds];
        [self.superview addSubview:_placeHolderLab];
        [_placeHolderLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.left.equalTo(self).offset(diffRect.origin.x);
        }];
    }
    return _placeHolderLab;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15; //像右边偏15
    return iconRect;
}
//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds
{
    [super leftViewRectForBounds:bounds];
    if (self.leftView) {
        return CGRectInset(bounds, 35, 0);
    }
    return CGRectMake(10, 0, (bounds.size.width-20), (bounds.size.height));
}
//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    [super editingRectForBounds:bounds];
    if (self.leftView){
        return CGRectInset(bounds, 35, 0);
    }
    return CGRectMake(10, 0, (bounds.size.width-20), (bounds.size.height));
}
@end
