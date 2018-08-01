//
//  GoodsDetailViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/15.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsDetailViewController.h"
//cell
#import "DetailGoodReferralCell.h"
#import "DetailShowTypeCell.h"
#import "GoodsListGridCell.h"
//head
#import "DetailShufflingHeadView.h"
#import "DeatilCustomHeadView.h"
//foot
#import "BlankCollectionFootView.h"
#import "DetailTopFootView.h"

#import "DetailTopToolView.h"

#import "ULBCollectionViewFlowLayout.h"

#import "AnotherCartViewController.h"
#import "SelectSpecificationController.h"

#import <WebKit/WebKit.h>

#import "DetailImagesCell.h"

@interface GoodsDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ULBCollectionViewDelegateFlowLayout,WKNavigationDelegate>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)DetailTopToolView *topToolView;

@property (assign , nonatomic)BOOL isScrollDown;//滚动方向
@property (assign , nonatomic)NSInteger sectionIndex;
@property (assign , nonatomic)CGFloat alpha;

@property (strong , nonatomic)UIView * addGoodsBtn;
@property (strong , nonatomic)UIButton * upTopBtn;

@property (strong , nonatomic)GoodsModel * goodsDetail;

@property (strong , nonatomic)NSArray * pushArray;

@property (assign , nonatomic)NSInteger number;
@property (assign , nonatomic)DetailTopFootView *topFootview;

@property (strong , nonatomic)NSMutableArray *slideImageArray;

@property (strong , nonatomic)NSArray *introductImgs;
@property (strong , nonatomic)NSMutableArray *imgHeights;

@property (strong , nonatomic)NSMutableArray *detailInfoArr;
@end

/* cell */
static NSString *const DetailGoodReferralCellID = @"DetailGoodReferralCell";
static NSString *const DetailShowTypeCellID = @"DetailShowTypeCell";
static NSString *const GoodsListGridCellID = @"GoodsListGridCell";
static NSString *const DetailImagesCellID = @"DetailImagesCell";
/* head */
static NSString *const DetailShufflingHeadViewID = @"DetailShufflingHeadView";
static NSString *const DeatilCustomHeadViewID = @"DeatilCustomHeadView";
/* foot */
static NSString *const BlankCollectionFootViewID = @"BlankCollectionFootView";
static NSString *const DetailTopFootViewID = @"DetailTopFootView";



