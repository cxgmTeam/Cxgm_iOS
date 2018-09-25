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
#import "NoteInfoViewCell.h"
#import "ShippingModeCell.h"
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


#import "PaymentViewController.h"
#import "SelectTimeController.h"

@interface OrderConfirmViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)UILabel *moneyLabel;

@property (strong , nonatomic)AddressModel* address;
@property (strong , nonatomic)CouponsModel* coupons;

@property (strong , nonatomic)NSArray* couponArray;

@property (strong , nonatomic)NSMutableDictionary* orderParam;

@property (strong , nonatomic)NSDictionary* receiptDic;

@property (strong , nonatomic)GoodsArrivedTimeFoot *timeFootview;

@property (assign , nonatomic)NSInteger orderNum;

@property(strong, nonatomic) NSMutableArray * pointsArr;//查询到的范围点集

@property(strong , nonatomic)UITextField *textField;

@property(strong , nonatomic)UIView* bottomView;

@property(strong , nonatomic)UIButton* submitBtn;

@property (strong,  nonatomic)NSMutableArray * timeArray;
@property (strong , nonatomic)NSString* dateString;
@property (assign , nonatomic)BOOL isToday;

@property(strong , nonatomic)PostageItem * postage;
@property(strong , nonatomic)NSString * shippingMode;//配送方式
@property(assign , nonatomic)NSString * shippingCharge;//运费
@end

/* cell */
static NSString *const GoodsCashViewCellID = @"GoodsCashViewCell";
static NSString *const OrderCouponViewCellID = @"OrderCouponViewCell";
static NSString *const OrderBillViewCellID = @"OrderBillViewCell";
static NSString *const ShippingModeCellID = @"ShippingModeCell";
static NSString *const OrderCustomerViewCellID = @"OrderCustomerViewCell";
static NSString *const NoteInfoViewCellID = @"NoteInfoViewCell";
/* head */
static NSString *const OrderGoodsInfoHeadID = @"OrderGoodsInfoHead";
/* foot */
static NSString *const BlankCollectionFootViewID = @"BlankCollectionFootView";
static NSString *const GoodsArrivedTimeFootID = @"GoodsArrivedTimeFoot";

@implementation OrderConfirmViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    self.pointsArr = [NSMutableArray array];
    self.orderParam = [NSMutableDictionary dictionary];
    
    [self setupBottom];
    

    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.top);
    }];
    
    self.shippingMode = @"配送";
    self.shippingCharge = @"0.00";
    
    [self calculateDeliveryTime];
    
    [self findAllPsfw];
    
    if (self.goodsArray.count > 0) {
        [self checkCoupon];
    }

    [self getAddressList];
    
    //根据price计算出来的金额  + 运费
    NSString* orderAmount = [NSString stringWithFormat:@"%.2f",[self.moneyDic[@"orderAmount"] floatValue]+Freight_Charges];
    
    if (self.coupons) {
        orderAmount = [NSString stringWithFormat:@"%.2f",[self.moneyDic[@"orderAmount"] floatValue]+Freight_Charges-[self.coupons.priceExpression floatValue]];
    }
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",orderAmount];
}

