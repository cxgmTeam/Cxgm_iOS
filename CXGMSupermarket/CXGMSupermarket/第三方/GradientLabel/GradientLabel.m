//
//  GradientLabel.m
//  iphoneLive
//
//  Created by 郭常青 on 2016/12/2.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "GradientLabel.h"

@interface GradientLabel ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;


@end

@implementation GradientLabel

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0.0,1.0);
        _gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        _gradientLayer.frame = self.label.frame;
        _gradientLayer.colors = self.colors?:@[[UIColor whiteColor], [UIColor blackColor]];
    }
    return _gradientLayer;
}

- (void)setText:(NSString *)text{
    self.label.text = text;
}

- (void) setGradientLabel {
    
    self.label = [[UILabel alloc] init];
    self.label.text = self.text?:@"渐变字体";
    [self.label setFont:self.font?:[UIFont systemFontOfSize:13]];
    [self.label setTextAlignment:self.textAlignment?:kCTLeftTextAlignment];
    [self addSubview:self.label];
    
    [self setNeedsDisplay];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label setFrame:self.bounds];
    // 添加渐变层到控制器的view图层上
    
    if (self.gradientLayer.superlayer == nil) {
        [self.layer addSublayer:self.gradientLayer];
        // mask层工作原理:按照透明度裁剪，只保留非透明部分，文字就是非透明的，因此除了文字，其他都被裁剪掉，这样就只会显示文字下面渐变层的内容，相当于留了文字的区域，让渐变层去填充文字的颜色。
        // 设置渐变层的裁剪层
        self.gradientLayer.mask = self.label.layer;
    }
    
}


@end
