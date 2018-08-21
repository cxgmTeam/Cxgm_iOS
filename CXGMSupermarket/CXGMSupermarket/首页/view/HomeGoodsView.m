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
#import "MidAdGoodsViewCell.h"
//head
#import "SlideshowHeadView.h"
#import "TextTitleHeadView.h"
//foot
#import "TopLineFootView.h"

#import "ULBCollectionViewFlowLayout.h"


@interface HomeGoodsView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ULBCollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray* categoryNames;//banner下面的分类

@property(nonatomic,strong)NSMutableArray* topGoodsList;//精品推荐
@property(nonatomic,strong)NSArray* xinGoodsList;//新品上市
@property(nonatomic,strong)NSMutableArray* hotGoodsList;//热销推荐
@property(assign,nonatomic)NSInteger pageNum;

@property(nonatomic,strong)NSArray* slideDataList;//轮播图数据
@property(nonatomic,strong)NSMutableArray* slideImageList;//轮播图数据

@property(nonatomic,strong)NSArray* advertiseList;//三个广告位
@property(nonatomic,strong)NSMutableArray* adBannarList;//下面的广告位

@property(nonatomic,strong)NSArray* reportList;//滚动简报
@property(nonatomic,strong)NSMutableArray* motionNameList;//滚动简报title

@property(assign,nonatomic)BOOL flagValue;
@end


/* cell */
static NSString *const CategoryGridCellID = @"CategoryGridCell";
static NSString *const ScrollGoodsCellID = @"ScrollGoodsCell";
static NSString *const GoodsListGridCellID = @"GoodsListGridCell";
static NSString *const HomeFeatureViewCellID = @"HomeFeatureViewCell";
static NSString *const MidAdGoodsViewCellID = @"MidAdGoodsViewCell";
/* head */
static NSString *const SlideshowHeadViewID = @"SlideshowHeadView";
static NSString *const TextTitleHeadViewID = @"TextTitleHeadView";
/* foot */
static NSString *const TopLineFootViewID = @"TopLineFootView";


@implementation HomeGoodsView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.flagValue = YES;
        
        //休闲零食 88  放心蔬菜 102 新鲜水果 113 鲜肉蛋品112 水鲜海产109 粮油副食 105 中外名酒 115 美妆个护106
        if ([DeviceHelper sharedInstance].showWineCategory)
        {
            self.categoryNames = @[@[@"新鲜水果",@"113",@"homeCategory_0"],
                                   @[@"放心蔬菜",@"102",@"homeCategory_1"],
                                   @[@"鲜肉蛋品",@"112",@"homeCategory_2"],
                                   @[@"水产海鲜",@"109",@"homeCategory_3"],
                                   @[@"粮油副食",@"105",@"homeCategory_4"],
                                   @[@"休闲零食",@"88",@"homeCategory_5"],
                                   @[@"中外名酒",@"115",@"homeCategory_6"],
                                   @[@"美妆个护",@"106",@"homeCategory_7"]];
        }else{
            self.categoryNames = @[@[@"新鲜水果",@"113",@"homeCategory_0"],
                                   @[@"放心蔬菜",@"102",@"homeCategory_1"],
                                   @[@"鲜肉蛋品",@"112",@"homeCategory_2"],
                                   @[@"水产海鲜",@"109",@"homeCategory_3"],
                                   @[@"粮油副食",@"105",@"homeCategory_4"],
                                   @[@"休闲零食",@"88",@"homeCategory_5"],
                                   @[@"美妆个护",@"106",@"homeCategory_7"]];
        }

        
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        WEAKSELF
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.collectionView.mj_header endRefreshing];
            
            [weakSelf findTopProduct];
            [weakSelf findNewProduct];
            [weakSelf findHotProduct];
            
            [weakSelf findAdvertisement];
            [weakSelf findMotion];
            
            [weakSelf findReport];
        }];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoodsInfo:) name:LoginAccount_Success object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoodsInfo:) name:DeleteShopCart_Success object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoodsInfo:) name:AddOrder_Success object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changGoodsNum:) name:AddGoodsSuccess_Notify object:nil];
        
        
        self.slideImageList = [NSMutableArray array];
        self.adBannarList = [NSMutableArray array];
        self.motionNameList = [NSMutableArray array];
        
        self.topGoodsList = [NSMutableArray array];
        self.hotGoodsList = [NSMutableArray array];
        
        [self requestGoodsList];
    }
    return self;
}

