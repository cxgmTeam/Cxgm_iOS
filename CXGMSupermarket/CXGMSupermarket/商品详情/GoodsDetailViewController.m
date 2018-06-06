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
#import "SelectSpecificationController.h"

#import <WebKit/WebKit.h>

@interface GoodsDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ULBCollectionViewDelegateFlowLayout,WKNavigationDelegate>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)DetailTopToolView *topToolView;

@property (assign , nonatomic)BOOL isScrollDown;//滚动方向
@property (assign , nonatomic)NSInteger sectionIndex;
@property (assign , nonatomic)CGFloat alpha;

@property (strong , nonatomic)UIButton * addGoodsBtn;
@property (strong , nonatomic)UIButton * upTopBtn;

@property (strong , nonatomic)GoodsModel * goodsDetail;

@property (strong , nonatomic)NSArray * pushArray;

@property (assign , nonatomic)NSInteger number;
@property (assign , nonatomic)DetailTopFootView *topFootview;

@property (strong , nonatomic)NSMutableArray *slideImageArray;

//辅助
@property (strong , nonatomic)WKWebView *auxiliaryWebView;
@property (assign , nonatomic)CGFloat webViewHeight;
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



@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.auxiliaryWebView.frame = CGRectMake(0, 0, ScreenW, 5);
    self.auxiliaryWebView.hidden = YES;
    
    
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

    
    
    [self.view addSubview:self.upTopBtn];
    [self.upTopBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(40, 40));
        make.right.equalTo(-10);
        make.bottom.equalTo(-60);
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
    
    NSDictionary* dic = @{@"productId":self.goodsId,
                          @"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""
                          };
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindProductDetail] token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSDictionary class]]) {
            self.goodsDetail = [[GoodsModel alloc] initWithDictionary:(NSDictionary *)model.data error:nil];
            
//            [self.auxiliaryWebView loadHTMLString:self.goodsDetail.introduction baseURL:nil];
            
//            self.goodsDetail.introduction = @"<p style=\"line-height: 2em; text-indent: 2em;\"><span style=\"font-family: 黑体, SimHei; font-size: 16px;\">5月19日，第28次全国助残日前夕，中国盲文图书馆联合中医学院志愿者共同举办了一场中医义诊活动。</span></p><p style=\"line-height: 2em; text-indent: 2em;\"><span style=\"font-family: 黑体, SimHei; font-size: 16px;\">活动现场为残疾人及其家属等免费提供针灸、推拿、按摩、拔罐等服务，并提供中医药类相关咨询，同时发放宣传资料、开展健康宣讲向残疾人及其亲属等普及中医药类养生保健知识，传播“防大于治”的科学健康理念。</span></p><p style=\"line-height: 2em; text-indent: 2em;\"><span style=\"font-family: 黑体, SimHei; font-size: 16px;\">本次活动紧紧围绕今年全国助残日“全面建成小康社会，残疾人一个也不同时能少”的主题，通过义诊志愿服务的开展，落实了“精准健康扶贫”的相关精神，进一步提升了残疾人的健康素养，同时营造了扶残助残的良好氛围。</span></p><p style=\"text-align: center;\"><img src=\"http://filewhzm.blc.org.cn/270/png/B00/0HTYV6BHXZ6QTFFB.png\" title=\"\" alt=\"助残日义诊活动.png\"/></p><p style=\"text-align: center;\"><span style=\"font-family: 黑体, SimHei; font-size: 14px;\">图为义诊活动现场</span></p>";
            
            if ([self.goodsDetail.introduction length] > 0) {
                [wself updateWebVWithContent:self.goodsDetail.introduction];
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


-(void)updateWebVWithContent:(NSString*)string
{
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"HTMLTemplate" ofType:@"html"];
    NSMutableString *htmlString = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSRange contentRange = [htmlString rangeOfString:@"{content}"];
    if (contentRange.location != NSNotFound) {
        [htmlString replaceCharactersInRange:contentRange withString:string];
    }
    [self.auxiliaryWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:htmlPath]];
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
    
    if ([self.goodsDetail.shopCartNum intValue] > 0) {
        [self updateCart:self.goodsDetail];
    }else{
        [self addGoodsToCart:self.goodsDetail];
    }
}


