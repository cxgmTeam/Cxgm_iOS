//
//  OrderCollectionViewCell.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderCollectionViewCell.h"
#import "GoodsScreenshotsGridCell.h"

@interface OrderCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UIView* whiteView;

@property(nonatomic,strong)UILabel* orderNumber; //订单号
@property(nonatomic,strong)UILabel* orderState; //订单状态

@property (strong , nonatomic)UICollectionView *collectionView; //有时候需要隐藏

@property(nonatomic,strong)UILabel* priceLabel; //价格
@property(nonatomic,strong)UILabel* countLabel; //数量

@property(nonatomic,strong)UIView* bottomView;  //没有按钮的时候要隐藏
@property(nonatomic,strong)UIButton* buyButton;


@end

static NSString *const GoodsScreenshotsGridCellID = @"GoodsScreenshotsGridCell";

@implementation OrderCollectionViewCell

//0待支付，1待配送（已支付），2配送中，3已完成，4退货
- (void)setOrderItem:(OrderModel *)orderItem
{
    switch ([orderItem.status integerValue]) {
        case 0:{
            _orderState.text = @"待付款";
            _bottomView.hidden = NO;
            [_buyButton setTitle:@"去支付" forState:UIControlStateNormal];
        }
            break;
        case 2:{
            _orderState.text = @"配送中";
            _bottomView.hidden = NO;
            [_buyButton setTitle:@"申请退款" forState:UIControlStateNormal];
        }
            break;
        case 3:{
            _orderState.text = @"已完成";
            _bottomView.hidden = NO;
            [_buyButton setTitle:@"再次购买" forState:UIControlStateNormal];
        }
            break;

        case 4:{
            _orderState.text = @"已退货";
            _bottomView.hidden = YES;
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

- (void)setupUI
{
    
    _whiteView = [UIView new];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteView];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(12, 0, 0, 0));
    }];
    
    
    _orderNumber = [[UILabel alloc] init];
    _orderNumber.text = @"订单号：2190008978676";
    _orderNumber.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _orderNumber.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [_whiteView addSubview:_orderNumber];
    [_orderNumber mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.top.equalTo(13);
    }];
    
    _orderState = [[UILabel alloc] init];
    _orderState.text = @"超时取消";
    _orderState.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _orderState.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [_whiteView addSubview:_orderState];
    [_orderState mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-15);
        make.top.equalTo(13);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ColorE8E8E8E;
    [_whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self);
        make.top.equalTo(44);
        make.height.equalTo(1);
    }];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(45+13);
        make.left.right.equalTo(self);
        make.height.equalTo((ScreenW-60)/4.f);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.text = @"¥ 23.90";
    _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _priceLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [_whiteView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(45+13+(ScreenW-60)/4.f+12);
        make.right.equalTo(-15);
    }];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.text = @"共3种  需付款： ";
    _countLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _countLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [_whiteView addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.priceLabel);
        make.right.equalTo(self.priceLabel.left).offset(-10);
    }];
    
    _bottomView = [UIView new];
    [_whiteView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(45);
        make.left.right.bottom.equalTo(self);
    }];
    {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = ColorE8E8E8E;
        [_bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.right.equalTo(self.bottomView);
            make.height.equalTo(1);
        }];
        
        _buyButton = [UIButton new];
        _buyButton.layer.borderColor = Color999999.CGColor;
        _buyButton.layer.borderWidth = 1;
        _buyButton.layer.cornerRadius = 3;
        [_buyButton setTitle:@"再次购买" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        _buyButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_buyButton addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_buyButton];
        [_buyButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(-15);
            make.size.equalTo(CGSizeMake(72, 26));
            make.centerY.equalTo(self.bottomView);
        }];
    }
}

- (void)onTapButton:(id)sender{
    !_tapBuyButton?:_tapBuyButton();
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake((ScreenW-60)/4.f, (ScreenW-60)/4.f);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[GoodsScreenshotsGridCell class] forCellWithReuseIdentifier:GoodsScreenshotsGridCellID];
        [_whiteView addSubview:_collectionView];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
    }
    return _collectionView;
}

#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsScreenshotsGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsScreenshotsGridCellID forIndexPath:indexPath];
    return cell;
}

@end
