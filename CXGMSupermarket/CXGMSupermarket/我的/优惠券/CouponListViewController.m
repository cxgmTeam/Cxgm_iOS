//
//  CouponListViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponCollectionViewCell.h"
#import "CouponItem.h"

@interface CouponListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)UIView *emptyView;
@property (strong , nonatomic)NSMutableArray *listArray;

@property (assign , nonatomic)NSInteger pageNum;

@end

static NSString *const CouponCollectionViewCellID = @"CouponCollectionViewCell";


@implementation CouponListViewController



- (void)findCoupons{
    NSDictionary* dic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)self.pageNum],
                          @"pageSize":@"10"};
    
    WEAKSELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindCoupons] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            NSArray* array = [CouponsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            [weakSelf.listArray addObjectsFromArray:array];
            [weakSelf.collectionView reloadData];
            
            weakSelf.emptyView.hidden = weakSelf.listArray.count>0? YES:NO;
            
            if (array.count == 0) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
        }else{
             [weakSelf.collectionView.mj_footer endRefreshing];
        }
        
        [weakSelf.collectionView.mj_header endRefreshing];
       
    } failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCouponEmptyView];
    
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    WEAKSELF
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf.listArray removeAllObjects];
        [weakSelf findCoupons];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNum ++;
        [weakSelf findCoupons];
    }];
    
    self.pageNum = 1;
    [self findCoupons];
}

- (void)setupCouponEmptyView{
    if (!_emptyView) {
        _emptyView = [UIView new];
        [self.view addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_empty"]];
        [_emptyView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.emptyView);
            make.top.equalTo(50);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        if (self.isExpire) {
            label.text = @"目前没有过期优惠券";
        }else{
            label.text = @"目前没有可用优惠券";
        }
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [_emptyView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.emptyView);
            make.top.equalTo(imageView.bottom).offset(11);
        }];
    }
}

#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CouponCollectionViewCellID forIndexPath:indexPath];
    CouponsModel* item = self.listArray[indexPath.item];
    item.isExpire = item.status;
    cell.coupons = item;
    cell.expandClick = ^{
        item.isOpen = [NSString stringWithFormat:@"%d",![item.isOpen boolValue]];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponItem* item = self.listArray[indexPath.item];
    if (item.isOpen) {
        return CGSizeMake(ScreenW-20, 140);
    }else{
        return CGSizeMake(ScreenW-20, 100);
    }
}

#pragma mark- init
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
        [_collectionView registerClass:[CouponCollectionViewCell class] forCellWithReuseIdentifier:CouponCollectionViewCellID];
        [self.view addSubview:_collectionView];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return _collectionView;
}

@end
