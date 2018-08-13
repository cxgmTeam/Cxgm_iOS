//
//  CouponListViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponCollectionViewCell.h"

#import "ScanningViewController.h"

@interface CouponListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)UIView *emptyView;
@property (strong , nonatomic)NSMutableArray *listArray;

@property(nonatomic,strong)UIView* exchangeView;
@property(nonatomic,strong)CustomTextField* textField;

@property (assign , nonatomic)NSInteger pageNum;

@end

static NSString *const CouponCollectionViewCellID = @"CouponCollectionViewCell";


@implementation CouponListViewController



- (void)findCoupons{
    NSDictionary* dic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)self.pageNum],
                          @"pageSize":@"10"};
    
    typeof(self) __weak wself = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindCoupons] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        
        [MBProgressHUD hideHUDForView:wself.view animated:YES];
        
        if (self.pageNum == 1) {
            [self.listArray removeAllObjects];
        }
        
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            
            NSArray* array = [CouponsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            for (CouponsModel * model in array) {
                if ([model.status boolValue] == self.isExpire) {
                    [wself.listArray addObject:model];
                }
            }
            [wself.collectionView reloadData];
            
            wself.emptyView.hidden = wself.listArray.count>0? YES:NO;
            
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(restButtonTitle:)]) {
                [wself.delegate performSelector:@selector(restButtonTitle:) withObject:@{@"status":[NSNumber numberWithBool:self.isExpire],
                                                                                         @"number":[NSNumber numberWithInteger:wself.listArray.count]}];
            }
            
            if (array.count == 0) {
                [wself.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
       
    } failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:wself.view animated:YES];

    }];
}

- (void)showScanningView:(UIButton *)button
{
    ScanningViewController* vc = [ScanningViewController new];
    typeof(self) __weak wself = self;
    vc.feedbackScanningResult = ^(NSString *message){
        wself.textField.text = message;
        [wself exchangeCoupons:nil];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)exchangeCoupons:(id)sender
{
    if (_textField.text.length == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入正确的兑换码"]; return;
    }
    
    NSDictionary* dic = @{@"couponCode":_textField.text};
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIExchangeCoupons] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if (!model.data) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"二维码已失效"];
        }else{
            wself.pageNum = 1;
            [wself findCoupons];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.isExpire) {
        [self setupExchangeView];
    }

    self.listArray = [NSMutableArray arrayWithCapacity:0];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        if (!self.isExpire) {
            make.top.equalTo(self.exchangeView.bottom);
        }else{
            make.top.equalTo(0);
        }
        make.left.right.bottom.equalTo(self.view);
    }];
    WEAKSELF
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [weakSelf.collectionView.mj_header endRefreshing];
        
        weakSelf.pageNum = 1;
        [weakSelf findCoupons];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_footer endRefreshing];
        
        weakSelf.pageNum ++;
        [weakSelf findCoupons];
    }];
    
    [self setupCouponEmptyView];
    
    self.pageNum = 1;
    [self findCoupons];
}

- (void)setupExchangeView
{
    _exchangeView = [UIView new];    
    [self.view addSubview:_exchangeView];
    [_exchangeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(50);
        make.top.left.right.equalTo(self.view);
    }];
    
    UIButton* button = [UIButton new];
    button.backgroundColor = Color00A862;
    button.layer.cornerRadius = 4;
    [button setTitle:@"兑换" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_exchangeView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(70, 40));
        make.centerY.equalTo(self.exchangeView);
        make.right.equalTo(-10);
    }];
    [button addTarget:self action:@selector(exchangeCoupons:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * view = [UIView new];
    view.layer.borderColor = [UIColor colorWithHexString:@"D8D8D8"].CGColor;
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 4;
    [_exchangeView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(10);
        make.centerY.equalTo(button);
        make.height.equalTo(40);
        make.right.equalTo(button.left).offset(-10);
    }];
    
    button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"scan_icon"] forState:UIControlStateNormal];
    button.alpha = 0.3;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self.exchangeView);
        make.left.equalTo(0);
    }];
    [button addTarget:self action:@selector(showScanningView:) forControlEvents:UIControlEventTouchUpInside];
    
    _textField = [CustomTextField new];
    _textField.placeholder = @"请输入优惠券兑换码";
    _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _textField.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(40);
        make.top.bottom.right.equalTo(view);
    }];
    
}

- (void)setupCouponEmptyView
{
    if (!_emptyView) {
        _emptyView = [UIView new];
        [self.view addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.collectionView);
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
    typeof(self) __weak wself = self;
    cell.expandClick = ^{
        item.isOpen = [NSString stringWithFormat:@"%d",![item.isOpen boolValue]];
        [wself.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponsModel* item = self.listArray[indexPath.item];
    if ([item.isOpen boolValue]) {
        return CGSizeMake(ScreenW-20, 140+10);
    }else{
        return CGSizeMake(ScreenW-20, 100+10);
    }
}

#pragma mark- init
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
        [_collectionView registerClass:[CouponCollectionViewCell class] forCellWithReuseIdentifier:CouponCollectionViewCellID];
        [self.view addSubview:_collectionView];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return _collectionView;
}

@end
