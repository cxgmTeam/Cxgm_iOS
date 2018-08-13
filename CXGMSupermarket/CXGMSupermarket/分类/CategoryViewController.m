//
//  CategoryViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/10.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CategoryViewController.h"
#import "CatoryGridViewCell.h"
#import "SubCategoryController.h"
#import "SearchViewController.h"

@interface CategoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray* categoryList;

@property(nonatomic,strong)UIButton* selectShopBtn;
@end

static NSString* const CatoryGridViewCellID = @"CatoryGridViewCell";

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.categoryList = [NSMutableArray array];

    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    typeof(self) __weak wself = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.collectionView.mj_header endRefreshing];
        [wself findFirstCategory];
    }];
    
    
    UIButton* searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [searchBtn setImage:[UIImage imageNamed:@"top_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(onTapSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    
    _selectShopBtn = [UIButton new];
    _selectShopBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [_selectShopBtn setTitle:@"请先选择店铺" forState:UIControlStateNormal];
    _selectShopBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [_selectShopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_selectShopBtn];
    [_selectShopBtn addTarget:self action:@selector(gotoWindowShopping:) forControlEvents:UIControlEventTouchUpInside];
    [_selectShopBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(120, 42));
        make.center.equalTo(self.view);
    }];
    _selectShopBtn.hidden = YES;
    
}

- (void)gotoWindowShopping:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:WindowHomePage_Notify object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self findFirstCategory];
}

//一级分类
- (void)findFirstCategory
{
    _selectShopBtn.hidden = YES;
    if ([[DeviceHelper sharedInstance].shop.id length] == 0) {
        _selectShopBtn.hidden = NO;
        return;
    }
    
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
         dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    

    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindFirstCategory]  token:nil parameters:dic success:^(id JSON, NSError *error){

        [self.categoryList removeAllObjects];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray * array = [CategoryModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            for (CategoryModel * model in array) {
                if (![model.name isEqualToString:@"中外名酒"]) {
                    [self.categoryList addObject:model];
                }
            }
            [self.collectionView reloadData];
        }
        
    } failure:^(id JSON, NSError *error){

    }];
}

- (void)onTapSearchBtn:(id)sender
{
    SearchViewController* vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CatoryGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CatoryGridViewCellID forIndexPath:indexPath];
    cell.category = self.categoryList[indexPath.item];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    SubCategoryController* vc = [SubCategoryController new];
    vc.category = self.categoryList[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(90, 95+10);
        layout.minimumInteritemSpacing = (ScreenW - 90*3 - 21*2)/2.f;
        layout.minimumLineSpacing = 5;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[CatoryGridViewCell class] forCellWithReuseIdentifier:CatoryGridViewCellID];
        [self.view addSubview:_collectionView];
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 20, 10, 20);
    }
    return _collectionView;
}

@end
