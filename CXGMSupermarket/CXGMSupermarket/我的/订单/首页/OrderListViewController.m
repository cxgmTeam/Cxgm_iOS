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
        self.pageNum = 1;
        [self.listArray removeAllObjects];
        [wself getOrderList];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNum ++;
        [wself getOrderList];
    }];

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
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
        
        [self.collectionView.mj_header endRefreshing];
    } failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
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
    cell.tapBuyButton = ^{
//        0待支付，1待配送（已支付），2配送中，3已完成，4退货
        if ([item.status intValue] == 3) {
            
        }
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


@end