@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imgHeights = [NSMutableArray array];
    self.detailInfoArr = [NSMutableArray array];
    
    
    [self.view addSubview:self.addGoodsBtn];
    [self.addGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(TAB_BAR_HEIGHT);
    }];
    
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addGoodsBtn.top);
    }];
    self.collectionView.contentInset = UIEdgeInsetsMake(-STATUS_BAR_HEIGHT, 0, 0, 0);
    
    [self.topToolView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(NAVIGATION_BAR_HEIGHT+45);
    }];
    [self.topToolView setAlphaOfView:self.alpha];

    
    
    [self.view addSubview:self.upTopBtn];
    [self.upTopBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(40, 40));
        make.right.equalTo(-10);
        make.bottom.equalTo(-TAB_BAR_HEIGHT-10);
    }];
    [self.upTopBtn addTarget:self action:@selector(onTapUpTopBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.upTopBtn.hidden = YES;
    
    
    self.number = 1;
    
    self.slideImageArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //主要是刷新 shopCartNum 和 shopCartId
    if (self.goodsId) {
        [self findProductDetail];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)findProductDetail
{
    [self.slideImageArray removeAllObjects];
    [self.detailInfoArr  removeAllObjects];
    
    self.introductImgs = nil;
    [self.imgHeights removeAllObjects];
    
    NSDictionary* dic;
    if (self.shopId) {
        dic = @{@"productId":self.goodsId,
                @"shopId":self.shopId
                };
    }else{
        dic = @{@"productId":self.goodsId,
                @"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""
                };
    }
    
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindProductDetail] token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        
        if ([model.data isKindOfClass:[NSDictionary class]]) {
            
            self.goodsDetail = [[GoodsModel alloc] initWithDictionary:(NSDictionary *)model.data error:nil];

            if ([self.goodsDetail.introduction length] == 0) {
                self.goodsDetail.introduction = @"暂无详情的描述";
            }
            
            [self.detailInfoArr addObject:@[@"商品详情",@" "]];

            if ([self.goodsDetail.brandName length] > 0) {
                [self.detailInfoArr addObject:@[@"品牌",self.goodsDetail.brandName]];
            }
            
            if ([self.goodsDetail.originPlace length] > 0) {
                [self.detailInfoArr addObject:@[@"产地",self.goodsDetail.originPlace]];
            }
            
            [self.detailInfoArr addObject:@[@"生产日期",@"详情见包装"]];
            
            if ([self.goodsDetail.warrantyPeriod length] > 0 && ![self.goodsDetail.warrantyPeriod isEqualToString:@"null"] && ![self.goodsDetail.warrantyPeriod isEqualToString:@"null天"] && ![self.goodsDetail.warrantyPeriod isEqualToString:@"0天"]) {
                [self.detailInfoArr addObject:@[@"保质期",self.goodsDetail.warrantyPeriod]];
            }
            
            if ([self.goodsDetail.storageCondition length] > 0) {
                [self.detailInfoArr addObject:@[@"存储条件",self.goodsDetail.storageCondition]];
            }
            
            if ([self.goodsDetail.introduction length] > 0) {
                
                self.introductImgs = [self getURLFromStr:self.goodsDetail.introduction];
                
                for (NSString * urlString in self.introductImgs) {
                    [wself.imgHeights addObject:[wself calcuteImagesHeight:urlString]];
                }
            }

            if ([self.goodsDetail.productImageList isKindOfClass:[NSArray class]]) {
                for (NSDictionary* dic in self.goodsDetail.productImageList) {
                    [self.slideImageArray addObject:dic[@"url"]];
                }
            }
            
            self.topToolView.goodNameLabel.text = self.goodsDetail.name;
            [self.collectionView reloadData];
            
            [wself pushProducts];
            
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}


- (void)pushProducts
{
    NSDictionary* dic = @{@"productCategoryTwoId":self.goodsDetail.productCategoryTwoId.length>0?self.goodsDetail.productCategoryTwoId:@"",
                          @"productCategoryThirdId":self.goodsDetail.productCategoryThirdId.length>0?self.goodsDetail.productCategoryThirdId:@"",
                          @"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""
                          };
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIPushProducts] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            self.pushArray = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            
            [self.collectionView reloadData];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)onTapUpTopBtn:(id)sender
{
    [UIView animateWithDuration:.5 animations:^{
        self.collectionView.contentOffset = CGPointZero;
    }];
    
}

- (void)onTapAddCartBtn:(UIButton *)button
{
    if (![UserInfoManager sharedInstance].isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        return;
    }
    
    if (!self.goodsDetail) return;

    [self selectSpecification:nil];
}

#pragma mark-
- (void)addGoodsToCart:(GoodsModel *)goods number:(NSInteger)number
{
    CGFloat amount =  number*[goods.price floatValue];
    
    NSDictionary* dic = @{
                          @"id":goods.id.length>0?goods.id:@"",
                          @"amount":[NSString stringWithFormat:@"%.2f",amount],
                          @"goodCode":goods.goodCode.length>0?goods.goodCode:@"",
                          @"goodName":goods.name.length>0?goods.name:@"",
                          @"goodNum":[NSString stringWithFormat:@"%ld",number],
                          @"categoryId":goods.productCategoryId.length>0?goods.productCategoryId:@"",
                          @"shopId":goods.shopId.length>0?goods.shopId:[DeviceHelper sharedInstance].shop.id,
                          @"productId":goods.id.length>0?goods.id:@"",
                          };
    
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIShopAddCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.goodsDetail.shopCartNum = [NSString stringWithFormat:@"%ld",number];
                self.goodsDetail.shopCartId = [NSString stringWithFormat:@"%@",model.data];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:AddGoodsSuccess_Notify object:nil userInfo:@{@"sn":self.goodsDetail.sn,@"shopCartNum": self.goodsDetail.shopCartNum,@"shopCartId": self.goodsDetail.shopCartId}];
            });
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)updateCart:(GoodsModel *)goods number:(NSInteger)number
{
    CGFloat amount =  number*[goods.price floatValue];
    
    NSDictionary* dic = @{@"id":goods.shopCartId.length>0?goods.shopCartId:@"",
                          @"amount":[NSString stringWithFormat:@"%.2f",amount],
                          @"goodCode":goods.goodCode.length>0?goods.goodCode:@"",
                          @"goodName":goods.name.length>0?goods.name:@"",
                          @"goodNum":[NSString stringWithFormat:@"%ld",number],
                          @"categoryId":goods.productCategoryId.length>0?goods.productCategoryId:@"",
                          @"shopId":goods.shopId.length>0?goods.shopId:[DeviceHelper sharedInstance].shop.id,
                          @"productId":goods.id.length>0?goods.id:@""
                          };
    
    
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIUpdateCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.goodsDetail.shopCartNum = [NSString stringWithFormat:@"%ld",number];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:AddGoodsSuccess_Notify object:nil userInfo:@{@"sn":self.goodsDetail.sn,@"shopCartNum": self.goodsDetail.shopCartNum,@"shopCartId": self.goodsDetail.shopCartId}];
            });
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}



