//
//  CutomNavigationController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CutomNavigationController.h"

@interface CutomNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation CutomNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置背景色
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    //设置字体
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Color333333, NSForegroundColorAttributeName,PFR17Font, NSFontAttributeName,nil, nil ]];
    
    self.navigationBar.barStyle = UIBarStyleBlack;
     //去除导航栏下方的横线
//    [self.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBar.translucent = NO;
    
    
    //添加自定义的下划线
    [self.navigationBar setShadowImage:[self imageWithColor:[UIColor colorWithWhite:0xd3/255.f alpha:1.f] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)]];
    
    self.delegate = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


#pragma mark-
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end
