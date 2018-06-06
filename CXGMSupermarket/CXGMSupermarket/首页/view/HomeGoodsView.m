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

#import "PurchaseCarAnimationTool.h"

@interface HomeGoodsView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ULBCollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray* categoryNames;//banner下面的分类

@property(nonatomic,strong)NSArray* topGoodsList;//精品推荐
@property(nonatomic,strong)NSArray* xinGoodsList;//新品上市
@property(nonatomic,strong)NSArray* hotGoodsList;//热销推荐
@property(assign,nonatomic)NSInteger pageNum;

@property(nonatomic,strong)NSArray* slideDataList;//轮播图数据
@property(nonatomic,strong)NSMutableArray* slideImageList;//轮播图数据

@property(nonatomic,strong)NSArray* advertiseList;//三个广告位
@property(nonatomic,strong)NSMutableArray* adBannarList;//下面的广告位

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
        
        self.categoryNames = @[@"新鲜水果",@"放心蔬菜",@"鲜肉蛋品",@"水产海鲜",
                               @"粮油副食",@"休闲零食",@"中外名酒",@"美妆百货"];
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        WEAKSELF
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            [weakSelf findTopProduct];
            [weakSelf findNewProduct];
            [weakSelf findHotProduct];
            
            [weakSelf findAdvertisement];
            [weakSelf findMotion];
        }];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoodsInfo:) name:LoginAccount_Success object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoodsInfo:) name:DeleteShopCart_Success object:nil];
        
        //页面会闪
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoodsInfo:) name:AddGoodsSuccess_Notify object:nil];
        
        self.slideImageList = [NSMutableArray array];
        self.adBannarList = [NSMutableArray array];
        
        [self requestGoodsList];
    }
    return self;
}

- (void)refreshGoodsInfo:(NSNotification *)notify{
    [self requestGoodsList];
}

- (void)requestGoodsList
{
    [self findTopProduct];
    [self findNewProduct];
    [self findHotProduct];
    
    [self findAdvertisement];
    [self findMotion];
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

        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
           weakSelf.hotGoodsList  = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
           
            [weakSelf.collectionView reloadData];
            
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        
    } failure:^(id JSON, NSError *error){
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}


//广告位
- (void)findAdvertisement
{
    
    [self.slideImageList removeAllObjects];
    
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }

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
    [self.adBannarList removeAllObjects];
    
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    WEAKSELF;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindMotion]  token:nil parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {

            for (NSDictionary* dic in (NSArray *)model.data) {
                AdBannarModel* model = [AdBannarModel AdBannarModelWithJson:dic];
                [self.adBannarList addObject:model];
            }
            [weakSelf.collectionView reloadData];
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}


#pragma mark - <UICollectionViewDataSource>
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    if (section == 5) {
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
    
    if (indexPath.section == 0) {//分类
        CategoryGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryGridCellID forIndexPath:indexPath];
        [cell setImage:[NSString stringWithFormat:@"homeCategory_%ld",indexPath.item] title:self.categoryNames[indexPath.item]];
        gridcell = cell;
    }else if (indexPath.section == 1) {
        HomeFeatureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeFeatureViewCellID forIndexPath:indexPath];
        cell.motionArray = self.advertiseList;
        gridcell = cell;
    }
    else if (indexPath.section == 2 || indexPath.section == 3){
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
    else if (indexPath.section == 4){
        MidAdGoodsViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:MidAdGoodsViewCellID forIndexPath:indexPath];
        cell.adBannar = self.adBannarList[indexPath.item];
        WEAKSELF;
        cell.showGoodsDetail = ^(GoodsModel *model){
            !weakSelf.showGoodsDetailVC?:weakSelf.showGoodsDetailVC(model);
        };
        gridcell = cell;
    }
    else if (indexPath.section == 5) {//热销
        GoodsListGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListGridCellID forIndexPath:indexPath];
        cell.goodsModel = self.hotGoodsList[indexPath.item];
        
//        typeof(cell) __weak weakCell = cell;
//        cell.PurchaseCarAnimation = ^(UIImageView * imageView){
//            CGRect rect = [self.collectionView convertRect:weakCell.frame toView:self];
//            CGRect imageViewRect   = imageView.frame;
//            imageViewRect.origin.y = rect.origin.y + imageViewRect.origin.y;
//            imageViewRect.origin.x = rect.origin.x;
//
//            [[PurchaseCarAnimationTool shareTool] startAnimationandView:imageView
//                                                                   rect:imageViewRect
//                                                            finisnPoint:CGPointMake(ScreenWidth / 4 * 2.5, ScreenHeight - TAB_BAR_HEIGHT)
//                                                            finishBlock:^(BOOL finish) {
//                                                                UITabBarController* tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                                                                UIView *tabbarBtn = tabBarController.tabBar.subviews[3];
//                                                                [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
//                                                            }];
//        };
        gridcell = cell;
        
    }

    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            SlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SlideshowHeadViewID forIndexPath:indexPath];
            headerView.imageGroupArray = self.slideImageList;
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
        else if (indexPath.section == 5){
            TextTitleHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TextTitleHeadViewID forIndexPath:indexPath];
            headerView.titleLabel.text = @"热销推荐";
            headerView.subTitleLabel.text = @"看大家都在买什么";
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
    if (indexPath.section == 1) {
        return CGSizeMake(ScreenW , 196+12);
    }
    if (indexPath.section == 2 || indexPath.section == 3) {
        return CGSizeMake(ScreenW, 212);
    }
    if (indexPath.section ==4) {
        return CGSizeMake(ScreenW, ScreenW*159/375.f+212);
    }
    if (indexPath.section == 5) {//热销
        return CGSizeMake((ScreenW - 12*3)/2, (ScreenW - 12*3)/2+72);
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
    if (section == 5) {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {        
        !_showSubCategoryVC?:_showSubCategoryVC();
    }
    if (indexPath.section == 5) {
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
