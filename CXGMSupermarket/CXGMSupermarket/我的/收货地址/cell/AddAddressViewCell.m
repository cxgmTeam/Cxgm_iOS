//
//  AddAddressViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AddAddressViewCell.h"

@interface AddAddressViewCell ()
@property(nonatomic,strong)UILabel* headLabel;
@end

@implementation AddAddressViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _headLabel = [[UILabel alloc] init];
        _headLabel.text = @"收货人：";
        _headLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _headLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [self addSubview:_headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.centerY.equalTo(self);
        }];
        
        
        _textField = [UITextField new];
        _textField.placeholder = @"请填写";
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.headLabel.right).offset(10);
            make.height.equalTo(30);
            make.centerY.equalTo(self);
            make.width.equalTo(100);
        }];
        
        _arrow = [UIImageView new];
        _arrow.image = [UIImage imageNamed:@"arrow_right"];
        [self addSubview:_arrow];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(-10);
            make.centerY.equalTo(self);
        }];
        _arrow.hidden = YES;
        
        UIView* line = [UIView new];
        line.backgroundColor = ColorE8E8E8E;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(1);
        }];
    }
    return self;
}

- (void)setHeadTitle:(NSString *)title{
    _headLabel.text = title;
    
    NSDictionary *dic =@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]};
    CGSize size = [_headLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    [_textField updateConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(ScreenW-15-size.width-10-20);
    }];
    
}
@end
