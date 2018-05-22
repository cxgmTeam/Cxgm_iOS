//
//  OrderConfirmViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderConfirmViewController.h"
//cell
#import "GoodsCashViewCell.h"
#import "OrderCouponViewCell.h"
#import "OrderBillViewCell.h"
#import "OrderCustomerViewCell.h"
//head
#import "RemainTimeHintHead.h"
#import "OrderGoodsInfoHead.h"
//foot
#import "BlankCollectionFootView.h"
#import "GoodsArrivedTimeFoot.h"

#import "GoodsListingViewController.h"
#import "OrderBillViewController.h"
#import "AddressViewController.h"
#import "GoodsCouponController.h"

#import "LZCartModel.h"
#import "OrderBillViewController.h"

#import "PaymentViewController.h"

@interface OrderConfirmViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)UILabel *moneyLabel;

@property (strong , nonatomic)AddressModel* address;
@end

/* cell */
static NSString *const GoodsCashViewCellID = @"GoodsCashViewCell";
static NSString *const OrderCouponViewCellID = @"OrderCouponViewCell";
static NSString *const OrderBillViewCellID = @"OrderBillViewCell";

static NSString *const OrderCustomerViewCellID = @"OrderCustomerViewCell";
/* head */
static NSString *const OrderGoodsInfoHeadID = @"OrderGoodsInfoHead";
/* foot */
static NSString *const BlankCollectionFootViewID = @"BlankCollectionFootView";
static NSString *const GoodsArrivedTimeFootID = @"GoodsArrivedTimeFoot";

@implementation OrderConfirmViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    [self setupBottom];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(-50);
    }];
    
    if (self.goodsArray.count > 0) {
        [self checkCoupon];
    }
    
    
    [self getAddressList];
    
}

//下单接口
- (void)addOrder:(NSArray *)array
{
    NSDictionary* dic = @{};
    
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIAddOrder] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

//请求地址 取第一天作为默认地址
- (void)getAddressList
{
    if (![UserInfoManager sharedInstance].isLogin) return;
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    
    [AFNetAPIClient GET:[LoginBaseURL stringByAppendingString:APIAddressList] token:userInfo.token parameters:nil success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = [AddressModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            if (array.count > 0) {
                self.address = [array firstObject];
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
            }
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

//请求优惠券
- (void)checkCoupon
{
    
    NSMutableArray* categoryArray = [NSMutableArray array];
    for (LZCartModel *model in self.goodsArray)
    {
        BOOL flag = NO;
        for (NSString * category in categoryArray) {
            if ([model.categoryId isEqualToString:category]) {
                flag = YES;
                break;
            }
        }
        if (!flag) {
            [categoryArray addObject:model.categoryId];
        }
    }
    
    NSMutableArray* array1 = [NSMutableArray array];
    for (NSString * category in categoryArray)
    {
        CGFloat amount = 0;
        
        for (LZCartModel *model in self.goodsArray)
        {
            if ([model.categoryId isEqualToString:category])
            {
                amount = amount + [model.price floatValue];
            }
        }
        NSDictionary* dic = @{
                              @"categoryId":category,
                              @"amount":[NSString stringWithFormat:@"%.2f",amount]
                              };
        [array1 addObject:dic];
    }
    
    
    NSMutableArray* array2 = [NSMutableArray array];
    for (LZCartModel *model in self.goodsArray) {
        NSDictionary* dic = @{
//                              @"createTime": @"",
                              @"goodCode": model.goodCode.length>0?model.goodCode:@"",
                              @"id": model.id.length>0?model.id:@"",
//                              @"orderId": @"0",
//                              @"productId": @"0",
                              @"productName": model.goodName.length>0?model.goodName:@"",
                              @"productNum": model.goodNum.length>0?model.goodNum:@"1"
                              };
        [array2 addObject:dic];
    }
    
    NSDictionary* param = @{@"categoryAndAmountList":array1,
                            @"productList":array2};
    
    
    NSDictionary* dic =  @{@"order":param};
    
//    [AFNetAPIClient POST:[OrderBaseURL stringByAppendingString:APICheckCoupon] token:[UserInfoManager sharedInstance].userInfo.token parameters:param success:^(id JSON, NSError *error){
//
//    } failure:^(id JSON, NSError *error){
//
//    }];
    
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APICheckCoupon] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    } failure:^(id JSON, NSError *error){

    }];
}

