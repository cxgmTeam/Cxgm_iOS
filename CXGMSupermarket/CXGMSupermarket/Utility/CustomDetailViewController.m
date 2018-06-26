//
//  CustomDetailViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CustomDetailViewController.h"

@interface CustomDetailViewController ()

@end

@implementation CustomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipe];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;

}

//- (void)swipeBack:(UISwipeGestureRecognizer *)gesture
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)backButtonClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

@end
