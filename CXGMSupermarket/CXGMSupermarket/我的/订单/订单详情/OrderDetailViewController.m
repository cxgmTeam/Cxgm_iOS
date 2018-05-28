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
//head
#import "OrderStateHeadView.h"
#import "ShopAddressHeadView.h"
//foot
#import "GoodsArrivedTimeFoot.h"
#import "BlankCollectionFootView.h"


@interface OrderDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@end


/* cell */
static NSString *const OrderCustomerViewCellID = @"OrderCustomerViewCell";
static NSString *const OrderGoodsViewCellID = @"OrderGoodsViewCell";
static NSString *const OrderInvoiceViewCellID = @"OrderInvoiceViewCell";
static NSString *const OrderAmountViewCellID = @"OrderAmountViewCell";
/* head */
static NSString *const OrderStateHeadViewID = @"OrderStateHeadView";
static NSString *const ShopAddressHeadViewID = @"ShopAddressHeadView";
/* foot */
static NSString *const GoodsArrivedTimeFootID = @"GoodsArrivedTimeFoot";
static NSString *const BlankCollectionFootViewID = @"BlankCollectionFootView";

@implementation OrderDetailViewController

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
        
        [_collectionView registerClass:[OrderStateHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OrderStateHeadViewID];
        [_collectionView registerClass:[ShopAddressHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShopAddressHeadViewID];
        
        [_collectionView registerClass:[GoodsArrivedTimeFoot class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:GoodsArrivedTimeFootID];
        [_collectionView registerClass:[BlankCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    if ([self.orderItem.status intValue] == 0) {
        UIView* bottomView = [UIView new];
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.left.right.equalTo(self.view);
            make.height.equalTo(50);
        }];
        {
            UIButton* cancelBtn = [UIButton new];
            cancelBtn.backgroundColor = [UIColor whiteColor];
            [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            [bottomView addSubview:cancelBtn];
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.top.bottom.equalTo(bottomView);
                make.width.equalTo(ScreenW/2.f);
            }];
            
            UIButton* payBtn = [UIButton new];
            payBtn.backgroundColor = Color00A862;
            [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            payBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            [bottomView addSubview:payBtn];
            [payBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.right.top.bottom.equalTo(bottomView);
                make.width.equalTo(ScreenW/2.f);
            }];
        }
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(bottomView.top);
        }];
    }
    else
    {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
    }
}

#pragma mark-
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2 || section == 3) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        OrderCustomerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderCustomerViewCellID forIndexPath:indexPath];
        gridcell = cell;
        
    }else if (indexPath.section == 1) {
        OrderGoodsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderGoodsViewCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    else if (indexPath.section == 2) {
        OrderInvoiceViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderInvoiceViewCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    else if (indexPath.section == 3) {
        OrderAmountViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderAmountViewCellID forIndexPath:indexPath];
        gridcell = cell;
        
    }
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            OrderStateHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OrderStateHeadViewID forIndexPath:indexPath];
            headerView.orderItem = self.orderItem;
            reusableview = headerView;
        }else if (indexPath.section == 1){
            ShopAddressHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShopAddressHeadViewID forIndexPath:indexPath];
            reusableview = headerView;
        }
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            GoodsArrivedTimeFoot *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:GoodsArrivedTimeFootID forIndexPath:indexPath];
            reusableview = footview;
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
        return CGSizeMake(ScreenW , 93);
    }
    if (indexPath.section == 1 ) {
        return CGSizeMake(ScreenW, 109);
    }
    if (indexPath.section == 2 ) {
        return CGSizeMake(ScreenW, 154);
    }
    if (indexPath.section == 3 ) {
        return CGSizeMake(ScreenW, 174);
    }
    return CGSizeZero;
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
        return CGSizeMake(ScreenW, 55);
    }
    return CGSizeMake(ScreenW, 10);
}

@end