- (void)addGoodsToCart:(GoodsModel *)goods
{
    CGFloat amount = [goods.price floatValue]*self.number;
    
    NSDictionary* dic = @{
                          @"id":goods.id.length>0?goods.id:@"",
                          @"amount":[NSString stringWithFormat:@"%.2f",amount],
                          @"goodCode":goods.goodCode.length>0?goods.goodCode:@"",
                          @"goodName":goods.name.length>0?goods.name:@"",
                          @"goodNum":[NSString stringWithFormat:@"%ld",(long)self.number],
                          @"categoryId":goods.productCategoryId.length>0?goods.productCategoryId:@"",
                          @"shopId":goods.shopId.length>0?goods.shopId:[DeviceHelper sharedInstance].shop.id,
                          @"productId":goods.id.length>0?goods.id:@"",
                          };

    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIShopAddCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.goodsDetail.shopCartNum = [NSString stringWithFormat:@"%ld",(long)self.number];
                self.goodsDetail.shopCartId = [NSString stringWithFormat:@"%@",model.data];
                
                [MBProgressHUD MBProgressHUDWithView:self.view Str:@"添加成功！"];
            
                [[NSNotificationCenter defaultCenter] postNotificationName:AddGoodsSuccess_Notify object:nil];
            });
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)updateCart:(GoodsModel *)goods
{
    CGFloat amount = (self.number+[goods.shopCartNum integerValue])*[goods.price floatValue];
    
    NSDictionary* dic = @{@"id":goods.shopCartId.length>0?goods.shopCartId:@"",
                          @"amount":[NSString stringWithFormat:@"%.2f",amount],
                          @"goodCode":goods.goodCode.length>0?goods.goodCode:@"",
                          @"goodName":goods.name.length>0?goods.name:@"",
                          @"goodNum":[NSString stringWithFormat:@"%d",1+[goods.shopCartNum intValue]],
                          @"categoryId":goods.productCategoryId.length>0?goods.productCategoryId:@"",
                          @"shopId":goods.shopId.length>0?goods.shopId:[DeviceHelper sharedInstance].shop.id,
                          @"productId":goods.id.length>0?goods.id:@""
                          };
    

    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIUpdateCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
                [MBProgressHUD MBProgressHUDWithView:controller.view Str:@"添加成功！"];
                
                self.goodsDetail.shopCartNum = [NSString stringWithFormat:@"%ld",(long)([self.goodsDetail.shopCartNum integerValue]+self.number)];
                
                
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
        DetailShowTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DetailShowTypeCellID forIndexPath:indexPath];
        cell.isHasindicateButton = NO;
        switch (indexPath.item) {
            case 0:
                cell.leftTitleLable.text = @"商品详情";
                 cell.contentLabel.text = @"";
                break;
            case 1:
                cell.leftTitleLable.text = @"品牌";
                cell.contentLabel.text = self.goodsDetail.brandName;
                break;
            case 2:
                cell.leftTitleLable.text = @"产地";
                cell.contentLabel.text = self.goodsDetail.originPlace;
                break;
            case 3:
                cell.leftTitleLable.text = @"生产日期";
                cell.contentLabel.text = self.goodsDetail.creationDate;
                break;
            case 4:
                cell.leftTitleLable.text = @"保质期";
                cell.contentLabel.text = self.goodsDetail.warrantyPeriod;
                break;
            case 5:
                cell.leftTitleLable.text = @"存储条件";
                cell.contentLabel.text = self.goodsDetail.storageCondition;
                break;
                
            default:
                break;
        }
        gridcell = cell;
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
            footview.leftTitleLable.text = [NSString stringWithFormat:@"已选择   %ld份",(long)self.number];
            [footview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSpecification:)]];
            reusableview = footview;
            
            self.topFootview = footview;
        }
        if (indexPath.section == 1) {
            DetailImagesFooterView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DetailImagesFooterViewID forIndexPath:indexPath];
            footview.htmlString = self.goodsDetail.introduction;
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
        return CGSizeMake(ScreenW, self.webViewHeight);//详情图片
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
    vc.goods = self.goodsDetail;
    
    typeof(self) __weak wself = self;
    vc.selectFinished = ^(NSInteger number){
        self.number = number;
        
        self.topFootview.leftTitleLable.text = [NSString stringWithFormat:@"已选择   %ld份",(long)self.number];
        
        if ([self.goodsDetail.shopCartNum intValue] > 0) {
            [wself updateCart:self.goodsDetail];
        }else{
            [wself addGoodsToCart:self.goodsDetail];
        }
        
    };
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller presentViewController:vc animated:YES completion:nil];
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
        [_addGoodsBtn addTarget:self action:@selector(onTapAddCartBtn:) forControlEvents:UIControlEventTouchUpInside];
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
- (WKWebView *)auxiliaryWebView{
    if (!_auxiliaryWebView) {

        _auxiliaryWebView = [WKWebView new];
        [_auxiliaryWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        _auxiliaryWebView.navigationDelegate = self;
        [_auxiliaryWebView setMultipleTouchEnabled:YES];
        [_auxiliaryWebView setAutoresizesSubviews:YES];
        [_auxiliaryWebView.scrollView setAlwaysBounceVertical:YES];
        _auxiliaryWebView.scrollView.bounces = NO;
        [self.view addSubview:_auxiliaryWebView];
    }
    return _auxiliaryWebView;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [webView evaluateJavaScript: @"document.body.scrollHeight" completionHandler:^(NSString *string, NSError * error){
         self.webViewHeight = [string intValue];
        
        [self.collectionView reloadData];
        
    }];
}

@end
