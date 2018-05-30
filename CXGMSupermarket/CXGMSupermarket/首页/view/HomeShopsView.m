//
//  HomeShopsView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "HomeShopsView.h"
//cell
#import "ShopFeatureViewCell.h"
#import "HomeShopViewCell.h"
//head
#import "SlideshowHeadView.h"

@interface HomeShopsView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (assign , nonatomic)NSInteger pageNum;
@property (strong , nonatomic)NSMutableArray *shopList;

@property(nonatomic,strong)NSArray* slideDataList;//轮播图数据
@property(nonatomic,strong)NSMutableArray* slideImageList;//轮播图数据
@end


/* cell */
static NSString *const ShopFeatureViewCellID = @"ShopFeatureViewCell";
static NSString *const HomeShopViewCellID = @"HomeShopViewCell";
/* head */
static NSString *const SlideshowHeadViewID = @"SlideshowHeadView";


@implementation HomeShopsView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.slideImageList = [NSMutableArray array];
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        typeof(self) __weak wself = self;
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            wself.pageNum = 1;
            [wself.shopList removeAllObjects];
            [wself getShopList];
            [wself findAdvertisement];
        }];
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            wself.pageNum ++;
            [wself getShopList];
        }];
        
        self.pageNum = 1;
        self.shopList = [NSMutableArray array];
        
//        [self findAdvertisement];
        [self getShopList];
    }
    return self;
}

//广告位
- (void)findAdvertisement
{
    
    [self.slideImageList removeAllObjects];
    
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    WEAKSELF;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindAdvertisement]  token:nil parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array  = [AdvertisementModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            
            NSMutableArray* array1 = [NSMutableArray array];
            for (AdvertisementModel* model in array) {
                if ([model.position isEqualToString:@"1"]) {
                    [array1 addObject:model];
                }
            }
            
            
            self.slideDataList = [array1 sortedArrayUsingComparator:^NSComparisonResult(AdvertisementModel * obj1, AdvertisementModel * obj2){
                return [obj1.number  compare: obj2.number];
            }];
            
            for (AdvertisementModel* ad in self.slideDataList) {
                [self.slideImageList addObject:ad.imageUrl.length>0?ad.imageUrl:@""];
            }
            
            [weakSelf.collectionView reloadData];
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)getShopList
{
    NSDictionary* dic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)self.pageNum],
                          @"pageSize":@"10"};
    
    [AFNetAPIClient GET:[LoginBaseURL stringByAppendingString:APIShopList] token:nil parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            NSArray* array = [ShopModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            [self.shopList addObjectsFromArray:array];
            [self.collectionView reloadData];
        }
        if ([model.listModel.isLastPage boolValue]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(id JSON, NSError *error){
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark-
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 2;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
//    if (section == 1) {
//        return self.shopList.count;
//    }
//    return 0;
    return self.shopList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
//    if (indexPath.section == 0) {
//        ShopFeatureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopFeatureViewCellID forIndexPath:indexPath];
//        gridcell = cell;
//
//    }else if (indexPath.section == 1) {
        HomeShopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeShopViewCellID forIndexPath:indexPath];
        cell.shopModel = self.shopList[indexPath.item];
        gridcell = cell;
//    }
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
//        if (indexPath.section == 0) {
//            SlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SlideshowHeadViewID forIndexPath:indexPath];
//            headerView.imageGroupArray = self.slideImageList;
//            reusableview = headerView;
//        }
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return CGSizeMake(ScreenW , 41);
//    }
//    if (indexPath.section == 1) {
//        return CGSizeMake(ScreenW, 66+ScreenW*190/375.f);
//        return CGSizeMake(ScreenW, 256);
//    }
//    return CGSizeZero;
    return CGSizeMake(ScreenW, 66+ScreenW*190/375.f);
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
//    if (section == 0) {
//        return CGSizeMake(ScreenW, ScreenW*190/375.f); //图片滚动的宽高
//    }
    return CGSizeZero;
}
#pragma mark - <UICollectionViewDelegateFlowLayout>

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return (section == 1) ? 10 : 0;
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    if (section == 1) {
//        return UIEdgeInsetsMake(10, 0, 10, 0);
//    }
//    return UIEdgeInsetsZero;
    
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [DeviceHelper sharedInstance].shop = self.shopList[indexPath.item];
    
    !_selectShopHandler?:_selectShopHandler();
}
#pragma mark- init
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[ShopFeatureViewCell class] forCellWithReuseIdentifier:ShopFeatureViewCellID];
        [_collectionView registerClass:[HomeShopViewCell class] forCellWithReuseIdentifier:HomeShopViewCellID];
        
        [_collectionView registerClass:[SlideshowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SlideshowHeadViewID];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

@end
