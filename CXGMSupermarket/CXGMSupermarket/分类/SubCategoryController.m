//
//  SubCategoryController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/21.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "SubCategoryController.h"
#import "CategoryTableViewCell.h"
#import "GoodsTableViewCell.h"
#import "GoodsTableHead.h"
#import "GoodsDetailViewController.h"

#import "SearchViewController.h"
#import "CartBadgeView.h"
#import "AnotherCartViewController.h"

@interface SubCategoryController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CartBadgeDelegate>

@property(nonatomic,strong)UITableView* leftTableView;
@property(nonatomic,strong)UITableView* rightTableView;
@property(nonatomic,strong)UIScrollView* topScrollView;



@property(nonatomic,strong)UIButton* lastBtn;
@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,assign)NSInteger topScrollWidth;
@property(nonatomic,assign)NSInteger arrivedSecton;

@property(nonatomic,strong)NSArray* secondCategorys;
@property(nonatomic,strong)NSArray* thirdCategorys;
@property(nonatomic,strong)NSArray* goodsList;
@property(nonatomic,strong)NSMutableDictionary* dictionary;//三级分类作key  对应的Goods数组作value


@property(nonatomic,strong)NSURLSessionDataTask * secondCategoryTask;
@property(nonatomic,strong)NSURLSessionDataTask * thirdCategoryTask;
@property(nonatomic,strong)NSURLSessionDataTask * findProductTask;

@property(nonatomic,strong)CategoryModel* secondCategory;
@end


static NSString* const CategoryTableViewCellID = @"CategoryTableViewCell";
static NSString* const GoodsTableViewCellID = @"GoodsTableViewCell";

static CGFloat TopBtnWidth = 60;

@implementation SubCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.category.name;
    
    self.dictionary = [NSMutableDictionary dictionary];

    
    self.leftTableView.backgroundColor = RGB(0xf7, 0xf8, 0xf7);
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.bottom.equalTo(self.view);
        make.width.equalTo(93);
    }];

    self.topScrollWidth = ScreenW-93;
    self.topScrollView.frame = CGRectMake(93, 0, self.topScrollWidth, 40);

    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.right.equalTo(self.topScrollView);
        make.height.equalTo(1);
        make.top.equalTo(39);
    }];
    
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.right.equalTo(self.view);
        make.left.equalTo(self.leftTableView.right);
        make.top.equalTo(self.topScrollView.bottom);
    }];
    
    
    if (self.category) {
        [self findSecondCategory:self.category.id];
    }
    if (self.categoryId) {
        [self findSecondCategory:self.categoryId];
    }
}

- (void)setupThirdCategory
{
    for (UIImageView* subView in self.topScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (self.thirdCategorys.count == 0)
    {
         self.topScrollView.frame = CGRectMake(93, 0, self.topScrollWidth, 0);
        
        [self.rightTableView mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.topScrollView.bottom);
        }];
    }
    else
    {
        self.topScrollView.frame = CGRectMake(93, 0, self.topScrollWidth, 40);
        
        [self.rightTableView mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.topScrollView.bottom);
        }];
        
        
        CGFloat btnTotalWidth = 0;
        for (NSInteger i = 0; i <  self.thirdCategorys.count; i++)
        {
            CategoryModel* category = self.thirdCategorys[i];
            
            CGFloat width = [self sizeLabelWidth:category.name];
            

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(btnTotalWidth, 0, width, 40);
            [button setTitle:category.name forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
            [button setTitleColor: [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            button.tag = i;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                button.selected = YES;
                self.lastBtn = button;
            }
            [self.topScrollView addSubview:button];
            
            btnTotalWidth = btnTotalWidth+ width;
        }

        
        self.topScrollView.contentSize = CGSizeMake(btnTotalWidth, 40);
    }

    
}

- (void)sortThirdGoods:(NSArray *)list
{
    [self.dictionary removeAllObjects];
    
    if (self.thirdCategorys.count == 0)
    {
        [self.rightTableView reloadData];
    }
    else
    {
        
        NSMutableArray* tempArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i < self.thirdCategorys.count;i++) {
            CategoryModel* category = self.thirdCategorys[i];
            
            NSMutableArray* array = [NSMutableArray array];
            
            for (NSInteger j = 0; j < list.count; j++){
                GoodsModel* goods = list[j];
                if ([goods.productCategoryThirdName isEqualToString:category.name]) {
                    [array addObject:goods];
                }
                if (j == list.count-1) {
                    [self.dictionary setObject:array forKey:category.name];
                }
                
                if ([goods.productCategoryThirdName length] == 0 && ![tempArray containsObject:goods]) {
                    [tempArray addObject:goods];
                }
            }
            
            if (i == self.thirdCategorys.count-1) {
                [array addObjectsFromArray:tempArray];
                
                [self.rightTableView reloadData];
            }
        }
    }
}


