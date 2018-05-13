//
//  AnotherCartViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/13.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AnotherCartViewController.h"

#import "LZConfigFile.h"
#import "LZCartTableViewCell.h"
#import "LZCartModel.h"
#import "OrderConfirmViewController.h"

@interface AnotherCartViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView *myTableView;

@property (strong,nonatomic)UIView *emptyView;
@property (strong,nonatomic)UIView *bottomView;

@property (strong,nonatomic)UIButton *allSellectedButton;
@property (strong,nonatomic)UILabel *totlePriceLabel;
@property (strong,nonatomic)UILabel *preferentialLabel;//优惠
@property (strong,nonatomic)UIButton *checkOutButton;

@property (strong,nonatomic)NSMutableArray *dataArray;
@property (strong,nonatomic)NSMutableArray *selectedArray;
@property(assign,nonatomic)NSInteger pageNum;

@end

@implementation AnotherCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    
    UIButton* editBtn = [UIButton new];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:Color333333 forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    [self setupCartView];
    [self setupCartEmptyView];
    
    _myTableView.hidden = YES;
    _bottomView.hidden = YES;
    _emptyView.hidden = NO;
    
    
    self.pageNum = 1;
    [self getShopCartList];
}


- (void)getShopCartList
{
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    NSDictionary* dic = @{
                          @"pageNum":[NSString stringWithFormat:@"%ld",(long)self.pageNum],
                          @"pageSize":@"10"
                          };
    WEAKSELF;
    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APIShopCartList] token:userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [DataModel dataModelWith:JSON];
        if ([model.listModel.list isKindOfClass:[NSArray class]]) {
            NSArray* array = [LZCartModel arrayOfModelsFromDictionaries:(NSArray *)model.listModel.list error:nil];
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.myTableView reloadData];
            
            [weakSelf changeView];
            
            if (array.count == 0) {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.myTableView.mj_footer endRefreshing];
            }
        }else{
            [weakSelf.myTableView.mj_footer endRefreshing];
        }
        [weakSelf.myTableView.mj_header endRefreshing];
    } failure:^(id JSON, NSError *error){
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf.myTableView.mj_footer endRefreshing];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
    if (self.selectedArray.count > 0) {
        for (LZCartModel *model in self.selectedArray) {
            model.select = @"0";//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
        }
        [self.selectedArray removeAllObjects];
    }
    
    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.text = @"总计：￥0.00";
}




- (void)changeView {
    if (self.dataArray.count > 0) {
        
        _myTableView.hidden = NO;
        _bottomView.hidden = NO;
        _emptyView.hidden = YES;
        
    } else {
        
        _myTableView.hidden = YES;
        _bottomView.hidden = YES;
        _emptyView.hidden = NO;
    }
}

//  计算已选中商品金额
-(void)countPrice {
    double totlePrice = 0.0;
    
    for (LZCartModel *model in self.selectedArray) {
        
        double price = [model.price doubleValue];
        
        totlePrice += price*[model.goodNum intValue];
    }
    self.totlePriceLabel.text = [NSString stringWithFormat:@"总计：￥%.2f",totlePrice];
}

#pragma mark --
- (void)setupCartView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor =[UIColor whiteColor];
    backgroundView.tag = TAG_CartEmptyView + 1;
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];
    _bottomView = backgroundView;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, LZSCREEN_WIDTH, 1);
    lineView.backgroundColor = ColorE8E8E8E;
    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    selectAll.frame = CGRectMake(10, 5, 80, LZTabBarHeight - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"goods_unselect"] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
    [selectAll setTitleColor: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    btn.frame = CGRectMake(LZSCREEN_WIDTH - 118, 0, 118, LZTabBarHeight);
    [btn setTitle:@"去结算(3)" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    self.checkOutButton = btn;
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.text = @"合计：¥67.7";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [backgroundView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(5);
        make.left.equalTo(80);
    }];
    self.totlePriceLabel = label;
    
    //优惠
    label = [[UILabel alloc]init];
    label.text = @"总额：¥67.7   优惠：¥0.00  ";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [backgroundView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(-5);
        make.left.equalTo(80);
    }];
    self.preferentialLabel = label;
    
    
    //创建table
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 160;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.myTableView = table;
    
    [table mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(backgroundView.top);
    }];
    
    WEAKSELF
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf.dataArray removeAllObjects];
        
        [weakSelf getShopCartList];
    }];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNum ++;
        [weakSelf getShopCartList];
    }];
}