//下单接口
- (void)addOrder
{
    if (!self.address) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请添加收货地址"]; return;
    }else{
        if (self.pointsArr.count > 0) {
            CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([self.address.dimension doubleValue],[self.address.longitude doubleValue]);
            BOOL flag = [Utility mutableBoundConrtolAction:self.pointsArr myCoordinate:coords];
            if (!flag) {
                [MBProgressHUD MBProgressHUDWithView:self.view Str:@"送货地址不在当前店铺配送范围内"]; return;
            }
        }
    }
    //    orderAmount 实付金额   totalAmount 订单总金额  priceExpression 订单优惠
    //    orderAmount = totalAmount - priceExpression + 运费
    NSString*  orderAmount = self.moneyDic[@"orderAmount"];
    if (self.coupons) {
        orderAmount = [NSString stringWithFormat:@"%.2f",[orderAmount floatValue]-[self.coupons.priceExpression floatValue]];
    }
    if (self.postage) {
        if ([orderAmount floatValue] >= [self.postage.satisfyMoney floatValue]) {
            self.shippingCharge = @"0.00";
        }else{
            if ([self.shippingMode isEqualToString:@"配送"]) {
                self.shippingCharge = self.postage.reduceMoney;
                orderAmount = [NSString stringWithFormat:@"%.2f",[orderAmount floatValue]+[self.shippingCharge floatValue]];
            }else{
                self.shippingCharge = @"0.00";
            }
        }
    }
    
    [self.orderParam setObject:self.moneyDic[@"totalAmount"] forKey:@"totalAmount"];
    [self.orderParam setObject:self.moneyDic[@"preferential"]forKey:@"preferential"];
    [self.orderParam setObject:orderAmount forKey:@"orderAmount"];
    
    
    [self.orderParam setObject:self.address.id forKey:@"addressId"];
    
    NSString* deliveryTime = [NSString stringWithFormat:@"%@ %@",self.dateString,self.timeFootview.timeLabel.text];
    [self.orderParam setObject:deliveryTime forKey:@"receiveTime"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [self.orderParam setObject:dateString forKey:@"orderTime"];
    
    if (self.receiptDic) {
        [self.orderParam setObject:self.receiptDic forKey:@"receipt"];
    }
    
    
    [self.orderParam setObject:[NSString stringWithFormat:@"%ld",(long)self.orderNum] forKey:@"orderNum"];
    
    if (self.coupons) {
       [self.orderParam setObject:self.coupons.codeId forKey:@"couponCodeId"];
        NSString* string = [NSString stringWithFormat:@"%.2f",[self.moneyDic[@"preferential"] floatValue]+[self.coupons.priceExpression floatValue]] ;
       [self.orderParam setObject:string forKey:@"preferential"];
    }
    
    if ([self.textField.text length] == 0) {
        [self.orderParam setObject:@"无备注信息" forKey:@"remarks"];
    }else{
        [self.orderParam setObject:self.textField.text forKey:@"remarks"];
    }
    
    [self.orderParam setObject:[DeviceHelper sharedInstance].shop.id forKey:@"storeId"];
    //配送方式  自取，配送
    [self.orderParam setObject:self.shippingMode forKey:@"extractionType"];
    //配送费
    [self.orderParam setObject:self.shippingCharge forKey:@"postage"];

    typeof(self) __weak wself = self;
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIAddOrder] token:[UserInfoManager sharedInstance].userInfo.token parameter:self.orderParam success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:AddOrder_Success object:nil];
                
                PaymentViewController* vc = [PaymentViewController new];
                vc.orderAmount = orderAmount;
                vc.orderId = [NSString stringWithFormat:@"%ld",[(NSNumber *)model.data longValue]];
                [wself.navigationController pushViewController:vc animated:YES];
            });
        }else{
            self.submitBtn.enabled = YES;
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"提交订单失败"];
        }
    } failure:^(id JSON, NSError *error){
        self.submitBtn.enabled = YES;
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"提交订单失败"];
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
    for (GoodsModel *model in self.goodsArray)
    {
        BOOL flag = NO;
        for (NSString * category in categoryArray) {
            if ([model.categoryId isEqualToString:category]) {
                flag = YES;
                break;
            }
        }
        if (!flag) {
            [categoryArray addObject:model.categoryId.length>0?model.categoryId:@"0"];
        }
    }
    
    self.orderNum = categoryArray.count;
    
    NSMutableArray* array1 = [NSMutableArray array];
    for (NSString * category in categoryArray)
    {
        CGFloat amount = 0;
        
        for (GoodsModel *model in self.goodsArray)
        {
            if ([model.categoryId isEqualToString:category])
            {
                amount = amount + [model.amount floatValue];
            }
        }
        
        NSDictionary* dic = @{
                              @"categoryId":category,
                              @"amount":[NSString stringWithFormat:@"%.2f",amount]
                              };
        [array1 addObject:dic];
    }
    
    
    NSMutableArray* array2 = [NSMutableArray array];
    for (GoodsModel *model in self.goodsArray) {
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
                            @"productList":array2,
                            @"orderAmount":[NSString stringWithFormat:@"%.2f",[self.moneyDic[@"orderAmount"] floatValue]+Freight_Charges],
                            @"storeId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""
                            };
    
    //为提交订单做准备
    [self.orderParam setObject:array1 forKey:@"categoryAndAmountList"];
    [self.orderParam setObject:array2 forKey:@"productList"];
    
    
    typeof(self) __weak wself = self;
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APICheckCoupon] token:[UserInfoManager sharedInstance].userInfo.token parameter:param success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];

        if ([model.data isKindOfClass:[NSArray class]])
        {
            self.couponArray = [CouponsModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            
            if (self.couponArray.count > 0)
            {
                self.coupons = [self.couponArray firstObject];
            }else{
                self.coupons = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.coupons) {
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]]];
                }

                [wself getPostage];
            
            });
        }
        
    } failure:^(id JSON, NSError *error){

    }];
}

