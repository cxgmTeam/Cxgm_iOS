//
//  CouponListViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponCollectionViewCell.h"
#import "CouponItem.h"

@interface CouponListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)UIView *emptyView;
@property (strong , nonatomic)NSMutableArray *listArray;
@end

static NSString *const CouponCollectionViewCellID = @"CouponCollectionViewCell";


@implementation CouponListViewController

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
        _collectionView.contentInset = UIEdgeInsetsMake(14, 10, 10, 10);
        
    }
    return _collectionView;
}

- (void)loadData
{
    [self setupCouponEmptyView];
    
    for (NSInteger i = 0; i < 3; i++) {
        CouponItem* item = [CouponItem new];
        item.isOpen = NO;
        [self.listArray addObject:item];
    }
    [self.collectionView reloadData];
    
    _emptyView.hidden = self.listArray.count>0? YES:NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}

- (void)setupCouponEmptyView{
    if (!_emptyView) {
        _emptyView = [UIView new];
        [self.view addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_empty"]];
        [_emptyView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.emptyView);
            make.top.equalTo(50);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"目前没有可用优惠券";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [_emptyView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.emptyView);
            make.top.equalTo(imageView.bottom).offset(11);
        }];
    }
}

#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CouponCollectionViewCellID forIndexPath:indexPath];
    CouponItem* item = self.listArray[indexPath.item];
    item.isExpire = self.isExpire;
    cell.couponItem = item;
    cell.expandClick = ^{
        item.isOpen = !item.isOpen;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponItem* item = self.listArray[indexPath.item];
    if (item.isOpen) {
        return CGSizeMake(ScreenW-20, 140);
    }else{
        return CGSizeMake(ScreenW-20, 100);
    }
}

@end
