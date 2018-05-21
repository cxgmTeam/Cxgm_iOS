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

@property(nonatomic,strong)NSArray* categoryList;
@end

static NSString* const CatoryGridViewCellID = @"CatoryGridViewCell";

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.categoryNames = @[@"新鲜水果",
//                           @"蔬菜净菜",
//                           @"海鲜水产",
//                           @"肉禽蛋品",
//                           @"面点主食",
//                           @"乳品烘焙",
//                           @"餐饮熟食",
//                           @"方便净菜",
//                           @"粮油副食",
//                           @"休闲零食",
//                           @"中外名酒",
//                           @"饮料冲调",
//                           @"美妆个护",
//                           @"母婴保健",
//                           @"厨卫百货"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    typeof(self) __weak wself = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself findFirstCategory];
    }];
    
    
    UIButton* searchBtn = [UIButton new];
    [searchBtn setImage:[UIImage imageNamed:@"top_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(onTapSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    
    [self findFirstCategory];

}

//一级分类
- (void)findFirstCategory
{
    NSDictionary* dic = @{@"shopId":@""};
    if ([DeviceHelper sharedInstance].shop) {
         dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id};
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindFirstCategory]  token:nil parameters:dic success:^(id JSON, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            self.categoryList = [CategoryModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            [self.collectionView reloadData];
        }
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(id JSON, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
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
        layout.minimumLineSpacing = (ScreenW - 90*3 - 23*2)/2.f;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[CatoryGridViewCell class] forCellWithReuseIdentifier:CatoryGridViewCellID];
        [self.view addSubview:_collectionView];
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 22, 10, 22);
    }
    return _collectionView;
}

@end