- (void)getPostage
{
    NSDictionary* dic = @{
                @"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""
                };
    
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APIOrderPostage] token:userInfo.token parameters:dic success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSDictionary class]]) {
            self.postage = [[PostageItem alloc] initWithDictionary:(NSDictionary *)model.data error:nil];
        }
        
        [wself calculateOrderAmount];
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)calculateOrderAmount
{
    NSString*  orderAmount = self.moneyDic[@"orderAmount"];
    if (self.coupons) {
        orderAmount = [NSString stringWithFormat:@"%.2f",[orderAmount floatValue]-[self.coupons.priceExpression floatValue]];
    }
    if (self.postage) {
        if ([orderAmount floatValue] >= [self.postage.satisfyMoney floatValue]) {
            self.shippingCharge = @"0.00";
        }else{
            if ([self.shippingMode isEqualToString:@"配送"]) {
                self.shippingCharge = self.postage.reduceMoney;
                orderAmount = [NSString stringWithFormat:@"%.2f",[orderAmount floatValue]+[self.shippingCharge floatValue]];
            }else{
                self.shippingCharge = @"0.00";
            }
        }
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",orderAmount];
    
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]]];
}

- (void)onTapButton:(id)sender
{
    self.submitBtn.enabled = NO;
    [self addOrder];
}

#pragma mark-
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
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
        ShippingModeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShippingModeCellID forIndexPath:indexPath];
        typeof(self) __weak wself = self;
        cell.selectShippingMode = ^(NSString * mode){
            self.shippingMode = mode;
            [wself calculateOrderAmount];
        };
        gridcell = cell;
    }else if (indexPath.section == 2) {
        GoodsCashViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCashViewCellID forIndexPath:indexPath];
        cell.totalAmountLabel.text = [NSString stringWithFormat:@"¥%@",self.moneyDic[@"totalAmount"]];
        cell.preferentialLabel.text = [NSString stringWithFormat:@"¥%@",self.moneyDic[@"preferential"]];
        cell.couponsLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.shippingCharge floatValue]];
        gridcell = cell;
    }
    else if (indexPath.section == 3) {
        OrderCouponViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderCouponViewCellID forIndexPath:indexPath];
        cell.coupons = self.coupons;
        gridcell = cell;
    }
