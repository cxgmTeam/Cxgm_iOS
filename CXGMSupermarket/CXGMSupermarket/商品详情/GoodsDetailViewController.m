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
#import "DetailImagesFooterView.h"
#import "BlankCollectionFootView.h"
#import "DetailTopFootView.h"

#import "DetailTopToolView.h"

#import "ULBCollectionViewFlowLayout.h"

#import "AnotherCartViewController.h"

@interface GoodsDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ULBCollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)DetailTopToolView *topToolView;

@property (assign , nonatomic)BOOL isScrollDown;//滚动方向
@property (assign , nonatomic)NSInteger sectionIndex;
@property (assign , nonatomic)CGFloat alpha;

@property (strong , nonatomic)UIButton * addGoodsBtn;
@property (strong , nonatomic)UIButton * upTopBtn;
@end

/* cell */
static NSString *const DetailGoodReferralCellID = @"DetailGoodReferralCell";
static NSString *const DetailShowTypeCellID = @"DetailShowTypeCell";
static NSString *const GoodsListGridCellID = @"GoodsListGridCell";
/* head */
static NSString *const DetailShufflingHeadViewID = @"DetailShufflingHeadView";
static NSString *const DeatilCustomHeadViewID = @"DeatilCustomHeadView";
/* foot */
static NSString *const DetailImagesFooterViewID = @"DetailImagesFooterView";
static NSString *const BlankCollectionFootViewID = @"BlankCollectionFootView";
static NSString *const DetailTopFootViewID = @"DetailTopFootView";

#define GoodsHomeSilderImagesArray @[@"http://gfs5.gomein.net.cn/T1obZ_BmLT1RCvBVdK.jpg",@"http://gfs9.gomein.net.cn/T1C3J_B5LT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T1CwYjBCCT1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T1u8V_B4ET1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T1zODgB5CT1RCvBVdK.jpg"]


@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.addGoodsBtn];
    [self.addGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(50);
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

    self.topToolView.goodNameLabel.text = self.goodsModel.name;
    
    [self.view addSubview:self.upTopBtn];
    [self.upTopBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(40, 40));
        make.right.equalTo(-10);
        make.bottom.equalTo(-60);
    }];
    [self.upTopBtn addTarget:self action:@selector(onTapUpTopBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.goodsModel) {
        [self findProductDetail];
    }
}

- (void)setGoodsModel:(GoodsModel *)goodsModel{

    _goodsModel = goodsModel;
    
}


- (void)findProductDetail
{
    NSDictionary* dic = @{@"productId":self.goodsModel.id,
                          @"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""
                          };
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindProductDetail] token:nil parameters:dic success:^(id JSON, NSError *error){
        
    } failure:^(id JSON, NSError *error){
        
    }];
}



- (void)onTapUpTopBtn:(id)sender
{
    [UIView animateWithDuration:.5 animations:^{
        self.collectionView.contentOffset = CGPointZero;
    }];
    
}

