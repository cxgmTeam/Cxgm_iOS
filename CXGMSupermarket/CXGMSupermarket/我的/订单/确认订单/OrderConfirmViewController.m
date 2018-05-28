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


#import "OrderBillViewController.h"

#import "PaymentViewController.h"
#import "SelectTimeController.h"

@interface OrderConfirmViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)UILabel *moneyLabel;

@property (strong , nonatomic)AddressModel* address;
@property (strong , nonatomic)CouponsModel* coupons;

@property (strong , nonatomic)NSArray* couponArray;

@property (strong , nonatomic)NSMutableDictionary* orderParam;

@property (strong , nonatomic)NSDictionary* receiptDic;

@property (strong , nonatomic)GoodsArrivedTimeFoot *timeFootview;

@property (assign , nonatomic)CGFloat orderAmount;
@property (assign , nonatomic)NSInteger orderNum;
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
    
    self.orderParam = [NSMutableDictionary dictionary];
    
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
- (void)addOrder
{
    if (!self.address) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请添加收获地址"]; return;
    }
    
    [self.orderParam setObject:self.address.id forKey:@"addressId"];
    [self.orderParam setObject:self.timeFootview.timeLabel.text forKey:@"receiveTime"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [self.orderParam setObject:dateString forKey:@"orderTime"];
    
    if (self.receiptDic) {
        [self.orderParam setObject:self.receiptDic forKey:@"receipt"];
    }
    
    [self.orderParam setObject:[NSString stringWithFormat:@"%.2f",self.orderAmount] forKey:@"orderAmount"];
    [self.orderParam setObject:[NSString stringWithFormat:@"%ld",(long)self.orderNum] forKey:@"orderNum"];
    
    if (self.coupons) {
       [self.orderParam setObject:self.coupons.codeId forKey:@"couponCodeId"];
    }
    [self.orderParam setObject:@"没有" forKey:@"remarks"];
    [self.orderParam setObject:[DeviceHelper sharedInstance].shop.id forKey:@"storeId"];
    
    
    typeof(self) __weak wself = self;
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIAddOrder] token:[UserInfoManager sharedInstance].userInfo.token parameter:self.orderParam success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:AddOrder_Success object:nil];
                
                PaymentViewController* vc = [PaymentViewController new];
                [wself.navigationController pushViewController:vc animated:YES];

            });
        }
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
            }else{
                self.address = nil;
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
            }
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

//请求优惠券
- (void)checkCoupon
{
    
    [self.orderParam removeAllObjects];
    
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
    
    self.orderNum = categoryArray.count;
    
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
        
        self.orderAmount = self.orderAmount + amount;
        
        NSDictionary* dic = @{
                              @"categoryId":category,
                              @"amount":[NSString stringWithFormat:@"%.2f",amount]
                              };
        [array1 addObject:dic];
    }
    
    
    NSMutableArray* array2 = [NSMutableArray array];
    for (LZCartModel *model in self.goodsArray) {
        NSDictionary* dic = @{
                              @"goodCode": model.goodCode.length>0?model.goodCode:@"",
                              @"id": model.id.length>0?model.id:@"",
                              @"productId": model.productId.length>0?model.productId:@"",
                              @"productName": model.goodName.length>0?model.goodName:@"",
                              @"productNum": model.goodNum.length>0?model.goodNum:@"1"
                              };
        [array2 addObject:dic];
    }
    
    NSDictionary* param = @{@"categoryAndAmountList":array1,
                            @"productList":array2};
    
    //为提交订单做准备
    [self.orderParam setObject:array1 forKey:@"categoryAndAmountList"];
    [self.orderParam setObject:array2 forKey:@"productList"];
    
    
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APICheckCoupon] token:[UserInfoManager sharedInstance].userInfo.token parameter:param success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            self.couponArray = [CouponsModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            if (self.couponArray.count > 0) {
                self.coupons = [self.couponArray firstObject];
            }else{
                self.coupons = nil;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]]];
            });
        }

    } failure:^(id JSON, NSError *error){

    }];
}

- (void)onTapButton:(id)sender
{
    [self addOrder];
    
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
        cell.address = self.address;
        gridcell = cell;
        
    }else if (indexPath.section == 1) {
        GoodsCashViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCashViewCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    else if (indexPath.section == 2) {
        OrderCouponViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderCouponViewCellID forIndexPath:indexPath];
        cell.coupons = self.coupons;
        gridcell = cell;
    }
    else if (indexPath.section == 3) {
        OrderBillViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderBillViewCellID forIndexPath:indexPath];
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
    
    if (indexPath.section == 2 && indexPath.item == 0 && self.couponArray.count > 0) {
        GoodsCouponController* vc = [GoodsCouponController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 3 && indexPath.item == 0) {
        OrderBillViewController* vc = [OrderBillViewController new];
        vc.writeReceiptFinish = ^(ReceiptItem * receipt){
            
            self.receiptDic = @{
                                @"companyName": receipt.companyName.length>0?receipt.companyName:@"不知道",
                                @"content": @"不知道是啥",
                                @"createTime": receipt.createTime,
                                @"dutyParagraph": receipt.dutyParagraph.length>0?receipt.dutyParagraph:@"111122222",
                                @"phone": receipt.phone,
                                @"type": receipt.type,
                                @"userId": receipt.userId
                                };
        };
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
            [footview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTime:)]];
            reusableview = footview;
            _timeFootview = footview;
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
- (void)selectTime:(UITapGestureRecognizer *)gesture
{
    SelectTimeController* vc = [SelectTimeController new];
    vc.selectedTimeFinish = ^(NSString * time){
        self.timeFootview.timeLabel.text = time;
    };
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller presentViewController:vc animated:YES completion:nil];
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
