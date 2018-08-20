//
//  OrderListViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderCollectionViewCell.h"
#import "OrderDetailViewController.h"

#import "PaymentViewController.h"
#import "OrderConfirmViewController.h"

@interface OrderListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)NSMutableArray *listArray;
@property (assign , nonatomic)NSInteger pageNum;

@end

static NSString *const OrderCollectionViewCellID = @"OrderCollectionViewCell";

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = 1;
    self.listArray = [NSMutableArray array];


    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    typeof(self) __weak wself = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.collectionView.mj_header endRefreshing];
        
        self.pageNum = 1;
        [self.listArray removeAllObjects];
        [wself getOrderList];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.collectionView.mj_footer endRefreshing];
        
        self.pageNum ++;
        [wself getOrderList];
    }];

    [self getOrderList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reGetOrderList:) name:CancelOrder_Success object:nil];
}

- (void)reGetOrderList:(NSNotification *)notify
{
    self.pageNum = 1;
    [self.listArray removeAllObjects];
    [self getOrderList];
}

- (void)getOrderList
{
    NSDictionary* dic = @{@"status":self.status==-1?@"":[NSString stringWithFormat:@"%ld",self.status],
                          @"pageNum":[NSString stringWithFormat:@"%ld",(long)self.pageNum],
                          @"pageSize":@"10"
                          };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APIOrderList] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            for (NSDictionary* dic in (NSArray *)model.listModel.list) {
                OrderModel* order = [OrderModel OrderModelWithJson:dic];
                [self.listArray addObject:order];
            }
            [self.collectionView reloadData];
        }
        if ([model.listModel.isLastPage boolValue]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.collectionView.mj_header endRefreshing];
    } failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

//申请退款
- (void)returnMoney:(NSString *)orderId
{
    NSDictionary* dic = @{@"orderId":orderId};
    
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIReturnMoney] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        
    } failure:^(id JSON, NSError *error){
        
    }];
}


#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderCollectionViewCellID forIndexPath:indexPath];
    OrderModel* item = self.listArray[indexPath.item];
    cell.orderItem = item;
    
    typeof(self) __weak wself = self;
    cell.tapBuyButton = ^{
//        0待支付，1待配送（已支付），4配送中，5已完成，7退货
        
        switch ([item.status intValue]) {
            case STATUS_TO_BE_PAID://去支付
            {
                PaymentViewController* vc = [PaymentViewController new];
                vc.order = item;
                [wself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case STATUS_TO_BE_SORT://申请退款
            case STATUS_BE_SORTING:
            case STATUS_DISTRIBUTION:
            case STATUS_DISTRIBUTING:
            {
                [wself returnMoney:item.id];
            }
                break;
            case STATUS_COMPLETE://再次购买
            case STATUS_TIMEOUT_CANCEL:
            case STATUS_SYSTEM_CANCEL:
            case STATUS_USER_CANCEL:
            {
                
                double totlePrice = 0.0;
                
                double originalTotal = 0.0;
                
                double preferential = 0.0;
            
                for (NSInteger i = 0; i < item.productDetails.count; i++ )
                {
                    GoodsModel* goods = item.productDetails[i];
                    
                    goods.goodCode = goods.productCode;
                    
                    double price = [goods.price doubleValue];
                    
                    totlePrice += price*[goods.productNum intValue];
                    
                    double original = [goods.originalPrice doubleValue];
                    
                    if (original > 0 && original > price) {
                        
                        originalTotal += original*[goods.productNum intValue];
                        
                        preferential += originalTotal - totlePrice;
                    }else{
                        
                        originalTotal += price*[goods.productNum intValue];
                    }
                    
                    if (i == item.productDetails.count-1)
                    {
                        //    orderAmount 实付金额   totalAmount 订单总金额  preferential 订单优惠
                        NSDictionary* dic = @{
                                              @"totalAmount":[NSString stringWithFormat:@"%.2f",originalTotal],
                                              @"preferential":[NSString stringWithFormat:@"%.2f",originalTotal-totlePrice],
                                              @"orderAmount":[NSString stringWithFormat:@"%.2f",totlePrice]
                                              };
                        
                        OrderConfirmViewController* vc = [OrderConfirmViewController new];
                        vc.moneyDic = dic;
                        vc.goodsArray = item.productDetails;
                        
                        [wself.navigationController pushViewController:vc animated:YES];
                    }
                }
            
            }
                break;
            default:
                break;
        }
    };
    
    cell.showOrderDetail = ^{
        OrderDetailViewController* vc = [OrderDetailViewController new];
        OrderModel* orderItem = wself.listArray[indexPath.item];
        vc.orderItem = orderItem;
        [wself.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel* item = self.listArray[indexPath.item];
    if ([item.status intValue] == 4) {
        return CGSizeMake(ScreenW, 12+100+(ScreenW-60)/4.f);
    }
    return CGSizeMake(ScreenW, 12+145+(ScreenW-60)/4.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    OrderDetailViewController* vc = [OrderDetailViewController new];
    OrderModel* orderItem = self.listArray[indexPath.item];
    vc.orderItem = orderItem;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-
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
        [_collectionView registerClass:[OrderCollectionViewCell class] forCellWithReuseIdentifier:OrderCollectionViewCellID];
        [self.view addSubview:_collectionView];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        
    }
    return _collectionView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