#pragma mark - <UICollectionViewDataSource>
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        return [UIColor whiteColor];
    }
    return [UIColor clearColor];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) { //基本信息
        return 1;
    }
    if (section == 1 ) { //详情
        return self.detailInfoArr.count+self.introductImgs.count;
    }
    if (section == 2) { //猜你喜欢
        return self.pushArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {//基本信息
        DetailGoodReferralCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DetailGoodReferralCellID forIndexPath:indexPath];
        cell.goods = self.goodsDetail;
        gridcell = cell;
    }
    else if (indexPath.section == 1) {//详情
        if (indexPath.item < self.detailInfoArr.count) {
            DetailShowTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DetailShowTypeCellID forIndexPath:indexPath];
            cell.isHasindicateButton = NO;
            
            NSArray* array = self.detailInfoArr[indexPath.item];
            if (array.count > 0) {
                cell.leftTitleLable.text = array[0];
            }
            if (array.count > 1) {
                cell.contentLabel.text = array[1];
            }
            
//            switch (indexPath.item) {
//                case 0:
//                    cell.leftTitleLable.text = @"商品详情";
//                    cell.contentLabel.text = @"";
//                    break;
//                case 1:
//                    cell.leftTitleLable.text = @"品牌";
//                    cell.contentLabel.text = self.goodsDetail.brandName;
//                    break;
//                case 2:
//                    cell.leftTitleLable.text = @"产地";
//                    cell.contentLabel.text = self.goodsDetail.originPlace;
//                    break;
//                case 3:
//                    cell.leftTitleLable.text = @"生产日期";
//                    cell.contentLabel.text = @"详情见包装";
//                    break;
//                case 4:
//                    cell.leftTitleLable.text = @"保质期";
//                    cell.contentLabel.text = self.goodsDetail.warrantyPeriod;
//                    break;
//                case 5:
//                    cell.leftTitleLable.text = @"存储条件";
//                    cell.contentLabel.text = self.goodsDetail.storageCondition;
//                    break;
//
//                default:
//                    break;
//            }
            gridcell = cell;
        }
        else
        {
            DetailImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DetailImagesCellID forIndexPath:indexPath];
            if (indexPath.item - self.detailInfoArr.count < self.introductImgs.count) {
                cell.imageUrl = self.introductImgs[indexPath.item - self.detailInfoArr.count];
            }
            gridcell = cell;
        }
    }
    else if (indexPath.section == 2) {//猜你喜欢
        GoodsListGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListGridCellID forIndexPath:indexPath];
        cell.goodsModel = self.pushArray[indexPath.item];
        gridcell = cell;
    }
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            DetailShufflingHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DetailShufflingHeadViewID forIndexPath:indexPath];
            headerView.shufflingArray = self.slideImageArray;
            reusableview = headerView;
        }else if (indexPath.section == 2){
            DeatilCustomHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DeatilCustomHeadViewID forIndexPath:indexPath];
            headerView.guessMarkLabel.text = @"猜你喜欢";
            reusableview = headerView;
        }
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0 ) {
            DetailTopFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DetailTopFootViewID forIndexPath:indexPath];
            footview.leftTitleLable.text = @"请选择 规格";
            [footview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSpecification:)]];
            reusableview = footview;
            
            self.topFootview = footview;
        }
    }
    return reusableview;
}
    
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//基本信息
        return CGSizeMake(ScreenW , 125);
    }
    if (indexPath.section == 1 )
    {
        if (indexPath.item < self.detailInfoArr.count) {
            return CGSizeMake(ScreenW, 45);
        }
        else
        {
            CGFloat height = 45;
            if (indexPath.item - self.detailInfoArr.count < self.imgHeights.count){
                height = [self.imgHeights[indexPath.item - self.detailInfoArr.count] floatValue];
                if (height < 0) {
                    height = 300;
                }
            }
            return CGSizeMake(ScreenW, height);
        }
    }
    if (indexPath.section == 2) {//猜你喜欢
        return CGSizeMake((ScreenW - 12*3)/2, (ScreenW - 12*3)/2+72+15);
    }
    return CGSizeZero;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(ScreenW, ScreenW); //图片滚动的宽高
    }
    if (section == 2 ) {//详情 猜你喜欢
        return CGSizeMake(ScreenW, 65);
    }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0 ) {
        return CGSizeMake(ScreenW, 65);
    }
    return CGSizeZero;
}
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        return 11;
    }
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        return 15;
    }
    //消除有些图片直接的白色
    if (section == 1) {
        return -0.5;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        return UIEdgeInsetsMake(12, 12, 12, 12);
    }
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        GoodsDetailViewController* vc = [GoodsDetailViewController new];
        GoodsModel* goods = self.pushArray[indexPath.item];
        vc.goodsId = goods.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//cell 的头部或尾部视图view将要显示出来的时候调用
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
//         当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        [self selectRowAtIndexPath:indexPath.section];
    }
}
//cell的头部或尾部视图view将要collectionView中移除的时候调用
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
//         当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index {
    if (index > 2) return;
    
    if (_sectionIndex != index) {
        _sectionIndex = index;
        
        [self.topToolView selectButton:index];
    }
}

