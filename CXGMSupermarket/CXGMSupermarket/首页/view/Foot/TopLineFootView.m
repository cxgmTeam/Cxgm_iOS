//
//  TopLineFootView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "TopLineFootView.h"
#import "DCTitleRolling.h"

@interface TopLineFootView ()<UIScrollViewDelegate,CDDRollingDelegate>
/* 滚动 */
@property (strong , nonatomic)DCTitleRolling *numericalScrollView;
@end

@implementation TopLineFootView
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        [self setUpBase];
        
        [self setUpRollingTitle];
        
    }
    return self;
}

- (void)setRoTitles:(NSArray *)roTitles
{
    _roTitles = roTitles;
    
    [self setUpRollingTitle];
}

- (void)setUpRollingTitle
{
    if (_numericalScrollView) {
        [_numericalScrollView removeFromSuperview];
        _numericalScrollView = nil;
    }
    
    //初始化
    _numericalScrollView = [[DCTitleRolling alloc] initWithFrame:CGRectMake(94, 1, self.dc_width-100, 70) WithTitleData:^(CDDRollingGroupStyle *rollingGroupStyle, NSString *__autoreleasing *leftImage, NSArray *__autoreleasing *rolTitles, NSArray *__autoreleasing *rolTags, NSArray *__autoreleasing *rightImages, NSString *__autoreleasing *rightbuttonTitle, NSInteger *interval, float *rollingTime, NSInteger *titleFont, UIColor *__autoreleasing *titleColor, BOOL *isShowTagBorder) {
        
        *rollingTime = 0.25;
//        *rolTags = @[@"冬季健康日",@"新手上路",@"年终内购会",@"GitHub星星走一波"];
//        *rolTitles = @[@"这里是生鲜的头条信息展示区域，轮播展示标题内容一行时居中，两行时折行展示。",@"2000元热门手机推荐",@"好奇么？点进去哈",@"这套家具比房子还贵"];
        *rolTitles = self.roTitles;
//        *leftImage = @"shouye_img_toutiao";
        *interval = 6.0;
        *titleFont = 13;
//        *isShowTagBorder = YES;
        *isShowTagBorder = NO;
        *titleColor =  [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    }];
    _numericalScrollView.delegate = self;
    _numericalScrollView.moreClickBlock = ^{
        NSLog(@"mall----more");
    };
    
    [_numericalScrollView dc_beginRolling];
    _numericalScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_numericalScrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setUpBase
{
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(17, 13, 53, 18);
    label.text = @"菜鲜果美";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [self addSubview:label];

    label = [[UILabel alloc] init];
    label.backgroundColor = Color00A862;
    label.frame = CGRectMake(17, 35, 53, 18);
    label.text = @"最新简报";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:label];
    
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"f2f3f4"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self);
        make.height.equalTo(1);
    }];

    
    UIView* bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = RGB(245, 245, 245);
    [self addSubview:bottomLineView];
    bottomLineView.frame = CGRectMake(0, self.dc_height - 10, ScreenW, 10);
}

#pragma mark - Setter Getter Methods

#pragma mark - 滚动条点击事件

- (void)dc_RollingViewSelectWithActionAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%zd头条滚动条",index);
    !_showReportDetail?:_showReportDetail(index);
}

@end
