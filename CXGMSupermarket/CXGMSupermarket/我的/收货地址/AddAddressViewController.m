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

@interface AddAddressViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic)NSArray *titleArray;

@property (strong , nonatomic)UITextField *nameField;
@property (strong , nonatomic)UITextField *phoneField;
@property (strong , nonatomic)UITextField *biotopeField;
@property (strong , nonatomic)UITextField *buildingField;
@property (strong , nonatomic)UITextField *remarkField;

@property (strong , nonatomic)LocationModel *location;

@property (strong , nonatomic)NSMutableDictionary *dictionary;
@end

static NSString *const AddAddressViewCellID = @"AddAddressViewCell";
static NSString *const AddAddressFootViewID = @"AddAddressFootView";

@implementation AddAddressViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.address) {
        self.title = @"修改地址";
    }else{
        self.title = @"新增地址";
    }

    self.titleArray = @[@"收货人：",@"手机号码：",@"小区／大厦：",@"楼号-门牌号：",@"备注信息："];
    
    self.dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"",@"realName",
                       @"",@"phone",
                       @"",@"area",
                       @"",@"address", nil];

    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}

- (void)deleteAddress:(id)sender
{
    NSDictionary* dic = @{@"addressId":self.address.id};
    [AFNetAPIClient POST:[LoginBaseURL stringByAppendingString:APIDeleteAddress] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code isEqualToString:@"200"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)setAddress:(AddressModel *)address{
    _address = address;
}

- (void)addAddress
{
    // area 存放小区大厦   address 存放门牌号
    if (self.nameField.text.length == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入收货人"]; return;
    }
    if (self.phoneField.text.length == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入电话号码"]; return;
    }
    if (self.biotopeField.text.length == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请选择小区/大厦"]; return;
    }
//    if (self.buildingField.text.length == 0) {
//        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请填写门牌号"]; return;
//    }
    
    
    if (self.selectedLoacation) {
        self.location = self.selectedLoacation;
    }
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    
    NSDictionary* dic;
    
    dic = @{
            @"address": self.buildingField.text,
            @"area": self.biotopeField.text,
            @"dimension": [NSString stringWithFormat:@"%lf",self.location.latitude],
            @"longitude": [NSString stringWithFormat:@"%lf",self.location.longitude],
            @"phone": self.phoneField.text,
            @"realName": self.nameField.text,
            @"isDef":self.firstAddress==YES?@"1":@"0"
            
            };
    
    
    NSString* stringUrl = APIAddAddress;
    if (self.address) {
        stringUrl = APIUpdateAddress;
        
        dic = @{
                @"id": self.address.id,
                @"address": self.buildingField.text,
                @"area": self.biotopeField.text,
                @"dimension": self.address.dimension,
                @"longitude": self.address.longitude,
                @"phone": self.phoneField.text,
                @"realName": self.nameField.text,
                @"isDef": @"",
                };
    }
    
    WEAKSELF;
    [Utility CXGMPostRequest:[LoginBaseURL stringByAppendingString:stringUrl] token:userInfo.token parameter:dic success:^(id JSON, NSError *error){

        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            if (self.selectedLoacation) {
                NSArray* vcs = weakSelf.navigationController.childViewControllers;
                if (vcs.count > 1) {
                    [weakSelf.navigationController popToViewController:vcs[1] animated:YES];
                }
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.biotopeField == textField) {
        
        MapViewController* vc = [MapViewController new];
        vc.selectedAddress = ^(LocationModel *model){
            self.location = model;
            if (self.address) {
                self.address.dimension = [NSString stringWithFormat:@"%f",model.latitude];
                self.address.longitude = [NSString stringWithFormat:@"%f",model.longitude];
            }
            
            self.biotopeField.text = [model.address stringByAppendingString:model.name];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }
    return YES;
}

#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddAddressViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddAddressViewCellID forIndexPath:indexPath];
    [cell setHeadTitle:self.titleArray[indexPath.item]];
    cell.textField.delegate = self;
    
    if (indexPath.item == 2) {
        cell.arrow.hidden = NO;
    }
    switch (indexPath.item) {
        case 0:
            self.nameField = cell.textField;//收货人
            if (self.address) {
                self.nameField.text = self.address.realName;
            }
            break;
        case 1:
            self.phoneField = cell.textField;//手机号码
            self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
            if (self.address) {
                self.phoneField.text = self.address.phone;
            }
            break;
        case 2:
            self.biotopeField = cell.textField;//小区/大厦
            cell.textField.placeholder = @"请选择";
            if (self.address) {
                self.biotopeField.text = self.address.area;
            }
            if (self.selectedLoacation) {
                self.biotopeField.text = self.selectedLoacation.address;
            }
            break;
        case 3:
            self.buildingField = cell.textField;//楼号-门牌号
            cell.textField.placeholder = @"例如：B座1901室";
            if (self.buildingField) {
                self.buildingField.text = self.address.address;
            }
            break;
        case 4:
            self.remarkField = cell.textField;//备注
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
        WEAKSELF;
        footview.saveUserAddress = ^{
            [weakSelf addAddress];
        };
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
    vc.selectedAddress = ^(LocationModel *model){
        self.location = model;
        if (self.address) {
            self.address.dimension = [NSString stringWithFormat:@"%f",model.latitude];
            self.address.longitude = [NSString stringWithFormat:@"%f",model.longitude];
        }
        self.biotopeField.text = [model.address stringByAppendingString:model.name];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

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

@end