#pragma mark - UIScrollView Delegate
//     标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static float lastOffsetY = 0;
    if (self.collectionView == scrollView) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
        
        self.alpha = lastOffsetY/ScreenW;
        if (self.alpha < 0) {
            self.alpha = 0;
        }
        if (self.alpha > 1) {
            self.alpha = 1;
        }
        
        self.upTopBtn.hidden = self.alpha>0?NO:YES;
        
        [self.topToolView setAlphaOfView:self.alpha];
    }
}

// 点击 商品 详情 推荐
- (void)selectSectionAtIndex:(NSInteger )index
{
    if (_sectionIndex == index) return;
        
    _sectionIndex = index;
    CGRect headerRect = [self frameForHeaderForSection:_sectionIndex];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    
    if (_sectionIndex == 0) {
        topOfHeader.y = 0;
    }else{
        topOfHeader.y = topOfHeader.y - (NAVIGATION_BAR_HEIGHT+45+20);
    }
    
    [self.collectionView setContentOffset:topOfHeader animated:YES];

}

- (CGRect)frameForHeaderForSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}


#pragma mark-
- (void)selectSpecification:(UITapGestureRecognizer *)gesture
{
    if (![UserInfoManager sharedInstance].isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        return;
    }
    SelectSpecificationController* vc = [SelectSpecificationController new];
    vc.delegate = self;
    vc.goods = self.goodsDetail;

    typeof(self) __weak wself = self;
    vc.selectFinished = ^(NSInteger number){
        self.number = number;
        
        if ([self.goodsDetail.shopCartNum intValue] > 0) {
            [wself updateCart:self.goodsDetail number:(self.number+[self.goodsDetail.shopCartNum intValue])];
        }else{
            [wself addGoodsToCart:self.goodsDetail number:self.number];
        }
        
        self.topFootview.leftTitleLable.text = [NSString stringWithFormat:@"已添加   %ld",(long)self.number];

    };
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller presentViewController:vc animated:YES completion:nil];
}

