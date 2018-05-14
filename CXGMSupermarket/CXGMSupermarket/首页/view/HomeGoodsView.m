//
//  HomeGoodsView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/3.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "HomeGoodsView.h"
//cell
#import "CategoryGridCell.h"
#import "ScrollGoodsCell.h"
#import "GoodsListGridCell.h"
#import "HomeFeatureViewCell.h"
//head
#import "SlideshowHeadView.h"
#import "MidAdHeadView.h"
#import "TextTitleHeadView.h"
//foot
#import "TopLineFootView.h"

#import "ULBCollectionViewFlowLayout.h"

@interface HomeGoodsView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ULBCollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray* categoryNames;//banner下面的分类

@property(nonatomic,strong)NSArray* topGoodsList;//精品推荐
@property(nonatomic,strong)NSArray* xinGoodsList;//新品上市
@property(nonatomic,strong)NSMutableArray* hotGoodsList;//热销推荐
@property(assign,nonatomic)NSInteger pageNum;

@end

#define GoodsHomeSilderImagesArray @[@"http://gfs5.gomein.net.cn/T1obZ_BmLT1RCvBVdK.jpg",@"http://gfs9.gomein.net.cn/T1C3J_B5LT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T1CwYjBCCT1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T1u8V_B4ET1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T1zODgB5CT1RCvBVdK.jpg"]

/* cell */
static NSString *const CategoryGridCellID = @"CategoryGridCell";
static NSString *const ScrollGoodsCellID = @"ScrollGoodsCell";
static NSString *const GoodsListGridCellID = @"GoodsListGridCell";
static NSString *const HomeFeatureViewCellID = @"HomeFeatureViewCell";
/* head */
static NSString *const SlideshowHeadViewID = @"SlideshowHeadView";
static NSString *const MidAdHeadViewID = @"MidAdHeadView";
static NSString *const TextTitleHeadViewID = @"TextTitleHeadView";
/* foot */
static NSString *const TopLineFootViewID = @"TopLineFootView";


@implementation HomeGoodsView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.categoryNames = @[@"美味生鲜",@"新鲜果蔬",@"休闲零食",@"粮油调味"];
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        WEAKSELF
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageNum = 1;
            [weakSelf.hotGoodsList removeAllObjects];
            
            [weakSelf findTopProduct];
            [weakSelf findNewProduct];
            [weakSelf findHotProduct];
        }];
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageNum ++;
            [weakSelf findHotProduct];
        }];
    }
    
    self.pageNum = 1;
    self.hotGoodsList = [NSMutableArray array];
    
    [self findTopProduct];
    [self findNewProduct];
    [self findHotProduct];


    return self;
}


//精品推荐
- (void)findTopProduct
{
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindTopProduct]  token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            self.topGoodsList = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            [self.collectionView reloadData];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

//新品上市
- (void)findNewProduct
{
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindNewProduct]  token:nil parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            self.xinGoodsList = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            [self.collectionView reloadData];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

//热销推荐
- (void)findHotProduct
{
    NSDictionary* dic = @{@"shopId":@"",
                          @"pageNum":[NSString stringWithFormat:@"%ld",(long)self.pageNum],
                          @"pageSize":@"10"};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id,
                @"pageNum":[NSString stringWithFormat:@"%ld",(long)self.pageNum],
                @"pageSize":@"10"};
    }
    WEAKSELF;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindHotProduct]  token:nil parameters:dic success:^(id JSON, NSError *error){

        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
           NSArray* array  = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            [weakSelf.hotGoodsList addObjectsFromArray:array];
            [weakSelf.collectionView reloadData];
            if (array.count == 0) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
        }else{
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        
    } failure:^(id JSON, NSError *error){
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}


