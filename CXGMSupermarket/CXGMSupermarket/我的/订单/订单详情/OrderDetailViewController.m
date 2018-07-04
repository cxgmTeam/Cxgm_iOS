//
//  OrderDetailViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderDetailViewController.h"
//cell
#import "OrderCustomerViewCell.h"
#import "OrderGoodsViewCell.h"
#import "OrderInvoiceViewCell.h"
#import "OrderAmountViewCell.h"
#import "RefundAmountViewCell.h"
#import "NoteInfoViewCell.h"
//head
#import "OrderStateHeadView.h"
#import "ShopAddressHeadView.h"
//foot
#import "GoodsArrivedTimeFoot.h"
#import "BlankCollectionFootView.h"

#import "PaymentViewController.h"

#import "GoodsDetailViewController.h"

@interface OrderDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)OrderModel *orderDetail;

@property (strong , nonatomic)OrderStateHeadView *stateHeader;

@property(nonatomic,assign)NSInteger surplusTime;
@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,strong)UIView* bottomView;
@end


/* cell */
static NSString *const OrderCustomerViewCellID = @"OrderCustomerViewCell";
static NSString *const OrderGoodsViewCellID = @"OrderGoodsViewCell";
static NSString *const OrderInvoiceViewCellID = @"OrderInvoiceViewCell";
static NSString *const OrderAmountViewCellID = @"OrderAmountViewCell";
static NSString *const RefundAmountViewCellID = @"RefundAmountViewCell";
static NSString *const NoteInfoViewCellID = @"NoteInfoViewCell";
/* head */
static NSString *const OrderStateHeadViewID = @"OrderStateHeadView";
static NSString *const ShopAddressHeadViewID = @"ShopAddressHeadView";
/* foot */
static NSString *const GoodsArrivedTimeFootID = @"GoodsArrivedTimeFoot";
static NSString *const BlankCollectionFootViewID = @"BlankCollectionFootView";

@implementation OrderDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.top);
    }];
    
    
    if (self.orderItem) {
        self.orderId = self.orderItem.id;
    }
    
    if (self.orderId) {
        [self getOrderDetail];
    }
}


- (void)getOrderDetail
{
    NSDictionary* dic = @{@"orderId":self.orderId};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APIOrderDetail] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSDictionary class]]) {
            self.orderDetail = [OrderModel OrderModelWithJson:(NSDictionary *)model.data];
            if ([self.orderDetail.status intValue] == STATUS_TO_BE_PAID) {
                [wself getSurplusTime];
            }else{
                self.bottomView.hidden = YES;
                [self.collectionView remakeConstraints:^(MASConstraintMaker *make){
                    make.edges.equalTo(self.view);
                }];
            }
            [self.collectionView reloadData];
        }
    } failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}