- (void)showShopCart
{
    AnotherCartViewController* vc = [AnotherCartViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- init
- (DetailTopToolView *)topToolView
{
    if (!_topToolView) {
        _topToolView = [DetailTopToolView new];
        typeof(self) __weak wself = self;
        _topToolView.backBtnClickBlock = ^{
            [wself.navigationController popViewControllerAnimated:YES];
        };
        _topToolView.scrollCollectionView = ^(NSInteger section){
            [wself selectSectionAtIndex:section];
        };
        _topToolView.gotoCartBlock = ^{
            if (![UserInfoManager sharedInstance].isLogin) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
                return ;
            }
            
            if (wself.fromShopCart) {
                [wself.navigationController popViewControllerAnimated:YES];
            }else{
                AnotherCartViewController* vc = [AnotherCartViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            }
        };
        [self.view addSubview:_topToolView];
    }
    return _topToolView;
}

- (UIView *)addGoodsBtn{
    if (!_addGoodsBtn) {
        _addGoodsBtn = [UIView new];
        _addGoodsBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        
        UIButton* button = [UIButton new];
        button.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [button setTitle:@"加入购物车" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [button addTarget:self action:@selector(onTapAddCartBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_addGoodsBtn addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.right.equalTo(self.addGoodsBtn);
            make.height.equalTo(49);
        }];
    }
    return _addGoodsBtn;
}

- (UIButton *)upTopBtn{
    if (!_upTopBtn) {
        _upTopBtn = [UIButton new];
        [_upTopBtn setImage:[UIImage imageNamed:@"to_top"] forState:UIControlStateNormal];
    }
    return _upTopBtn;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        ULBCollectionViewFlowLayout *layout = [ULBCollectionViewFlowLayout new];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        [_collectionView registerClass:[DetailGoodReferralCell class] forCellWithReuseIdentifier:DetailGoodReferralCellID];
        [_collectionView registerClass:[DetailShowTypeCell class] forCellWithReuseIdentifier:DetailShowTypeCellID];
        [_collectionView registerClass:[GoodsListGridCell class] forCellWithReuseIdentifier:GoodsListGridCellID];
        [_collectionView registerClass:[DetailImagesCell class] forCellWithReuseIdentifier:DetailImagesCellID];
        
        [_collectionView registerClass:[DetailShufflingHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DetailShufflingHeadViewID];
        [_collectionView registerClass:[DeatilCustomHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DeatilCustomHeadViewID];
        
        [_collectionView registerClass:[BlankCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID];
        [_collectionView registerClass:[DetailTopFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DetailTopFootViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSArray*)getURLFromStr:(NSString *)string {
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:string
                                                options:0
                                                  range:NSMakeRange(0, [string length])];
    
    //NSString *subStr;
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch;
        substringForMatch = [string substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    return arr;
}


- (NSNumber *)calcuteImagesHeight:(NSString *)imageUrl{
    
    CGFloat height = 0;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    
    UIImage *image = [UIImage imageWithData:data];
    
    height = image.size.height*ScreenW/image.size.width;
    return [NSNumber numberWithFloat:height];
}
@end
