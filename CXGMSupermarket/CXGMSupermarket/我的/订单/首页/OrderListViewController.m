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
@end

static NSString *const OrderCollectionViewCellID = @"OrderCollectionViewCell";

@implementation OrderListViewController

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[OrderCollectionViewCell class] forCellWithReuseIdentifier:OrderCollectionViewCellID];
        [self.view addSubview:_collectionView];
        _collectionView.contentInset = UIEdgeInsetsMake(12, 0, 10, 0);
        
    }
    return _collectionView;
}

- (void)initData
{
    OrderItem* item1 = [OrderItem new];
    item1.orderType = ForShipping;
    [self.listArray addObject:item1];
    
    OrderItem* item2 = [OrderItem new];
    item2.orderType = InShipping;
    [self.listArray addObject:item2];
    
    OrderItem* item3 = [OrderItem new];
    item3.orderType = Finished;
    [self.listArray addObject:item3];
    
    OrderItem* item4 = [OrderItem new];
    item4.orderType = TimeoutCancel;
    [self.listArray addObject:item4];
    
    OrderItem* item5 = [OrderItem new];
    item5.orderType = ForPayment;
    [self.listArray addObject:item5];
    
    OrderItem* item6 = [OrderItem new];
    item6.orderType = Returning;
    [self.listArray addObject:item6];
    
    OrderItem* item7 = [OrderItem new];
    item7.orderType = Returned;
    [self.listArray addObject:item7];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listArray = [NSMutableArray array];
    //初始化数据
    [self initData];

    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];

    [self getOrderList];
}

- (void)getOrderList
{
    NSDictionary* dic = @{@"status":self.status==-1?@"":[NSString stringWithFormat:@"%ld",self.status],
                          @"pageNum":@"1",
                          @"pageSize":@"10"
                          };
    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APIOrderList] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

//取消待付款订单


#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderCollectionViewCellID forIndexPath:indexPath];
    OrderItem* item = self.listArray[indexPath.item];
    cell.orderItem = item;
    cell.tapBuyButton = ^{
        if (item.orderType == ForPayment) {
            
        }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderItem* item = self.listArray[indexPath.item];
    switch (item.orderType) {
        case ForShipping:
        case InShipping:
        case Finished:
        case TimeoutCancel:
        case ForPayment:
            return CGSizeMake(ScreenW, 145+(ScreenW-60)/4.f);
            break;
        case Returning:
        case Returned:
            return CGSizeMake(ScreenW, 100+(ScreenW-60)/4.f);
            break;
        default:
            break;
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    OrderDetailViewController* vc = [OrderDetailViewController new];
    vc.orderItem = self.listArray[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