//二级分类
- (void)findSecondCategory:(NSString *)productCategoryId
{
    NSDictionary* dic = @{@"shopId":@"",@"productCategoryId":productCategoryId.length > 0? productCategoryId:@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id,
                @"productCategoryId":productCategoryId.length > 0? productCategoryId:@""};
    }
    
    typeof(self) __weak wself = self;
    
   self.secondCategoryTask =
   [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindSecondCategory]  token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = [CategoryModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            self.secondCategorys = array;
            
            [wself.leftTableView reloadData];
            
            if (array.count > 0) {
                CategoryModel* category = [array firstObject];
                category.selected = @"1";
                
                self.secondCategory = category;
                
                [wself findThirdCategory:category.id];
                
                [wself findProductByCategory:category.id];
            }
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

//三级分类
- (void)findThirdCategory:(NSString *)productCategoryTwoId
{
    NSDictionary* dic = @{@"shopId":@"",@"productCategoryTwoId":productCategoryTwoId.length > 0? productCategoryTwoId:@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id,
                @"productCategoryTwoId":productCategoryTwoId.length > 0? productCategoryTwoId:@""};
    }
    typeof(self) __weak wself = self;
    
    self.thirdCategoryTask =
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindThirdCategory]  token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            self.thirdCategorys = [CategoryModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            
           [wself setupThirdCategory];
            
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}


- (void)findProductByCategory:(NSString *)productCategoryTwoId
{
    NSDictionary* dic = @{@"shopId":@"",@"productCategoryTwoId":productCategoryTwoId.length > 0? productCategoryTwoId:@""};
    if ([DeviceHelper sharedInstance].shop) {
        dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id,
                @"productCategoryTwoId":productCategoryTwoId.length > 0? productCategoryTwoId:@""};
    }
    
    NSString* token = @"";
    if ([UserInfoManager sharedInstance].isLogin) {
        token = [UserInfoManager sharedInstance].userInfo.token;
    }

    typeof(self) __weak wself = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    self.findProductTask =
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindProductByCategory]  token:token parameters:dic success:^(id JSON, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = [GoodsModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            self.goodsList = array;
            [wself sortThirdGoods:array];
        }
        
    } failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)clickButton:(UIButton *)button
{
    self.lastBtn.selected = NO;
    button.selected = YES;
    self.lastBtn = button;
    
    CGFloat xx = self.topScrollWidth * (button.tag - 1) * (TopBtnWidth / self.topScrollWidth) - TopBtnWidth;
    [self.topScrollView scrollRectToVisible:CGRectMake(xx, 0, self.topScrollWidth, 40) animated:YES];
    
    
    CategoryModel* category = self.thirdCategorys[button.tag];
    NSArray* array = [self.dictionary objectForKey:category.name];
    if (array.count > 0) {
        //移动下方的table
        NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:0 inSection:button.tag];
        [self.rightTableView scrollToRowAtIndexPath:moveToIndexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

#pragma mark-
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    NSLog(@"%s",__func__);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    if (scrollView == self.rightTableView) return;
    
//    NSLog(@"%s",__func__);
    
    float xx = scrollView.contentOffset.x * (TopBtnWidth / self.topScrollWidth) - TopBtnWidth;
    [self.topScrollView scrollRectToVisible:CGRectMake(xx, 0, self.topScrollWidth, 40) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.leftTableView || scrollView == self.topScrollView) return;
    
//    NSLog(@"%s",__func__);
    
    NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
//    NSLog(@"topHeaderViewIndexpath  %ld",topHeaderViewIndexpath.section);
    if (self.arrivedSecton == topHeaderViewIndexpath.section) {
        return;
    }
    
    self.arrivedSecton = topHeaderViewIndexpath.section;
    self.lastBtn.selected = NO;
    UIButton *button = self.topScrollView.subviews[self.arrivedSecton];
    if ([button isKindOfClass:[UIButton class]]) {
        button.selected = YES;
        self.lastBtn = button;
    }
    CGFloat xx = self.topScrollWidth * (button.tag - 1) * (TopBtnWidth / self.topScrollWidth) - TopBtnWidth;
    [self.topScrollView scrollRectToVisible:CGRectMake(xx, 0, self.topScrollWidth, 40) animated:YES];
}


#pragma mark- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _leftTableView) {
        return 1;
    }
    if (self.thirdCategorys.count == 0) {
        return 1;
    }
    return self.thirdCategorys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return self.secondCategorys.count;
    }
    
    if (self.thirdCategorys.count == 0) {
        return self.goodsList.count;
    }
    
    CategoryModel* category = self.thirdCategorys[section];
    NSArray* array = [self.dictionary objectForKey:category.name];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* tableCell = nil;
    if (tableView == self.leftTableView) {
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryTableViewCellID];
        if (!cell) {
            cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CategoryTableViewCellID];
        }
        cell.category = self.secondCategorys[indexPath.row];
        tableCell = cell;
    }else{
        GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsTableViewCellID];
        if (!cell) {
            cell = [[GoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GoodsTableViewCellID];
        }
        if (self.thirdCategorys.count == 0) {
            cell.goodsModel = self.goodsList[indexPath.row];
        }else{
            CategoryModel* category = self.thirdCategorys[indexPath.section];
            NSArray* array = [self.dictionary objectForKey:category.name];
            cell.goodsModel = array[indexPath.row];
        }
        tableCell = cell;
    }
    return tableCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headView = nil;
    if (tableView == _rightTableView && self.thirdCategorys.count > 0) {
        GoodsTableHead* head = [[GoodsTableHead alloc] initWithFrame:CGRectMake(0, 0, ScreenH-93, 34)];
        CategoryModel* category = self.thirdCategorys[section];
        head.contentLabel.text = category.name;
        headView = head;
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        return self.thirdCategorys.count > 0?34.f:0.0f;
    }
    return 0.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _leftTableView) {
        for (CategoryModel* item in self.secondCategorys) {
            item.selected = @"0";
        }
        CategoryModel* item = self.secondCategorys[indexPath.row];
        item.selected = @"1";
        
        self.secondCategory = item;
        
        [_leftTableView reloadData];
        
        [self findThirdCategory:item.id];
        
        [self findProductByCategory:item.id];
        
    }else{
        GoodsDetailViewController* vc = [GoodsDetailViewController new];
        if (self.thirdCategorys.count == 0) {
            GoodsModel* goodsModel = self.goodsList[indexPath.row];
            vc.goodsId = goodsModel.id;
        }else{
            CategoryModel* category = self.thirdCategorys[indexPath.section];
            NSArray* array = [self.dictionary objectForKey:category.name];
            GoodsModel* goodsModel = array[indexPath.row];
            vc.goodsId = goodsModel.id;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.rightTableView) {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == self.rightTableView) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

#pragma mark- inital
- (UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [UITableView new];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 40;
        [self.view addSubview:_leftTableView];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 97;
        [self.view addSubview:_rightTableView];
        _rightTableView.tableFooterView = [UIView new];
    }
    return _rightTableView;
}