//    else if (indexPath.section == 3) {
//        OrderBillViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderBillViewCellID forIndexPath:indexPath];
//        gridcell = cell;
//    }
    else if (indexPath.section == 4) {
        NoteInfoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteInfoViewCellID forIndexPath:indexPath];
        cell.textField.delegate = self;
        self.textField = cell.textField;
        gridcell = cell;
    }
    return gridcell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.item == 0) {
        AddressViewController* vc = [AddressViewController new];
        vc.chooseAddress = YES;
        vc.pointsArr = self.pointsArr;
        vc.selectedAddress = ^(AddressModel* address){
            self.address = address;
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 3 && indexPath.item == 0 && self.couponArray.count > 0) {
        GoodsCouponController* vc = [GoodsCouponController new];
        vc.listArray = self.couponArray;
        typeof(self) __weak wself = self;
        vc.selectCoupon = ^(CouponsModel * model){
            self.coupons = model;

            [wself calculateOrderAmount];
            
            [wself.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]]];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
//    if (indexPath.section == 3 && indexPath.item == 0) {
//        OrderBillViewController* vc = [OrderBillViewController new];
//        vc.writeReceiptFinish = ^(ReceiptItem * receipt){
//
//            self.receiptDic = @{
//                                @"companyName": receipt.companyName.length>0?receipt.companyName:@"不知道",
//                                @"content": @"不知道是啥",
//                                @"createTime": receipt.createTime,
//                                @"dutyParagraph": receipt.dutyParagraph.length>0?receipt.dutyParagraph:@"111122222",
//                                @"phone": receipt.phone,
//                                @"type": receipt.type,
//                                @"userId": receipt.userId
//                                };
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){

        if (indexPath.section == 2){
            OrderGoodsInfoHead *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OrderGoodsInfoHeadID forIndexPath:indexPath];
            headerView.goodsArray = self.goodsArray;
            typeof(self) __weak wself = self;
            headerView.gotoGoodsList = ^{
                GoodsListingViewController* vc = [GoodsListingViewController new];
                vc.goodsArray = self.goodsArray;
                [wself.navigationController pushViewController:vc animated:YES];
            };
            reusableview = headerView;
        }
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            GoodsArrivedTimeFoot *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:GoodsArrivedTimeFootID forIndexPath:indexPath];
            if (self.timeArray.count > 0) {
                footview.timeLabel.text = [self.timeArray firstObject];
            }
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
    if (indexPath.section == 2 ) {
        return CGSizeMake(ScreenW, 128);
    }
//    if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4) {
//        return CGSizeMake(ScreenW, 45);
//    }
    if (indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4) {
        return CGSizeMake(ScreenW, 45);
    }

    return CGSizeZero;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    if (section == 2 ) {
        return CGSizeMake(ScreenW, 111);
    }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenW, 55);
    }
    else if (section == 1 || section == 2 || section == 3 || section == 4 )
    {
        return CGSizeMake(ScreenW, 10);
    }
    return CGSizeZero;
}

#pragma mark-

- (void)calculateDeliveryTime
{
    self.timeArray = [NSMutableArray array];
    
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    
    NSInteger hour = [currentComps hour];
    
    if (0 <= hour && hour < 9 ) {//今天
        
        self.isToday = YES;
        self.dateString = [NSString stringWithFormat:@"%zd年%zd月%zd日",[currentComps year],[currentComps month],[currentComps day]];
        
        NSInteger duration = 21-8;
        
        for (NSInteger i = 1; i < duration; i ++) {
            
            NSString *string = [NSString stringWithFormat:@"%ld:00-%ld:00",8+i,8+i+1];
            [self.timeArray addObject:string];
        }
    }
    
    if (9 <= hour  && hour < 20) {//今天
        self.isToday = YES;
        self.dateString = [NSString stringWithFormat:@"%zd年%zd月%zd日",[currentComps year],[currentComps month],[currentComps day]];
        
        NSInteger duration = 21-hour;
        
        for (NSInteger i = 1; i < duration; i ++) {
            
            NSString *string = [NSString stringWithFormat:@"%ld:00-%ld:00",hour+i,hour+i+1];
            [self.timeArray addObject:string];
        }
    }
    
    if (20 <= hour  && hour < 24) {//明天
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = nil;
        comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        
        [adcomps setDay:1];
        
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
        currentComps = [calendar components:unitFlags fromDate:newdate];
        
        self.isToday = NO;
        self.dateString = [NSString stringWithFormat:@"%zd年%zd月%zd日",[currentComps year],[currentComps month],[currentComps day]];
        
        
        NSInteger duration = 21-8;
        
        for (NSInteger i = 1; i < duration; i ++) {
            
            NSString *string = [NSString stringWithFormat:@"%ld:00-%ld:00",8+i,8+i+1];
            [self.timeArray addObject:string];
        }
    }
    
    if (self.timeArray.count > 0) {
        self.timeFootview.timeLabel.text = [self.timeArray firstObject];
    }
}


