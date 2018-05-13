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

#pragma mark - lazyload
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake(96, self.dc_height-10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.frame = self.bounds;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[GoodsListGridCell class] forCellWithReuseIdentifier:GoodsListGridCellID];
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return _collectionView;
}

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.backgroundColor;
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = RGB(245,245,245);
    [self addSubview:_bottomLineView];
    _bottomLineView.frame = CGRectMake(0, self.dc_height - 8, ScreenW, 8);
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
@end
