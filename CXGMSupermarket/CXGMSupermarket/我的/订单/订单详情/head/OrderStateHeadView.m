//
//  OrderStateHeadView.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderStateHeadView.h"

@interface OrderStateHeadView ()
@property(nonatomic,strong)UIView* colorView;
@property(nonatomic,strong)UIImageView* stateimgView;
@property(nonatomic,strong)UILabel* stateLabel;
@property(nonatomic,strong)UILabel* descLabel;
@property(nonatomic,strong)UILabel* remainTimeLabel;
@end

//0待支付，1待配送（已支付），2配送中，3已完成，4退货
@implementation OrderStateHeadView

- (void)setOrderItem:(OrderModel *)orderItem{
    switch ([orderItem.status intValue]) {
        case 1:{
            _colorView.backgroundColor = [UIColor colorWithRed:250/255.0 green:142/255.0 blue:46/255.0 alpha:1/1.0];
            _stateimgView.image = [UIImage imageNamed:@"order_toPay"];
            _stateLabel.text = @"配送中";
            _descLabel.text = @"订单已经确认，配送小哥正在飞奔配送，请注意查收～";
            _remainTimeLabel.text = @"剩余 01:59";
        }
            
            break;
        case 2:{
            _colorView.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
            _stateimgView.image = [UIImage imageNamed:@"order_deliver"];
            _stateLabel.text = @"配送中";
            _descLabel.text = @"订单已经确认，配送小哥正在飞奔配送，请注意查收～";
            _remainTimeLabel.text = @"";
        }
            
            break;
        case 3:{
            _colorView.backgroundColor = [UIColor colorWithRed:36/255.0 green:158/255.0 blue:226/255.0 alpha:1/1.0];
            _stateimgView.image = [UIImage imageNamed:@"order_finished"];
            _stateLabel.text = @"已完成";
            _descLabel.text = @"订单已经完成，欢迎下次惠顾～";
            _remainTimeLabel.text = @"";
        }
            
            break;

            

        case 4:{
            _colorView.backgroundColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1/1.0];
            _stateimgView.image = [UIImage imageNamed:@"order_cancelled"];
            _stateLabel.text = @"已取消";
            _descLabel.text = @"订单取消成功(订单超市未支付,系统取消订单)";
            _remainTimeLabel.text = @"";
        }
            
            break;
            
        default:
            break;
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        
        [self setupUI];

    }
    return self;
}

- (void)setupUI{
    
    _colorView = [UIView new];
    _colorView.backgroundColor = [UIColor colorWithRed:36/255.0 green:158/255.0 blue:226/255.0 alpha:1/1.0];
    [self addSubview:_colorView];
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    
    _stateimgView = [UIImageView new];
    _stateimgView.image = [UIImage imageNamed:@"order_finished"];
    [self addSubview:_stateimgView];
    [_stateimgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.top.equalTo(14);
    }];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.text = @"已完成";
    _stateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _stateLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.stateimgView);
        make.left.equalTo(self.stateimgView.right).offset(4);
    }];
    
    _remainTimeLabel = [[UILabel alloc] init];
    _remainTimeLabel.text = @"剩余 01:59";
    _remainTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _remainTimeLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:_remainTimeLabel];
    [_remainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(14);
        make.right.equalTo(-40);
    }];
    
    
    UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.right.equalTo(-15);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.text = @"订单已经完成，欢迎下次惠顾～";
    _descLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _descLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.bottom.equalTo(-22);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(1);
    }];

}
@end