- (void)onTapButton:(id)sender
{
    PaymentViewController* vc = [PaymentViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        OrderCustomerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderCustomerViewCellID forIndexPath:indexPath];
        if (self.address) {
            cell.address = self.address;
        }
        gridcell = cell;
        
    }else if (indexPath.section == 1) {
        GoodsCashViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCashViewCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    else if (indexPath.section == 2) {
        OrderCouponViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderCouponViewCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    else if (indexPath.section == 3) {
        OrderBillViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderBillViewCellID forIndexPath:indexPath];
        typeof(self) __weak wself = self;
        cell.gotoOrderBillPage = ^{
            OrderBillViewController* vc = [OrderBillViewController new];
            [wself.navigationController pushViewController:vc animated:YES];
        };
        gridcell = cell;
    }
    return gridcell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.item == 0) {
        AddressViewController* vc = [AddressViewController new];
        vc.selectedAddress = ^(AddressModel* address){
            self.address = address;
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.item == 0) {
        GoodsCouponController* vc = [GoodsCouponController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 3 && indexPath.item == 0) {
        OrderBillViewController* vc = [OrderBillViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){

        if (indexPath.section == 1){
            OrderGoodsInfoHead *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OrderGoodsInfoHeadID forIndexPath:indexPath];
            typeof(self) __weak wself = self;
            headerView.gotoGoodsList = ^{
                GoodsListingViewController* vc = [GoodsListingViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            };
            reusableview = headerView;
        }
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            GoodsArrivedTimeFoot *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:GoodsArrivedTimeFootID forIndexPath:indexPath];
            reusableview = footview;
        }else{
            BlankCollectionFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID forIndexPath:indexPath];
            reusableview = footview;
        }
    }
    
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(ScreenW , 93);
    }
    if (indexPath.section == 1 ) {
        return CGSizeMake(ScreenW, 128);
    }
    if (indexPath.section == 2 || indexPath.section == 3 ) {
        return CGSizeMake(ScreenW, 45);
    }
//    if (indexPath.section == 4) {
//        return CGSizeMake(ScreenW, 90);
//    }
    return CGSizeZero;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    if (section == 1 ) {
        return CGSizeMake(ScreenW, 111);
    }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenW, 55);
    }
    else if (section == 1 || section == 2 || section == 3)
    {
        return CGSizeMake(ScreenW, 10);
    }
    return CGSizeZero;
}


#pragma mark-
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[GoodsCashViewCell class] forCellWithReuseIdentifier:GoodsCashViewCellID];
        [_collectionView registerClass:[OrderCouponViewCell class] forCellWithReuseIdentifier:OrderCouponViewCellID];
        [_collectionView registerClass:[OrderBillViewCell class] forCellWithReuseIdentifier:OrderBillViewCellID];
        [_collectionView registerClass:[OrderCustomerViewCell class] forCellWithReuseIdentifier:OrderCustomerViewCellID];

        [_collectionView registerClass:[OrderGoodsInfoHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OrderGoodsInfoHeadID];
        
        [_collectionView registerClass:[BlankCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID];
        [_collectionView registerClass:[GoodsArrivedTimeFoot class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:GoodsArrivedTimeFootID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)setupBottom
{
    UIView* bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"实付款：";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0];
        [bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(17);
            make.top.equalTo(16);
        }];
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"¥800.80";
        _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        _moneyLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [bottomView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label.right).offset(5);
            make.centerY.equalTo(label);
        }];
        
        UIButton* btn = [UIButton new];
        btn.backgroundColor = Color00A862;
        [btn setTitle:@"提交订单" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomView addSubview:btn];
        [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.bottom.right.equalTo(bottomView);
            make.width.equalTo(118);
        }];
    }
}
@end
