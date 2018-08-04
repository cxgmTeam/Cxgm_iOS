//
//  GoodsCouponController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/21.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsCouponController.h"
#import "CouponCollectionViewCell.h"


@interface GoodsCouponController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong , nonatomic)UICollectionView *collectionView;

@end

static NSString *const CouponCollectionViewCellID = @"CouponCollectionViewCell";

@implementation GoodsCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];

}

#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CouponCollectionViewCellID forIndexPath:indexPath];
    CouponsModel* item = self.listArray[indexPath.item];
    item.isExpire = item.status;
    cell.coupons = item;
    cell.expandClick = ^{
        item.isOpen = [NSString stringWithFormat:@"%d",![item.isOpen boolValue]];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponsModel* item = self.listArray[indexPath.item];
    if ([item.isOpen boolValue]) {
        return CGSizeMake(ScreenW-20, 140);
    }else{
        return CGSizeMake(ScreenW-20, 100);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CouponsModel* item = self.listArray[indexPath.item];
    !_selectCoupon?:_selectCoupon(item);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- init
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[CouponCollectionViewCell class] forCellWithReuseIdentifier:CouponCollectionViewCellID];
        [self.view addSubview:_collectionView];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return _collectionView;
}
@end