- (void)addGoodsToCart:(id)sender
{
    if (![UserInfoManager sharedInstance].isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        return;
    }
    
    if (!self.goodsModel) return;
    
    NSDictionary* dic = @{@"amount":self.goodsModel.price.length>0?self.goodsModel.price:@"",
                          @"goodCode":self.goodsModel.goodCode.length>0?self.goodsModel.goodCode:@"",
                          @"goodName":self.goodsModel.name.length>0?self.goodsModel.name:@"",
                          @"goodNum":@"1",
                          @"shopId":self.goodsModel.shopId.length>0?self.goodsModel.shopId:@"",
                          @"productId":self.goodsModel.id.length>0?self.goodsModel.id:@""
                          };
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIShopAddCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD MBProgressHUDWithView:self.view Str:@"添加成功！"];
                [[NSNotificationCenter defaultCenter] postNotificationName:AddGoodsSuccess_Notify object:nil];
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
        return 6;
    }
    if (section == 2) { //猜你喜欢
        return 10;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {//基本信息
        DetailGoodReferralCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DetailGoodReferralCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    else if (indexPath.section == 1) {//详情
        DetailShowTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DetailShowTypeCellID forIndexPath:indexPath];
        cell.isHasindicateButton = NO;
        switch (indexPath.item) {
            case 0:
                cell.leftTitleLable.text = @"商品详情";
                 cell.contentLabel.text = @"";
                break;
            case 1:
                cell.leftTitleLable.text = @"品牌";
                cell.contentLabel.text = @"丽梅水果";
                break;
            case 2:
                cell.leftTitleLable.text = @"产地";
                cell.contentLabel.text = @"新西兰";
                break;
            case 3:
                cell.leftTitleLable.text = @"生产日期";
                cell.contentLabel.text = @"2018-04-28";
                break;
            case 4:
                cell.leftTitleLable.text = @"保质期";
                cell.contentLabel.text = @"30天";
                break;
            case 5:
                cell.leftTitleLable.text = @"存储条件";
                cell.contentLabel.text = @"冷藏0℃左右";
                break;
                
            default:
                break;
        }
        gridcell = cell;
    }
    else if (indexPath.section == 2) {//猜你喜欢
        GoodsListGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListGridCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            DetailShufflingHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DetailShufflingHeadViewID forIndexPath:indexPath];
            headerView.shufflingArray = GoodsHomeSilderImagesArray;
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
            reusableview = footview;
        }
        if (indexPath.section == 1) {
            DetailImagesFooterView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DetailImagesFooterViewID forIndexPath:indexPath];
            reusableview = footview;
        }
    }
    return reusableview;
}
    
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//基本信息
        return CGSizeMake(ScreenW , 125);
    }
    if (indexPath.section == 1 ) {
        return CGSizeMake(ScreenW, 45);
    }
    if (indexPath.section == 2) {//猜你喜欢
        return CGSizeMake((ScreenW - 12*3)/2, (ScreenW - 12*3)/2+72);
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
    if (section == 1) {
        return CGSizeMake(ScreenW, ScreenW*3/2.f);//详情图片
    }
    return CGSizeZero;
}
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 2) ? 11 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 2) ? 15 : 0;
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
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
//         当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        [self selectRowAtIndexPath:indexPath.section];
    }
}
// CollectionView分区标题展示结束
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
        [self.topToolView setAlphaOfView:self.alpha];
    }
}

// 选中 处理collectionView
- (void)selectSectionAtIndex:(NSInteger )index
{
    if (_sectionIndex == index) return;
        
    _sectionIndex = index;
    CGRect headerRect = [self frameForHeaderForSection:_sectionIndex];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    
    topOfHeader.y = topOfHeader.y - (NAVIGATION_BAR_HEIGHT+45+20);
    
    [self.collectionView setContentOffset:topOfHeader animated:YES];

}

- (CGRect)frameForHeaderForSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

#pragma mark- init
- (DetailTopToolView *)topToolView
{
    if (!_topToolView) {
        _topToolView = [DetailTopToolView new];
        WEAKSELF;
        _topToolView.backBtnClickBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _topToolView.scrollCollectionView = ^(NSInteger section){
            [weakSelf selectSectionAtIndex:section];
        };
        _topToolView.gotoCartBlock = ^{
            if (![UserInfoManager sharedInstance].isLogin) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
                return ;
            }
            AnotherCartViewController* vc = [AnotherCartViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [self.view addSubview:_topToolView];
    }
    return _topToolView;
}

- (UIButton *)addGoodsBtn{
    if (!_addGoodsBtn) {
        _addGoodsBtn = [UIButton new];
        _addGoodsBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [_addGoodsBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addGoodsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addGoodsBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [_addGoodsBtn addTarget:self action:@selector(addGoodsToCart:) forControlEvents:UIControlEventTouchUpInside];
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
        
        [_collectionView registerClass:[DetailShufflingHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DetailShufflingHeadViewID];
        [_collectionView registerClass:[DeatilCustomHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DeatilCustomHeadViewID];
        
        [_collectionView registerClass:[DetailImagesFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DetailImagesFooterViewID];
        [_collectionView registerClass:[BlankCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID];
        [_collectionView registerClass:[DetailTopFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DetailTopFootViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark-
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
