//
//  BillCustomButton.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "BillCustomButton.h"

@implementation BillCustomButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        [self setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0].CGColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.layer.borderColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0].CGColor;
        [self setTitleColor:[UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    }else{
        self.layer.borderColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0].CGColor;
        [self setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    }
}

@end