- (void)refreshGoodsInfo:(NSNotification *)notify{
    [self requestGoodsList];
}

- (void)changGoodsNum:(NSNotification *)notify
{
    NSDictionary* dic = [notify userInfo];
    
    for (GoodsModel* goods in self.hotGoodsList) {
        if ([goods.sn isEqualToString:dic[@"sn"]]) {
            goods.shopCartNum = dic[@"shopCartNum"];
            goods.shopCartId = dic[@"shopCartId"];
            break;
        }
    }
}

- (void)requestGoodsList
{
    [self findTopProduct];
    [self findNewProduct];
    [self findHotProduct];
    
    [self findAdvertisement];
    [self findMotion];
    
    [self findReport];
}


//精品推荐
- (void)findTopProduct
{
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    
    NSString* token = @"";
    if ([UserInfoManager sharedInstance].isLogin) {
        token = [UserInfoManager sharedInstance].userInfo.token;
    }
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindTopProduct]  token:token parameters:dic success:^(id JSON, NSError *error){
        
        [self.topGoodsList removeAllObjects];
        
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            NSArray * array = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            if ([DeviceHelper sharedInstance].showWineCategory) {
                [self.topGoodsList addObjectsFromArray:array];
            }
            else
            {
                for (GoodsModel * model in array) {
                    if (![model.productCategoryName isEqualToString:@"中外名酒"]) {
                        [self.topGoodsList addObject:model];
                    }
                }
            }

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
    
    NSString* token = @"";
    if ([UserInfoManager sharedInstance].isLogin) {
        token = [UserInfoManager sharedInstance].userInfo.token;
    }
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindNewProduct]  token:token parameters:dic success:^(id JSON, NSError *error){
        
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
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    
    NSString* token = @"";
    if ([UserInfoManager sharedInstance].isLogin) {
        token = [UserInfoManager sharedInstance].userInfo.token;
    }

    
    WEAKSELF;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindHotProduct]  token:token parameters:dic success:^(id JSON, NSError *error){

        [self.hotGoodsList removeAllObjects];
        
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
           NSArray * array  = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            if ([DeviceHelper sharedInstance].showWineCategory) {
                 [self.hotGoodsList addObjectsFromArray:array];
            }else{
                for (GoodsModel * model in array) {
                    if (![model.productCategoryName isEqualToString:@"中外名酒"]) {
                        [self.hotGoodsList addObject:model];
                    }
                }
            }

            [weakSelf.collectionView reloadData];
        }
        
    } failure:^(id JSON, NSError *error){

    }];
}


//广告位
- (void)findAdvertisement
{
    
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    
    self.slideDataList = nil;
    self.advertiseList = nil;
    [self.slideImageList removeAllObjects];
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindAdvertisement]  token:nil parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array  = [AdvertisementModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            
            NSMutableArray* array1 = [NSMutableArray array];
            NSMutableArray* array2 = [NSMutableArray array];
            for (AdvertisementModel* model in array) {
                if ([model.position isEqualToString:@"1"]) {
                    [array1 addObject:model];
                }
                if ([model.position isEqualToString:@"2"]) {
                    [array2 addObject:model];
                }
            }

            self.slideDataList = [array1 sortedArrayUsingComparator:^NSComparisonResult(AdvertisementModel * obj1, AdvertisementModel * obj2){
                return [obj1.number  compare: obj2.number];
            }];
            
            [self.slideImageList removeAllObjects];
            for (AdvertisementModel* ad in self.slideDataList) {
                [self.slideImageList addObject:ad.imageUrl.length>0?ad.imageUrl:@""];
            }


            self.advertiseList = [array2 sortedArrayUsingComparator:^NSComparisonResult(AdvertisementModel * obj1, AdvertisementModel * obj2){
                return [obj1.number  compare: obj2.number];
            }];
            
            [self.collectionView reloadData];
        }
        
    } failure:^(id JSON, NSError *error){

    }];
}