- (void)getSurplusTime
{
    NSDictionary* dic = @{@"orderId":self.orderDetail.id};
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APISurplusTime] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        
        if ([model.code isEqualToString:@"200"]) {
            self.surplusTime = [(NSNumber *)model.data longValue];
            [wself setupTimer];
        }else{
            self.stateHeader.remainTimeLabel.text = @"已超时";
            
            self.bottomView.hidden = YES;
            [self.collectionView remakeConstraints:^(MASConstraintMaker *make){
                make.edges.equalTo(self.view);
            }];
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)setupTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)onTimer
{
    self.surplusTime = self.surplusTime-1000;
    if (self.surplusTime > 1000) {
        NSString* surplus = [Utility formateDate:self.surplusTime];
        _stateHeader.remainTimeLabel.text = [NSString stringWithFormat:@"支付剩余时间  %@",surplus];
    }else{
        [self stopTimer];
        _stateHeader.remainTimeLabel.text = @"已超时";
        
        self.bottomView.hidden = YES;
        [self.collectionView remakeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)stopTimer
{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark- 点击按钮事件
- (void)cancelOrder:(UIButton *)button
{
    NSDictionary* dic = @{@"orderId":self.orderId};
    
    [AFNetAPIClient POST:[OrderBaseURL stringByAppendingString:APICancelOrder] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){

        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code isEqualToString:@"200"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CancelOrder_Success object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(id JSON, NSError *error){

    }];
    
}

- (void)payOrder:(UIButton *)button
{
    PaymentViewController* vc = [PaymentViewController new];
    vc.order = self.orderDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.orderDetail.productDetails.count;
    }
    if (section == 2 || section == 3 || section == 4) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0)
    {
        if ([self.orderDetail.status intValue] == STATUS_WAIT_REFUND || [self.orderDetail.status intValue] == STATUS_REFUNDED){
            RefundAmountViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RefundAmountViewCellID forIndexPath:indexPath];

            gridcell = cell;
        }else{
            OrderCustomerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderCustomerViewCellID forIndexPath:indexPath];
            cell.address = self.orderDetail.addressObj;
            gridcell = cell;
        }
        
    }else if (indexPath.section == 1) {
        OrderGoodsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderGoodsViewCellID forIndexPath:indexPath];
        cell.goods = self.orderDetail.productDetails[indexPath.item];
        gridcell = cell;
    }
    else if (indexPath.section == 2) {
        OrderInvoiceViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderInvoiceViewCellID forIndexPath:indexPath];
        cell.order = self.orderDetail;
        gridcell = cell;
    }
    else if (indexPath.section == 3) {
        NoteInfoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteInfoViewCellID forIndexPath:indexPath];
        cell.textField.text = self.orderDetail.remarks;
        cell.textField.delegate = self;
        gridcell = cell;
        
    }
    else if (indexPath.section == 4) {
        OrderAmountViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderAmountViewCellID forIndexPath:indexPath];
        cell.order = self.orderDetail;
        gridcell = cell;
        
    }
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            OrderStateHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OrderStateHeadViewID forIndexPath:indexPath];
            headerView.orderItem = self.orderDetail;
            _stateHeader = headerView;
            
            reusableview = headerView;
        }else if (indexPath.section == 1){
            ShopAddressHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShopAddressHeadViewID forIndexPath:indexPath];
            headerView.order = self.orderDetail;
            reusableview = headerView;
        }
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0)
        {
            if ([self.orderDetail.status intValue] == STATUS_WAIT_REFUND || [self.orderDetail.status intValue] == STATUS_REFUNDED){
                BlankCollectionFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID forIndexPath:indexPath];
                reusableview = footview;
            }else{
                GoodsArrivedTimeFoot *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:GoodsArrivedTimeFootID forIndexPath:indexPath];
                footview.timeLabel.text = self.orderDetail.receiveTime;
                reusableview = footview;
            }
        }
        else
        {
            BlankCollectionFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID forIndexPath:indexPath];
            reusableview = footview;
        }
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.orderDetail.status intValue] == STATUS_WAIT_REFUND || [self.orderDetail.status intValue] == STATUS_REFUNDED){
            return CGSizeMake(ScreenW , 45);
        }
        return CGSizeMake(ScreenW , 93);
    }
    if (indexPath.section == 1 ) {
        return CGSizeMake(ScreenW, 109);
    }
    if (indexPath.section == 2 ) {
        return CGSizeMake(ScreenW, 154);
    }
    if (indexPath.section == 3 ) {
        return CGSizeMake(ScreenW, 45);
    }
    if (indexPath.section == 4 ) {
        return CGSizeMake(ScreenW, 174);
    }
    return CGSizeZero;
}

#pragma mark-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(ScreenW, 80);
    }
    if (section == 1 ) {
        return CGSizeMake(ScreenW, 70);
    }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.orderDetail.status intValue] == STATUS_WAIT_REFUND || [self.orderDetail.status intValue] == STATUS_REFUNDED){
            return CGSizeMake(ScreenW, 10);
        }
        return CGSizeMake(ScreenW, 55);
    }
    return CGSizeMake(ScreenW, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1){
        GoodsModel* goods = self.orderDetail.productDetails[indexPath.item];
        
        GoodsDetailViewController* vc = [GoodsDetailViewController new];
        vc.goodsId = goods.productId;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - init
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[OrderCustomerViewCell class] forCellWithReuseIdentifier:OrderCustomerViewCellID];
        [_collectionView registerClass:[OrderGoodsViewCell class] forCellWithReuseIdentifier:OrderGoodsViewCellID];
        [_collectionView registerClass:[OrderInvoiceViewCell class] forCellWithReuseIdentifier:OrderInvoiceViewCellID];
        [_collectionView registerClass:[OrderAmountViewCell class] forCellWithReuseIdentifier:OrderAmountViewCellID];
        [_collectionView registerClass:[NoteInfoViewCell class] forCellWithReuseIdentifier:NoteInfoViewCellID];
        [_collectionView registerClass:[RefundAmountViewCell class] forCellWithReuseIdentifier:RefundAmountViewCellID];
        
        [_collectionView registerClass:[OrderStateHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OrderStateHeadViewID];
        [_collectionView registerClass:[ShopAddressHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShopAddressHeadViewID];
        
        [_collectionView registerClass:[GoodsArrivedTimeFoot class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:GoodsArrivedTimeFootID];
        [_collectionView registerClass:[BlankCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        
        _bottomView = [UIView new];
        [self.view addSubview:_bottomView];
        {
            UIButton* cancelBtn = [UIButton new];
            cancelBtn.backgroundColor = [UIColor whiteColor];
            [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            [_bottomView addSubview:cancelBtn];
            [cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.top.bottom.equalTo(self.bottomView);
                make.width.equalTo(ScreenW/2.f);
            }];
            
            UIButton* payBtn = [UIButton new];
            payBtn.backgroundColor = Color00A862;
            [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            payBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            [self.bottomView addSubview:payBtn];
            [payBtn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
            [payBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.right.top.bottom.equalTo(self.bottomView);
                make.width.equalTo(ScreenW/2.f);
            }];
        }
    }
    return _bottomView;
}

- (void)dealloc{
    [self stopTimer];
}
@end
