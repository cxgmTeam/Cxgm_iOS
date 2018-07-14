//
//  DetailGoodReferralCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DetailGoodReferralCell.h"
#import "DCUpDownButton.h"
#import "DCSpeedy.h"

@interface DetailGoodReferralCell ()
/* 商品标题 */
@property (strong , nonatomic)UILabel *goodTitleLabel;
/* 商品小标题 */
@property (strong , nonatomic)UILabel *goodSubtitleLabel;
/* 商品价格 */
@property (strong , nonatomic)UILabel *goodPriceLabel;
@property (strong , nonatomic)UILabel *oldPriceLabel;

@property (strong , nonatomic)UILabel* unitLabel;
@property (strong , nonatomic)UIImageView* imgView;

@end

@implementation DetailGoodReferralCell
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setGoods:(GoodsModel *)goods{
    _goods = goods;
    
    _goodTitleLabel.text = goods.name;
    _goodSubtitleLabel.text = goods.fullName;
    _goodPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[goods.price floatValue]];
    _unitLabel.text = [NSString stringWithFormat:@"/%@",goods.unit];
    
    if ([goods.price floatValue] != [goods.originalPrice floatValue] && [goods.originalPrice floatValue]>0) {
        _oldPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[goods.originalPrice floatValue]];
        
        NSUInteger length = [_oldPriceLabel.text length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_oldPriceLabel.text];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0] range:NSMakeRange(0, length)];
        [_oldPriceLabel setAttributedText:attri];
        
        _imgView.hidden = NO;
        
    }else{
        _oldPriceLabel.text = @"";
        _imgView.hidden = YES;
    }
}

#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];

    _goodTitleLabel = [[UILabel alloc] init];
    _goodTitleLabel.numberOfLines = 2;
    _goodTitleLabel.text = @"圣湖 青海特产老酸奶优质特惠 245g  8瓶装";
    _goodTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    _goodTitleLabel.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
    [self addSubview:_goodTitleLabel];
    
    
    _goodSubtitleLabel = [[UILabel alloc] init];
    _goodSubtitleLabel.text = @"果实饱满 富含青花素 香甜可口";
    _goodSubtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _goodSubtitleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self addSubview:_goodSubtitleLabel];
    _goodSubtitleLabel.backgroundColor = [UIColor redColor];
    
    _goodPriceLabel = [[UILabel alloc] init];
    _goodPriceLabel.text = @"￥19.90";
    _goodPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
    _goodPriceLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [self addSubview:_goodPriceLabel];
    [_goodPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodTitleLabel);
        make.bottom.mas_equalTo(-15);
    }];
    
    _unitLabel = [UILabel new];
    _unitLabel.text = @"/个";
    _unitLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _unitLabel.textColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1/1.0];
    [self addSubview:_unitLabel];
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodPriceLabel.right);
        make.bottom.mas_equalTo(self.goodPriceLabel);
    }];
    
    _oldPriceLabel = [[UILabel alloc] init];
    _oldPriceLabel.text = @"¥ 89.9";
    _oldPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _oldPriceLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    [self addSubview:_oldPriceLabel];
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.unitLabel.right).offset(11);
        make.bottom.mas_equalTo(self.goodPriceLabel);
    }];
    
    
    NSUInteger length = [_oldPriceLabel.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_oldPriceLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0] range:NSMakeRange(0, length)];
    [_oldPriceLabel setAttributedText:attri];
    

    _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tehui_limited"]];
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-16);
        make.right.mas_equalTo(-14);
    }];
    
}
#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];

    [_goodTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(ScreenW-15-70);
    }];
    
    [_goodSubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.goodTitleLabel);
        [make.top.mas_equalTo(self.goodTitleLabel.mas_bottom)setOffset:3];
    }];
    


}


@end
