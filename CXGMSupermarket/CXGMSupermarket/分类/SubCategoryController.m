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

#import "CategoryItem.h"

@interface SubCategoryController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView* leftTableView;
@property(nonatomic,strong)UITableView* rightTableView;
@property(nonatomic,strong)UIScrollView* topScrollView;

@property(nonatomic,strong)NSMutableArray* categoryArray;//左边的类别
@property(nonatomic,strong)NSArray* subCategoryArray;//顶部的类别

@property(nonatomic,strong)UIButton* updownBtn;

@property(nonatomic,strong)UIButton* lastBtn;
@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,assign)NSInteger topScrollWidth;
@property(nonatomic,assign)NSInteger arrivedSecton;
@end


static NSString* const CategoryTableViewCellID = @"CategoryTableViewCell";
static NSString* const GoodsTableViewCellID = @"GoodsTableViewCell";

static CGFloat TopBtnWidth = 60;

@implementation SubCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.category.name;
    
    self.categoryArray = [NSMutableArray array];
    
    NSArray* array = @[@"精选推荐",
                       @"蔬菜豆菇",
                       @"新鲜水果",
                       @"鲜肉蛋禽",
                       @"水产蛋禽",
                       @"水产海鲜",
                       @"速冻食品",
                       @"牛奶面点",
                       @"休闲零食",
                       @"粮油副食",
                       @"厨房用品",
                       @"酒水饮料",
                       @"生活用品"];
    for (NSString* string in array) {
        CategoryItem* item = [CategoryItem new];
        item.name = string;
        [self.categoryArray addObject:item];
    }
    
    self.subCategoryArray = @[@"吃青豆",
                              @"吃青菜",
                              @"鲜豆腐",
                              @"鲜菌菇",
                              @"鲜苹果",
                              @"鲜鸡蛋",
                              @"鲜鱼",
                              @"鲜水果"];
    
    self.leftTableView.backgroundColor = RGB(0xf7, 0xf8, 0xf7);
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.bottom.equalTo(self.view);
        make.width.equalTo(93);
    }];
    
    [self.updownBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(40, 40));
        make.top.right.equalTo(self.view);
    }];
    
    self.topScrollWidth = ScreenW-93-40;
    self.topScrollView.frame = CGRectMake(93, 0, self.topScrollWidth, 40);

    
    for (UIImageView* subView in self.topScrollView.subviews) {
        [subView removeFromSuperview];
    }
    for (NSInteger i = 0; i <  self.subCategoryArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * TopBtnWidth, 0, TopBtnWidth, 40);
        [button setTitle:self.subCategoryArray[i] forState:UIControlStateNormal];
        [button setTitleColor:Color666666 forState:UIControlStateNormal];
        [button setTitleColor:Color00A862 forState:UIControlStateSelected];
        button.titleLabel.font = PFR14Font;
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            button.selected = YES;
            self.lastBtn = button;
        }
        [self.topScrollView addSubview:button];
    }
    self.topScrollView.contentSize = CGSizeMake(TopBtnWidth * self.subCategoryArray.count, 40);
    
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.right.equalTo(self.view);
        make.left.equalTo(self.leftTableView.right);
        make.top.equalTo(self.topScrollView.bottom);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(self.topScrollView);
        make.right.equalTo(self.view);
        make.height.equalTo(1);
        make.top.equalTo(39);
    }];
    
    
    if (self.category) {
        [self findSecondCategory:self.category.id];
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
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindSecondCategory]  token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = [CategoryModel arrayOfModelsFromDictionaries:(NSArray *)model.data error:nil];
            for (CategoryModel* category in array) {
                [wself findProductByCategory:category.id];
                
                [wself findThirdCategory:category.id];
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
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindThirdCategory]  token:nil parameters:dic success:^(id JSON, NSError *error){
//        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        
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
    
    [AFNetAPIClient GET:[HomeBaseURL stringByAppendingString:APIFindProductByCategory]  token:nil parameters:dic success:^(id JSON, NSError *error){
        //        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)clickButton:(UIButton *)button
{
    self.lastBtn.selected = NO;
    button.selected = YES;
    self.lastBtn = button;
    
    CGFloat xx = self.topScrollWidth * (button.tag - 1) * (TopBtnWidth / self.topScrollWidth) - TopBtnWidth;
    [self.topScrollView scrollRectToVisible:CGRectMake(xx, 0, self.topScrollWidth, 40) animated:YES];
    
    //移动下方的table
    NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:0 inSection:button.tag];
    [self.rightTableView scrollToRowAtIndexPath:moveToIndexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    return self.subCategoryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return self.categoryArray.count;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* tableCell = nil;
    if (tableView == self.leftTableView) {
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryTableViewCellID];
        if (!cell) {
            cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CategoryTableViewCellID];
        }
        cell.categoryItem = self.categoryArray[indexPath.row];
        tableCell = cell;
    }else{
        GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsTableViewCellID];
        if (!cell) {
            cell = [[GoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GoodsTableViewCellID];
        }
        tableCell = cell;
    }
    return tableCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headView = nil;
    if (tableView == _rightTableView) {
        GoodsTableHead* head = [[GoodsTableHead alloc] initWithFrame:CGRectMake(0, 0, ScreenH-93, 34)];
        head.contentLabel.text = self.subCategoryArray[section];
        headView = head;
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        return 34.f;
    }
    return 0.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _leftTableView) {
        for (CategoryItem* item in self.categoryArray) {
            item.selected = NO;
        }
        CategoryItem* item = self.categoryArray[indexPath.row];
        item.selected = YES;
        [_leftTableView reloadData];
    }else{
        GoodsDetailViewController* vc = [GoodsDetailViewController new];
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

- (UIButton *)updownBtn{
    if (!_updownBtn) {
        _updownBtn = [UIButton new];
        _updownBtn.backgroundColor = [UIColor whiteColor];
        [_updownBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [self.view addSubview:_updownBtn];
        
        UIView* line = [UIView new];
        line.backgroundColor = RGB(0xd8, 0xd8, 0xd8);
        [_updownBtn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.size.equalTo(CGSizeMake(1, 20));
            make.centerY.left.equalTo(self.updownBtn);
        }];
    }
    return _updownBtn;
}


@end