#pragma mark -- 购物车为空时的默认视图
- (void)setupCartEmptyView {
    //默认视图背景
    UIView *backgroundView = [UIView new];
    backgroundView.tag = TAG_CartEmptyView;
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    _emptyView = backgroundView;
    
    
    UIButton* button = [UIButton new];
    button.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [button setTitle:@"去逛逛" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgroundView addSubview:button];
    [button addTarget:self action:@selector(gotoWindowShopping) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(120, 42));
        make.center.equalTo(backgroundView);
    }];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车空空如也～";
    warnLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    warnLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [backgroundView addSubview:warnLabel];
    [warnLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(button.top).offset(-24);
        make.centerX.equalTo(backgroundView);
    }];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_cart"]];
    [backgroundView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(warnLabel.top).offset(-18);
        make.centerX.equalTo(backgroundView);
    }];
}

- (void)gotoWindowShopping{
    [[NSNotificationCenter defaultCenter] postNotificationName:WindowHomePage_Notify object:nil];
}


#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
    if (cell == nil) {
        cell = [[LZCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LZCartReusableCell"];
    }
    
    LZCartModel *model = self.dataArray[indexPath.row];
    __block typeof(cell)wsCell = cell;
    
    [cell numberAddWithBlock:^(NSInteger number) {
        wsCell.lzNumber = number;
        model.goodNum = [NSString stringWithFormat:@"%ld",(long)number];
        
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell numberCutWithBlock:^(NSInteger number) {
        
        wsCell.lzNumber = number;
        model.goodNum = [NSString stringWithFormat:@"%ld",(long)number];
        
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        
        model.select = select==YES?@"1":@"0";
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        if (self.selectedArray.count == self.dataArray.count) {
            self.allSellectedButton.selected = YES;
        } else {
            self.allSellectedButton.selected = NO;
        }
        
        [self countPrice];
    }];
    
    [cell reloadDataWithModel:model];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            LZCartModel *model = [self.dataArray objectAtIndex:indexPath.row];
            
            [self.dataArray removeObjectAtIndex:indexPath.row];
            //    删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            //判断删除的商品是否已选择
            if ([self.selectedArray containsObject:model]) {
                //从已选中删除,重新计算价格
                [self.selectedArray removeObject:model];
                [self countPrice];
            }
            
            if (self.selectedArray.count == self.dataArray.count) {
                self.allSellectedButton.selected = YES;
            } else {
                self.allSellectedButton.selected = NO;
            }
            
            if (self.dataArray.count == 0) {
                [self changeView];
            }
            
            //如果删除的时候数据紊乱,可延迟0.5s刷新一下
            [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (void)reloadTable {
    [self.myTableView reloadData];
}

#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (LZCartModel *model in self.selectedArray) {
        model.select = @"0";
    }
    
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (LZCartModel *model in self.dataArray) {
            model.select = @"1";
            [self.selectedArray addObject:model];
        }
    }
    
    [self.myTableView reloadData];
    [self countPrice];
}
#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    
    OrderConfirmViewController* vc = [OrderConfirmViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    if (self.selectedArray.count > 0) {
        for (LZCartModel *model in self.selectedArray) {
            NSLog(@"选择的商品>>%@>>>%@",model,model.goodNum);
            
        }
    } else {
        NSLog(@"你还没有选择任何商品");
    }
}

#pragma mark - 初始化数组
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}


@end
