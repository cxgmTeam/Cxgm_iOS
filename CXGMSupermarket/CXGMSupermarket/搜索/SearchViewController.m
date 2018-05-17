//
//  SearchViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/10.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "SearchViewController.h"
//cell
#import "SearchGridCell.h"
#import "GoodsListGridCell.h"
//head
#import "SearchHeadView.h"

#import "ULBCollectionViewFlowLayout.h"

@interface SearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic)UICollectionView *collectionView;
@property (nonatomic,strong)UIView* topView;
@property (nonatomic,assign)BOOL showSearchResult;
@end

/* cell */
static NSString *const SearchGridCellID = @"SearchGridCell";
static NSString *const GoodsListGridCellID = @"GoodsListGridCell";
/* head */
static NSString *const SearchHeadViewID = @"SearchHeadView";

@implementation SearchViewController

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        ULBCollectionViewFlowLayout *layout = [ULBCollectionViewFlowLayout new];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[SearchGridCell class] forCellWithReuseIdentifier:SearchGridCellID];
        [_collectionView registerClass:[GoodsListGridCell class] forCellWithReuseIdentifier:GoodsListGridCellID];

        [_collectionView registerClass:[SearchHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchHeadViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTopView];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - <UICollectionViewDataSource>
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    return [UIColor whiteColor];
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.showSearchResult) {
        return 1;
    }
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.showSearchResult) {
        return 10;
    }
    else{
        if (section == 0) {
            return 4;
        }
        if (section == 1) {
            return 1;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (self.showSearchResult) {
        GoodsListGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListGridCellID forIndexPath:indexPath];
        
        gridcell = cell;
    }else{
        SearchGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchGridCellID forIndexPath:indexPath];
        
        gridcell = cell;
    }
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        SearchHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchHeadViewID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = @"热门搜索";
        }else{
            headerView.titleLabel.text = @"搜索历史";
        }
        reusableview = headerView;
    }
    return reusableview;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showSearchResult) {
        return CGSizeMake((ScreenW - 12*3)/2, (ScreenW - 12*3)/2+72);
    }else{
        return CGSizeMake(80 , 24);
    }
    return CGSizeZero;
}
#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (!self.showSearchResult) {
        return CGSizeMake(ScreenW, 34);
    }
    return CGSizeZero;
}
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.showSearchResult) {
        return 11;
    }else{
        return 8;
    }
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.showSearchResult) {
        return 15;
    }else{
        return 10;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 12, 12, 12);
}


#pragma
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _topView.hidden = NO;
    
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _topView.hidden = YES;
}

- (void)setupTopView
{
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton* cancelBtn = [UIButton new];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:Color333333 forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [cancelBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, (44-28)/2, ScreenW-65, 28)];
    [self.navigationController.navigationBar addSubview:_topView];
    
    CustomTextField* textField = [CustomTextField new];
    textField.layer.cornerRadius = 14;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeySearch;
    textField.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:242/255.0 alpha:1/1.0];
    textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"top_searchBar_search"];
    textField.leftView = imgView;
    textField.placeholder = @"特惠三文鱼";
    [_topView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.topView);
    }];
}

- (void)onTapButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