//根据门店ID查询首页运营位置
- (void)findMotion
{
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    WEAKSELF;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindMotion]  token:nil parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {

            [self.adBannarList removeAllObjects];
            
            for (NSDictionary* dic in (NSArray *)model.data) {
                AdBannarModel* model = [AdBannarModel AdBannarModelWithJson:dic];
                [self.adBannarList addObject:model];
            }
            [weakSelf.collectionView reloadData];
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

//简报
- (void)findReport
{
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    
    self.reportList = nil;
    [self.motionNameList removeAllObjects];
    
    WEAKSELF;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindReport]  token:nil parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            
            self.reportList = [AdBannarModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            for (AdBannarModel* model in self.reportList) {
                [self.motionNameList addObject:model.motionName];
            }
            [weakSelf.collectionView reloadData];
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}


#pragma mark - <UICollectionViewDataSource>
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    if (section == 0 || section == 5) {
        return [UIColor whiteColor];
    }
    return [UIColor clearColor];
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {//4个分类
        return self.categoryNames.count;
    }
    if (section == 4) {
        return self.adBannarList.count;
    }
    if (section == 5) { //热销
        return self.hotGoodsList.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    
    if (indexPath.section == 0)
    {//分类
        CategoryGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryGridCellID forIndexPath:indexPath];
        [cell setImage:[self.categoryNames[indexPath.item] objectAtIndex:2] title:[self.categoryNames[indexPath.item] objectAtIndex:0]];
        gridcell = cell;
    
    }
    else if (indexPath.section == 1)
    {
        HomeFeatureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeFeatureViewCellID forIndexPath:indexPath];
        cell.motionArray = self.advertiseList;
        typeof(self) __weak wself = self;
        cell.showAdvertiseDetail = ^(AdvertisementModel * ad){
            !wself.showAdvertiseDetailVC?:wself.showAdvertiseDetailVC(ad);
        };
        gridcell = cell;
    }
    else if (indexPath.section == 2 || indexPath.section == 3)
    {
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
    else if (indexPath.section == 4)
    {
        MidAdGoodsViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:MidAdGoodsViewCellID forIndexPath:indexPath];
        
        if (indexPath.item < self.adBannarList.count) {
            cell.adBannar = self.adBannarList[indexPath.item];
        }
        
        WEAKSELF;
        cell.showGoodsDetail = ^(GoodsModel *model){
            !weakSelf.showGoodsDetailVC?:weakSelf.showGoodsDetailVC(model);
        };
        cell.tapAdImageHandler = ^{
            
            if (indexPath.item < self.adBannarList.count){
                !weakSelf.showBusinessDetailVC?:weakSelf.showBusinessDetailVC(self.adBannarList[indexPath.item]);
            }
            
        };
        gridcell = cell;
    }
    else if (indexPath.section == 5)
    {//热销
        GoodsListGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListGridCellID forIndexPath:indexPath];
        
        if (indexPath.item < self.hotGoodsList.count) {
            cell.goodsModel = self.hotGoodsList[indexPath.item];
        }
        
        gridcell = cell;
        
    }

    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section == 0)
        {
            SlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SlideshowHeadViewID forIndexPath:indexPath];
            headerView.imageGroupArray = self.slideImageList;
            typeof(self) __weak wself = self;
            headerView.showAdvertiseDetail = ^(NSInteger index){
                
                if (index < self.slideDataList.count) {
                    AdvertisementModel* ad = self.slideDataList[index];
                    !wself.showAdvertiseDetailVC?:wself.showAdvertiseDetailVC(ad);
                }
            };
            reusableview = headerView;
        }
        else if (indexPath.section == 2)
        {
            TextTitleHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TextTitleHeadViewID forIndexPath:indexPath];
            headerView.titleLabel.text = @"精品推荐";
            headerView.subTitleLabel.text = @"精心挑选的超值好货";
            reusableview = headerView;
        }
        else if (indexPath.section == 3)
        {
            TextTitleHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TextTitleHeadViewID forIndexPath:indexPath];
            headerView.titleLabel.text = @"新品上市";
            headerView.subTitleLabel.text = @"搜索好味道，抢先品尝";
            reusableview = headerView;
        }
        else if (indexPath.section == 5){
            TextTitleHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TextTitleHeadViewID forIndexPath:indexPath];
            headerView.titleLabel.text = @"热销推荐";
            headerView.subTitleLabel.text = @"看大家都在买什么";
            reusableview = headerView;
        }
        
    }
    if (kind == UICollectionElementKindSectionFooter)
    {
        if (indexPath.section == 0)
        {
            TopLineFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TopLineFootViewID forIndexPath:indexPath];
            footview.roTitles = self.motionNameList;
            typeof(self) __weak wself = self;
            footview.showReportDetail = ^(NSInteger index){
                
                if (index < self.reportList.count) {
                    !wself.showBusinessDetailVC?:wself.showBusinessDetailVC(self.reportList[index]);
                }
                
            };
            reusableview = footview;
        }
    }
    
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        return CGSizeMake(ScreenW/4 , 10+6+20+ScreenW/6);
    }
    if (indexPath.section == 1) {
        return CGSizeMake(ScreenW , 196+12);
    }
    if (indexPath.section == 2 || indexPath.section == 3) {
        return CGSizeMake(ScreenW, 98+(ScreenW-40)/3.f);
    }
    if (indexPath.section ==4) {
        AdBannarModel* model = self.adBannarList[indexPath.item];
        if (model.productList.count > 0) {
            return CGSizeMake(ScreenW, 10+(ScreenW*159/375.f)+11+(ScreenW-40)/3.f+98);
        }
        return CGSizeMake(ScreenW, ScreenW*159/375.f+10);
    }
    if (indexPath.section == 5) {//热销
        return CGSizeMake((ScreenW - 12*3)/2, (ScreenW - 12*3)/2+72+15);
    }
    return CGSizeZero;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(ScreenW, ScreenW*190/375.f); //图片滚动的宽高
    }
    if (section == 2 || section == 3 || section == 5) {//精品推荐  新品上市
        return CGSizeMake(ScreenW, 74);
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
    return (section == 5) ? 11 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 5) ? 15 : 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 5, 0);
    }
    if (section == 5) {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.item < self.categoryNames.count) {
        !_showSubCategoryVC?:_showSubCategoryVC(self.categoryNames[indexPath.item]);
    }
    if (indexPath.section == 5 && indexPath.item < self.hotGoodsList.count) {
        GoodsModel* goods = self.hotGoodsList[indexPath.item];
        !_showGoodsDetailVC?:_showGoodsDetailVC(goods);
    }
}

#pragma mark-
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    BOOL flag;
    if (scrollView.contentOffset.y > 10) {
        flag = NO;
    }else{
        flag = YES;
    }
    !_showHYNoticeView?:_showHYNoticeView(flag);
    
    if (flag != self.flagValue) {
        self.flagValue = flag;
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
        [_collectionView registerClass:[MidAdGoodsViewCell class] forCellWithReuseIdentifier:MidAdGoodsViewCellID];
        
        [_collectionView registerClass:[SlideshowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SlideshowHeadViewID];
        [_collectionView registerClass:[TextTitleHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TextTitleHeadViewID];
        
        [_collectionView registerClass:[TopLineFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TopLineFootViewID];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark-
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
