//
//  CategoryTableViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/17.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CategoryTableViewCell.h"


@interface CategoryTableViewCell ()
@property(nonatomic,strong)UIView* greenView;
@property(nonatomic,strong)UILabel* contentLabel;
@end

@implementation CategoryTableViewCell


- (void)setCategory:(CategoryModel *)category{
    
    _contentLabel.text = category.name;
    self.backgroundColor = [category.selected boolValue] == YES?[UIColor whiteColor]:[UIColor clearColor];
    _greenView.hidden = ![category.selected boolValue];
    
    if ([category.selected boolValue]) {
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _contentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    }else{
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _greenView = [UIView new];
        _greenView.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [self addSubview:_greenView];
        [_greenView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(4);
        }];
        _greenView.hidden = YES;
        
        _contentLabel = [UILabel new];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"类别";
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(4);
            make.centerY.equalTo(self);
            make.width.equalTo(93-4);
        }];
        
    }
    return self;
}

@end