- (void)selectTime:(UITapGestureRecognizer *)gesture
{
    SelectTimeController* vc = [SelectTimeController new];
    
    vc.isToday = self.isToday;
    vc.dataArray = self.timeArray;
    
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
        [_collectionView registerClass:[NoteInfoViewCell class] forCellWithReuseIdentifier:NoteInfoViewCellID];
        [_collectionView registerClass:[ShippingModeCell class] forCellWithReuseIdentifier:ShippingModeCellID];

        [_collectionView registerClass:[OrderGoodsInfoHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OrderGoodsInfoHeadID];
        
        [_collectionView registerClass:[BlankCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID];
        [_collectionView registerClass:[GoodsArrivedTimeFoot class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:GoodsArrivedTimeFootID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)setupBottom
{
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(TAB_BAR_HEIGHT);
    }];
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"实付款：";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0];
        [_bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(17);
            make.top.equalTo(16);
        }];
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"¥800.80";
        _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        _moneyLabel.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [_bottomView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label.right).offset(5);
            make.centerY.equalTo(label);
        }];
        
        UIButton* btn = [UIButton new];
        btn.backgroundColor = Color00A862;
        [btn setTitle:@"提交订单" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomView addSubview:btn];
        [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.right.equalTo(self.bottomView);
            make.height.equalTo(49);
            make.width.equalTo(118);
        }];
        self.submitBtn = btn;
    }
}

#pragma mark-  选择送货地址时需要判断是否在所选店铺的范围内
- (void)findAllPsfw
{
    NSDictionary* dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""};
    
//    NSDictionary* dic = @{@"shopId":@""};
    
    [self.pointsArr removeAllObjects];
    
    [AFNetAPIClient GET:[LoginBaseURL stringByAppendingString:APIFindAllPsfw] token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        
        if ([model.data isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary* dic in (NSArray *)model.data)
            {
                NSString* psfw = dic[@"psfw"];
                NSArray* array = [psfw componentsSeparatedByString:@","];
                
                NSInteger pointNodeNum = array.count;
                NSMutableArray* mutableArr = [NSMutableArray array];
                
                for (NSInteger i = 0;i < pointNodeNum  ;i++)
                {
                    NSString* string = array[i];
                    NSArray* arr = [string componentsSeparatedByString:@"_"];
                    
                    if (arr.count>1) {
                        
                        CLLocation *location = [[CLLocation alloc] initWithLatitude:[arr[1] floatValue] longitude:[arr[0] floatValue]];
                        [mutableArr addObject:location];
                    }

                    if (i == pointNodeNum-1)
                    {
                        CLLocationCoordinate2D commuterLotCoords[pointNodeNum];
                        
                        for(int j = 0; j < [mutableArr count]; j++) {
                            commuterLotCoords[j] = [[mutableArr objectAtIndex:j] coordinate];
                        }
                    }
                }
                //保存点数组
                [self.pointsArr addObject:mutableArr];
                
            }
        }
    } failure:^(id JSON, NSError *error){
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
