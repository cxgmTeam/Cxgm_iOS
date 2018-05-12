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

@interface AddressViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@end

static NSString *const AddressCollectionViewCellID = @"AddressCollectionViewCell";

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
    
    [self getAddressList];
}

- (void)getAddressList
{
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    NSDictionary* dic = @{@"userId":userInfo.id,@"addressId":@" "};
    [AFNetAPIClient GET:[LoginBaseURL stringByAppendingString:APIAddressList] token:userInfo.token parameters:dic success:^(id JSON, NSError *error){
        
    } failure:^(id JSON, NSError *error){
        
    }];
}


- (void)onTapButton:(id)sender{
    AddAddressViewController* vc = [AddAddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddressCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddressCollectionViewCellID forIndexPath:indexPath];

    return cell;
}

#pragma mark- init
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(ScreenW, 128);
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[AddressCollectionViewCell class] forCellWithReuseIdentifier:AddressCollectionViewCellID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


@end
