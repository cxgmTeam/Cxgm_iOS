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

#import "GoodsDetailViewController.h"
#import "CartBadgeView.h"

#import "IQKeyboardManager.h"

#import "AnotherCartViewController.h"
#import "EmptyView.h"

@interface SearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,CartBadgeDelegate>
@property (strong,nonatomic)UICollectionView *collectionView;
@property (nonatomic,strong)UIView* topView;
@property (nonatomic,strong)CustomTextField* textField;
@property (nonatomic,strong)NSArray* hotKeyArray;
@property (nonatomic,strong)NSArray* resultArray;
@property (nonatomic,assign)BOOL showSearchResult;

@property (strong , nonatomic)CartBadgeView* cartBtn;

@property (strong , nonatomic)EmptyView* emptyView;
@end

/* cell */
static NSString *const SearchGridCellID = @"SearchGridCell";
static NSString *const GoodsListGridCellID = @"GoodsListGridCell";
/* head */
static NSString *const SearchHeadViewID = @"SearchHeadView";

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [self setupTopView];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    _emptyView = [EmptyView new];
    _emptyView.imageView.image = [UIImage imageNamed:@"search_empty"];
    _emptyView.textLabel.text = @"没有查找到您想要的商品~";
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.view);
        make.size.equalTo(CGSizeMake(249, 249));
    }];
    _emptyView.hidden = YES;
    
    
    _cartBtn = [CartBadgeView new];
    _cartBtn.delegate = self;
    [self.view addSubview:_cartBtn];
    [_cartBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(44, 44));
        make.right.equalTo(-20);
        if (iPhoneX) {
            make.bottom.equalTo(-40);
        }else{
            make.bottom.equalTo(-20);
        }
    }];
    [_cartBtn.carButton setImage:[UIImage imageNamed:@"cart_search"] forState:UIControlStateNormal];

    
    [self findHotProduct];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _topView.hidden = NO;
    

    if (self.showSearchResult && [_textField.text length] > 0) {
        [self searchGoods:_textField.text];
    }
    
}


- (void)findHotProduct
{
    NSDictionary* dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@"",
                          @"pageNum":@"1",
                          @"pageSize":@"8"};
    
    NSString* token = @"";
    if ([UserInfoManager sharedInstance].isLogin) {
        token = [UserInfoManager sharedInstance].userInfo.token;
    }
    
    WEAKSELF;
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindHotProduct]  token:token parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            self.hotKeyArray  = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            self.showSearchResult = NO;
            [weakSelf.collectionView reloadData];
        }
    } failure:^(id JSON, NSError *error){

    }];
}

- (void)searchGoods:(NSString *)key
{
    NSDictionary* dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@"",
                          @"goodName":key
                          };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APISearch] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            self.resultArray = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            self.showSearchResult = YES;
            [self.collectionView reloadData];
            
            self.emptyView.hidden = self.resultArray.count>0?YES:NO;
        }
        
    } failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    
    if ([_textField.text length]==0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"输入搜索关键词"];
        return YES;
    }
    
    [self searchGoods:_textField.text];
    
    return YES;
}

#pragma mark -
- (void)shopCarButtonClickAction{
    AnotherCartViewController* vc = [AnotherCartViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <UICollectionViewDataSource>
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    return [UIColor whiteColor];
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.showSearchResult) {
        return self.resultArray.count;
    }
    else{
        return self.hotKeyArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (self.showSearchResult) {
        GoodsListGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListGridCellID forIndexPath:indexPath];
        cell.goodsModel = self.resultArray[indexPath.item];
        gridcell = cell;
    }else{
        SearchGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchGridCellID forIndexPath:indexPath];
        GoodsModel* goods = self.hotKeyArray[indexPath.item];
        cell.titleLabel.text = goods.name;
        gridcell = cell;
    }
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        SearchHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchHeadViewID forIndexPath:indexPath];
        headerView.titleLabel.text = @"热门搜索";
        reusableview = headerView;
    }
    return reusableview;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showSearchResult) {
        return CGSizeMake((ScreenW - 12*3)/2, (ScreenW - 12*3)/2+72);
    }else{
        GoodsModel* goods = self.hotKeyArray[indexPath.item];
        CGFloat width = [self sizeLabelWidth:goods.name];
        return CGSizeMake(width , 24);
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.showSearchResult) {
        GoodsDetailViewController* vc = [GoodsDetailViewController new];
        GoodsModel* goods = self.resultArray[indexPath.item];
        vc.goodsId = goods.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GoodsModel* goods = self.hotKeyArray[indexPath.item];
        [self searchGoods:goods.name];
    }
}


#pragma mark-
- (CGFloat)sizeLabelWidth:(NSString *)text
{
    CGFloat titleWidth = 80;
    
    if (text.length > 0) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]};
        
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        titleWidth = ceilf(textSize.width)+20;
    }

    return titleWidth;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _topView.hidden = YES;
    
    [self.textField resignFirstResponder];
}

- (void)setupTopView
{
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [cancelBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, (44-28)/2, ScreenW-65, 28)];
    [self.navigationController.navigationBar addSubview:_topView];
    
    _textField = [CustomTextField new];
    _textField.delegate = self;
    _textField.layer.cornerRadius = 14;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:242/255.0 alpha:1/1.0];
    _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"top_searchBar_search"];
    _textField.leftView = imgView;
    _textField.placeholder = @"特惠三文鱼";
    [_topView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.topView);
    }];
}

- (void)onTapButton:(id)sender
{
    [self.textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
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


@end
