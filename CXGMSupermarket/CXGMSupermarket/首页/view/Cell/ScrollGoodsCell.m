//
//  ScrollGoodsCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "ScrollGoodsCell.h"
#import "GoodsListGridCell.h"

@interface ScrollGoodsCell ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
/* 底部 */
@property (strong , nonatomic)UIView *bottomLineView;
@end

static NSString *const GoodsListGridCellID = @"GoodsListGridCell";

@implementation ScrollGoodsCell


#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changGoodsNum:) name:AddGoodsSuccess_Notify object:nil];
    }
    return self;
}

- (void)changGoodsNum:(NSNotification *)notify
{
    NSDictionary* dic = [notify userInfo];
    
    for (GoodsModel* goods in self.goodsList) {
        if ([goods.sn isEqualToString:dic[@"sn"]]) {
            goods.shopCartNum = dic[@"shopCartNum"];
            goods.shopCartId = dic[@"shopCartId"];
            break;
        }
    }
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.backgroundColor;
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = RGB(245,245,245);
    [self addSubview:_bottomLineView];
    _bottomLineView.frame = CGRectMake(0, self.dc_height - 10, ScreenW, 10);
}


- (void)setGoodsList:(NSArray *)goodsList
{
    _goodsList = goodsList;
    [self.collectionView reloadData];
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListGridCellID forIndexPath:indexPath];
    cell.showOldPrice = NO;
    cell.goodsModel = self.goodsList[indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GoodsModel* goods = self.goodsList[indexPath.item];
    !self.showGoodsDetail?:self.showGoodsDetail(goods);
}

#pragma mark - lazyload
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake((ScreenW-40)/3.f, self.dc_height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.frame = self.bounds;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[GoodsListGridCell class] forCellWithReuseIdentifier:GoodsListGridCellID];
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _collectionView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
