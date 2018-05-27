//
//  OrderBillViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderBillViewController.h"
//cell
#import "BillTypeViewCell.h"
#import "BillReceiverViewCell.h"
#import "BillContentViewCell.h"
#import "BillHeadViewCell.h"
//foot
#import "BillPageFootView.h"


@interface OrderBillViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong , nonatomic)ReceiptItem *receiptItem;

@property(nonatomic,strong)UITextField* companyNameTextField;
@property(nonatomic,strong)UITextField* dutyParagraphTextField;


@end

@implementation OrderBillViewController

/* cell */
static NSString *const BillTypeViewCellID = @"BillTypeViewCell";
static NSString *const BillReceiverViewCellID = @"BillReceiverViewCell";
static NSString *const BillContentViewCellID = @"BillContentViewCell";
static NSString *const BillHeadViewCellID = @"BillHeadViewCell";
/* foot */
static NSString *const BillPageFootViewID = @"BillPageFootView";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票";
    
    self.receiptItem = [ReceiptItem new];
    self.receiptItem.type = @"1";
    self.receiptItem.phone = [UserInfoManager sharedInstance].userInfo.mobile;
    self.receiptItem.userId = [UserInfoManager sharedInstance].userInfo.id;
    self.receiptItem.companyName = @"";
    self.receiptItem.dutyParagraph = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    self.receiptItem.createTime = dateString;
    
    self.receiptItem.isOpen = NO;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}

- (void)onTapSaveBtn:(UIButton *)button
{
    !_writeReceiptFinish?:_writeReceiptFinish(self.receiptItem);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.companyNameTextField && [textField.text isEqualToString:@"请在此填写准确的抬头名称"]) {
        textField.text = @"";
    }
    if (textField == self.dutyParagraphTextField && [textField.text isEqualToString:@"请在此填写纳税人识别号"]) {
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    if (textField == self.companyNameTextField && ![textField.text isEqualToString:@"请在此填写准确的抬头名称"]) {
        self.receiptItem.companyName = textField.text;
    }
    if (textField == self.dutyParagraphTextField && ![textField.text isEqualToString:@"请在此填写纳税人识别号"]) {
        self.receiptItem.dutyParagraph = textField.text;
    }
}

#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    switch (indexPath.item) {
        case 0:{
            BillTypeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BillTypeViewCellID forIndexPath:indexPath];
            cell.selectReceiptType = ^(NSString *type){
                self.receiptItem.type = type;
            };
            gridcell = cell;
        }
            
            break;
        case 1:{
            BillReceiverViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BillReceiverViewCellID forIndexPath:indexPath];
            gridcell = cell;
        }
            
            break;
        case 2:{
            BillContentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BillContentViewCellID forIndexPath:indexPath];
            gridcell = cell;
        }
            
            break;
        case 3:{
            BillHeadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BillHeadViewCellID forIndexPath:indexPath];
            cell.receipt = self.receiptItem;
            cell.companyNameTextField.delegate = self;
            cell.dutyParagraphTextField.delegate = self;
            
            self.companyNameTextField = cell.companyNameTextField;
            self.dutyParagraphTextField = cell.dutyParagraphTextField;
            
            cell.selectReceiptHead = ^(BOOL isOpen){
                self.receiptItem.isOpen = isOpen;
                
                
                
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            };
            gridcell = cell;
        }
            break;
            
        default:
            break;
    }
    return gridcell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.item) {
        case 0:
            return CGSizeMake(ScreenW, 83);
            break;
        case 1:
            return CGSizeMake(ScreenW, 45);
            break;
        case 2:
            return CGSizeMake(ScreenW, 45);
            break;
        case 3:{
            if(self.receiptItem.isOpen){
                return CGSizeMake(ScreenW, 190);
            }else{
                return CGSizeMake(ScreenW, 84);
            }
        }
            break;
        default:
            break;
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        BillPageFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BillPageFootViewID forIndexPath:indexPath];
        [footview.saveButton addTarget:self action:@selector(onTapSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        reusableview = footview;
    }
    return reusableview;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(ScreenW, 133+42);  
}

#pragma mark-
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing= 0;
        layout.minimumLineSpacing = 10;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[BillTypeViewCell class] forCellWithReuseIdentifier:BillTypeViewCellID];
        [_collectionView registerClass:[BillReceiverViewCell class] forCellWithReuseIdentifier:BillReceiverViewCellID];
        [_collectionView registerClass:[BillContentViewCell class] forCellWithReuseIdentifier:BillContentViewCellID];
        [_collectionView registerClass:[BillHeadViewCell class] forCellWithReuseIdentifier:BillHeadViewCellID];
        
        [_collectionView registerClass:[BillPageFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BillPageFootViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

@end