#pragma mark - <UICollectionViewDataSource>
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    if (section == 7) {
        return [UIColor whiteColor];
    }
    return [UIColor clearColor];
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {//4个分类
        return 4;
    }
    if (section == 7) { //热销
        return self.hotGoodsList.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    
    if (indexPath.section == 0) {//分类
        CategoryGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryGridCellID forIndexPath:indexPath];
        [cell setImage:[NSString stringWithFormat:@"homeCategory_%ld",indexPath.item] title:self.categoryNames[indexPath.item]];
        gridcell = cell;
    }else if (indexPath.section == 1) {
        HomeFeatureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeFeatureViewCellID forIndexPath:indexPath];
        
        gridcell = cell;
    }
    else if (indexPath.section == 7) {//热销
        GoodsListGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListGridCellID forIndexPath:indexPath];
        cell.goodsModel = self.hotGoodsList[indexPath.item];
        gridcell = cell;
        
    }else{
        ScrollGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScrollGoodsCellID forIndexPath:indexPath];
        switch (indexPath.section) {
            case 2:
                cell.goodsList = self.topGoodsList;
                break;
            case 3:
                cell.goodsList = self.xinGoodsList;
                break;
            default:
                break;
        }
        WEAKSELF;
        cell.showGoodsDetail = ^(GoodsModel* model){
            !weakSelf.showGoodsDetailVC?:weakSelf.showGoodsDetailVC(model);
        };
        gridcell = cell;
    }

    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            SlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SlideshowHeadViewID forIndexPath:indexPath];
            headerView.imageGroupArray = GoodsHomeSilderImagesArray;
            reusableview = headerView;
        }else if (indexPath.section == 2){
            TextTitleHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TextTitleHeadViewID forIndexPath:indexPath];
            headerView.titleLabel.text = @"精品推荐";
            headerView.subTitleLabel.text = @"精心挑选的超值好货";
            reusableview = headerView;
        }else if (indexPath.section == 3){
            TextTitleHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TextTitleHeadViewID forIndexPath:indexPath];
            headerView.titleLabel.text = @"新品上市";
            headerView.subTitleLabel.text = @"搜索好味道，抢先品尝";
            reusableview = headerView;
        }
        else if (indexPath.section == 7){
            TextTitleHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TextTitleHeadViewID forIndexPath:indexPath];
            headerView.titleLabel.text = @"热销推荐";
            headerView.subTitleLabel.text = @"看大家都在买什么";
            reusableview = headerView;
        }
        else if (indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6){
            MidAdHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MidAdHeadViewID forIndexPath:indexPath];
            reusableview = headerView;
        }
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            TopLineFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TopLineFootViewID forIndexPath:indexPath];
            reusableview = footview;
        }
    }
    
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        return CGSizeMake(ScreenW/4 , 112);
    }
    if (indexPath.section == 1) {//分类
        return CGSizeMake(ScreenW , 196+12);
    }
    if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6) {
        return CGSizeMake(ScreenW, 212);
    }
    if (indexPath.section == 7) {//热销
        return CGSizeMake((ScreenW - 12*3)/2, (ScreenW - 12*3)/2+72);
    }
    return CGSizeZero;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(ScreenW, ScreenW*190/375.f); //图片滚动的宽高
    }
    if (section == 2 || section == 3 || section == 7) {//精品推荐  新品上市
        return CGSizeMake(ScreenW, 74);
    }
    if (section == 4 || section == 5 || section == 6) {
        return CGSizeMake(ScreenW, ScreenW*159/375.f);
    }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenW, 80);  //Top头条的宽高
    }
    return CGSizeZero;
}
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 7) ? 11 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 7) ? 15 : 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 7) {
        return UIEdgeInsetsMake(0, 12, 12, 12);
    }
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {        
        !_showSubCategoryVC?:_showSubCategoryVC();
    }
    if (indexPath.section == 7) {
        GoodsModel* goods = self.hotGoodsList[indexPath.item];
        !_showGoodsDetailVC?:_showGoodsDetailVC(goods);
    }
}

#pragma mark- init
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        ULBCollectionViewFlowLayout *layout = [ULBCollectionViewFlowLayout new];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[CategoryGridCell class] forCellWithReuseIdentifier:CategoryGridCellID];
        [_collectionView registerClass:[ScrollGoodsCell class] forCellWithReuseIdentifier:ScrollGoodsCellID];
        [_collectionView registerClass:[GoodsListGridCell class] forCellWithReuseIdentifier:GoodsListGridCellID];
        [_collectionView registerClass:[HomeFeatureViewCell class] forCellWithReuseIdentifier:HomeFeatureViewCellID];
        
        [_collectionView registerClass:[SlideshowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SlideshowHeadViewID];
        [_collectionView registerClass:[TextTitleHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TextTitleHeadViewID];
        [_collectionView registerClass:[MidAdHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MidAdHeadViewID];
        
        [_collectionView registerClass:[TopLineFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TopLineFootViewID];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
@end
