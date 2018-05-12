//
//  AddAddressViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddAddressViewCell.h"
#import "AddAddressFootView.h"
#import "MapViewController.h"

@interface AddAddressViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)NSArray *titleArray;

@property (strong , nonatomic)UITextField *nameField;
@property (strong , nonatomic)UITextField *phoneField;
@property (strong , nonatomic)UITextField *villageField;
@property (strong , nonatomic)UITextField *buildingField;
@property (strong , nonatomic)UITextField *remarkField;
@end

static NSString *const AddAddressViewCellID = @"AddAddressViewCell";
static NSString *const AddAddressFootViewID = @"AddAddressFootView";

@implementation AddAddressViewController

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(ScreenW, 45);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[AddAddressViewCell class] forCellWithReuseIdentifier:AddAddressViewCellID];
        [_collectionView registerClass:[AddAddressFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:AddAddressFootViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增地址";
    self.titleArray = @[@"收货人：",@"手机号码：",@"小区／大厦：",@"楼号-门牌号：",@"备注信息："];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}

- (void)addAddress
{
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    NSDictionary* dic = @{
                          @"address": @"",
                          @"area": @"",
                          @"dimension": @"",
                          @"longitude": @"",
                          @"phone": @"",
                          @"realName": @""
                          };
    
    [Utility CXGMPostRequest:APIAddAddress token:userInfo.token parameter:dic success:^(id JSON, NSError *error){
        
    } failure:^(id JSON, NSError *error){
        
    }];
}


#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddAddressViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddAddressViewCellID forIndexPath:indexPath];
    [cell setHeadTitle:self.titleArray[indexPath.item]];
    if (indexPath.item == 2) {
        cell.arrow.hidden = NO;
    }
    switch (indexPath.item) {
        case 0:
            self.nameField = cell.textField;
            break;
        case 1:
            self.phoneField = cell.textField;
            break;
        case 2:
            self.villageField = cell.textField;
            break;
        case 3:
            self.buildingField = cell.textField;
            break;
        case 4:
            self.remarkField = cell.textField;
            break;
        default:
            break;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        AddAddressFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:AddAddressFootViewID forIndexPath:indexPath];
        reusableview = footview;
    }
    return reusableview;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(ScreenW, 65);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    MapViewController* vc = [MapViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