- (UIScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [UIScrollView new];
        _topScrollView.delegate = self;
        _topScrollView.backgroundColor = [UIColor whiteColor];
        _topScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_topScrollView];
        
    }
    return _topScrollView;
}


#pragma mark-
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIButton* searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [searchBtn setImage:[UIImage imageNamed:@"top_search"] forState:UIControlStateNormal];
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    [searchBtn addTarget:self action:@selector(onTapSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    
    CartBadgeView *cartBtn = [[CartBadgeView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    cartBtn.delegate = self;
    [cartBtn.carButton setImage:[UIImage imageNamed:@"top_cart"] forState:UIControlStateNormal];
    cartBtn.carButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    UIBarButtonItem* cartItem = [[UIBarButtonItem alloc] initWithCustomView:cartBtn];

    
    self.navigationItem.rightBarButtonItems = @[cartItem,searchItem];
    
    
    //主要是刷新 shopCartNum 和 shopCartId
    if (self.secondCategory) {
        [self findProductByCategory:self.secondCategory.id];
    }
}

- (void)onTapSearchBtn:(id)sender
{
    SearchViewController* vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shopCarButtonClickAction
{
    if (![UserInfoManager sharedInstance].isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        return ;
    }
    AnotherCartViewController* vc = [AnotherCartViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-


- (CGFloat)sizeLabelWidth:(NSString *)text
{
    CGFloat titleWidth = 60;
    
    if (text.length > 0) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]};
        
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        titleWidth = ceilf(textSize.width)+20;
    }
    
    return titleWidth;
}


- (void)dealloc{
    NSLog(@"%s",__func__);
    
    [self.secondCategoryTask cancel];
    [self.thirdCategoryTask cancel];
    [self.findProductTask cancel];
}

@end
