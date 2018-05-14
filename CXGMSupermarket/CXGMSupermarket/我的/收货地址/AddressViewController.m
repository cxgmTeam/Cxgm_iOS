//
//  AddressViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/24.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCollectionViewCell.h"
#import "AddAddressViewController.h"
#import "LoginViewController.h"
#import "AddressHeadView.h"
#import "AddressTopViewCell.h"
#import "MapViewController.h"

@interface AddressViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)NSArray *addressList;
@end

static NSString *const AddressCollectionViewCellID = @"AddressCollectionViewCell";
static NSString *const AddressTopViewCellID = @"AddressTopViewCell";

static NSString *const AddressHeadViewID = @"AddressHeadView";

@implementation AddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    
    UIButton* addBtn = [UIButton new];
    addBtn.backgroundColor = Color00A862;
    [addBtn setTitle:@"新增收获地址" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];

    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(addBtn.top);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getAddressList];
}

- (void)getAddressList
{
    if (![UserInfoManager sharedInstance].isLogin) return;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    NSDictionary* dic = @{@"userId":userInfo.id};
    [AFNetAPIClient GET:[LoginBaseURL stringByAppendingString:APIAddressList] token:userInfo.token parameters:dic success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            self.addressList = [AddressModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            [self.collectionView reloadData];
        }
    } failure:^(id JSON, NSError *error){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)onTapButton:(id)sender{
    if (![UserInfoManager sharedInstance].isLogin){
        LoginViewController* vc = [LoginViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    AddAddressViewController* vc = [AddAddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return self.addressList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* viewCell = nil;
    
    if (indexPath.section == 0) {
        AddressTopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddressTopViewCellID forIndexPath:indexPath];
        cell.indexPath = indexPath;
        viewCell = cell;
    }else{
        AddressCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddressCollectionViewCellID forIndexPath:indexPath];
        if (indexPath.item < self.addressList.count) {
            cell.address = self.addressList[indexPath.item];
        }
        WEAKSELF;
        cell.updateAddress = ^(AddressModel *address){
            AddAddressViewController* vc = [AddAddressViewController new];
            vc.address = self.addressList[indexPath.row];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
       viewCell = cell;
    }
    return viewCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        AddressHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AddressHeadViewID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = @"当前定位";
        }else{
            headerView.titleLabel.text = @"我的收获地址";
        }
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(ScreenW , 45);
    }
    if (indexPath.section == 1) {
        return CGSizeMake(ScreenW , 128);
    }
    return CGSizeZero;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(ScreenW, 42);
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return  0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 2) ? 10 : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.item == 1) {
        MapViewController* vc = [MapViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- init
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[AddressCollectionViewCell class] forCellWithReuseIdentifier:AddressCollectionViewCellID];
        [_collectionView registerClass:[AddressTopViewCell class] forCellWithReuseIdentifier:AddressTopViewCellID];
        
        [_collectionView registerClass:[AddressHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AddressHeadViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


@end
