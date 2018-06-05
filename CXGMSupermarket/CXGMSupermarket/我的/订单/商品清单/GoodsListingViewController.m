//
//  GoodsListingViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsListingViewController.h"
#import "OrderGoodsViewCell.h"
#import "GoodsDetailViewController.h"

@interface GoodsListingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@end

static NSString *const OrderGoodsViewCellID = @"OrderGoodsViewCell";

@implementation GoodsListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"商品清单";
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}

- (void)setGoodsArray:(NSArray *)goodsArray{
    _goodsArray = goodsArray;

}

#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    OrderGoodsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderGoodsViewCellID forIndexPath:indexPath];
    cell.goods = self.goodsArray[indexPath.item];
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    GoodsDetailViewController* vc = [GoodsDetailViewController new];
    GoodsModel *goods = self.goodsArray[indexPath.item];
    vc.goodsId = goods.productId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(ScreenW, 107);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[OrderGoodsViewCell class] forCellWithReuseIdentifier:OrderGoodsViewCellID];
        
        [self.view addSubview:_collectionView];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    }
    return _collectionView;
}
@end
