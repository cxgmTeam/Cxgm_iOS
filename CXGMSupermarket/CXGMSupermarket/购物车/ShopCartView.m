//
//  ShopCartView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/19.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "ShopCartView.h"
#import "LZConfigFile.h"
#import "LZCartTableViewCell.h"


#import "CartEmptyTableCell.h"
#import "CartBottomBar.h"

#import "AppDelegate.h"



@interface ShopCartView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView *myTableView;

@property (strong,nonatomic)CartBottomBar *bottomView;

@property (strong,nonatomic)NSMutableArray *dataArray;
@property (strong,nonatomic)NSMutableArray *selectedArray;
@property(assign,nonatomic)NSInteger pageNum;

@end

@implementation ShopCartView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        
        self.pageNum = 1;
        
        [self getShopCartList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShopCart:) name:AddGoodsSuccess_Notify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShopCart:) name:AddOrder_Success object:nil];
    }
    return self;
}

- (void)setupUI
{
    self.bottomView.hidden = YES;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(0);
    }];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.bottomView.top);
    }];
    
    WEAKSELF
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf.dataArray removeAllObjects];
        
        [weakSelf getShopCartList];
        
        [weakSelf retsetSelectedStatus];
    }];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNum ++;
        [weakSelf getShopCartList];
    }];
}

- (void)refreshShopCart:(NSNotification *)notiy
{
    self.pageNum = 1;
    [self.dataArray removeAllObjects];
    
    [self getShopCartList];
    
    [self retsetSelectedStatus];
}

- (void)getShopCartList
{
    if (![UserInfoManager sharedInstance].isLogin) return;
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userInfo;
    NSDictionary* dic = @{
                          @"pageNum":[NSString stringWithFormat:@"%ld",(long)self.pageNum],
                          @"pageSize":@"10",
                          @"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""
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
        [self.myTableView.mj_header endRefreshing];
    } failure:^(id JSON, NSError *error){
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf.myTableView.mj_footer endRefreshing];
    }];
}

#pragma mark-

- (void)retsetSelectedStatus
{
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
    if (self.selectedArray.count > 0) {
        for (LZCartModel *model in self.selectedArray) {
            model.select = @"0";
        }
        [self.selectedArray removeAllObjects];
        [self.myTableView reloadData];
    }
    
    [self.bottomView.checkOutButton setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)self.selectedArray.count] forState:UIControlStateNormal];
    //初始化显示状态
    self.bottomView.allSellectedButton.selected = NO;
    self.bottomView.totlePriceLabel.text = @"合计：￥0.00";
    self.bottomView.preferentialLabel.text = @"总额：¥0.00  优惠：¥0.00";
    
}

- (void)changeView
{
    if (self.dataArray.count > 0)
    {
        if (self.selectedArray.count == self.dataArray.count) {
            self.bottomView.allSellectedButton.selected = YES;
        } else {
            self.bottomView.allSellectedButton.selected = NO;
        }
        
        self.bottomView.hidden = NO;
        [self.bottomView updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(50);
        }];
    }else{
        self.bottomView.hidden = YES;
        [self.bottomView updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(0);
        }];
    }
}

//  计算已选中商品金额
-(void)countPrice
{
    [self.bottomView.checkOutButton setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)self.selectedArray.count] forState:UIControlStateNormal];
    
    double totlePrice = 0.0;
    
    double originalTotal = 0.0;
    
    for (LZCartModel *model in self.selectedArray) {
        
        double price = [model.price doubleValue];
        
        totlePrice += price*[model.goodNum intValue];
        
        double original = [model.originalPrice doubleValue];
        
        originalTotal += original*[model.goodNum intValue];
    }
    
    //总额为原价总和  优惠为优惠金额总额   合计为两者的差
    self.bottomView.totlePriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",totlePrice];
    self.bottomView.preferentialLabel.text = [NSString stringWithFormat:@"总额：¥%.2f  优惠：¥%.2f",originalTotal,originalTotal-totlePrice];
    
    if (ScreenW <= 320) {
        self.bottomView.preferentialLabel.text = [NSString stringWithFormat:@"总额：¥%.2f\n优惠：¥%.2f",originalTotal,originalTotal-totlePrice];
    }
    
}

- (void)deleteShopCart:(NSArray *)array
{
    if (array.count == 0) return;
    
    NSString* idString = @"";
    for (NSInteger i = 0 ; i < array.count ; i++) {
        LZCartModel * model = array[i];
        if (i == 0) {
            idString = [idString stringByAppendingString:model.id];
        }else{
            idString = [idString stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
        }
    }
    NSDictionary* dic = @{@"shopCartIds":idString};
    
    [AFNetAPIClient POST:[OrderBaseURL stringByAppendingString:APIDeleteShopCart] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code intValue] == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DeleteShopCart_Success object:nil];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)updateCart:(LZCartModel *)goodsModel
{
    CGFloat amount = [goodsModel.goodNum floatValue]*[goodsModel.price floatValue];
    
    NSDictionary* dic = @{@"id":goodsModel.id.length>0?goodsModel.id:@"",
                          @"amount":[NSString stringWithFormat:@"%.2f",amount],
                          @"goodCode":goodsModel.goodCode.length>0?goodsModel.goodCode:@"",
                          @"goodName":goodsModel.goodName.length>0?goodsModel.goodName:@"",
                          @"goodNum":goodsModel.goodNum.length>0?goodsModel.goodNum:@"",
                          @"categoryId":goodsModel.categoryId.length>0?goodsModel.categoryId:@"",
                          @"shopId":goodsModel.shopId.length>0?goodsModel.shopId:@""
                          };
    [Utility CXGMPostRequest:[OrderBaseURL stringByAppendingString:APIUpdateCart] token:[UserInfoManager sharedInstance].userInfo.token parameter:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.code intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{

            });
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}


#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* tableCell = nil;
    if (self.dataArray.count == 0)
    {
        CartEmptyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartEmptyTableCell"];
        if (cell == nil) {
            cell = [[CartEmptyTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CartEmptyTableCell"];
        }
        tableCell = cell;
    }
    else
    {
        LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
        if (cell == nil) {
            cell = [[LZCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LZCartReusableCell"];
        }
        
        LZCartModel *model = self.dataArray[indexPath.row];
        
        __block typeof(cell)wsCell = cell;
        typeof(self) __weak wself = self;
        
        [cell numberAddWithBlock:^(NSInteger number) {
            wsCell.lzNumber = number;
            model.goodNum = [NSString stringWithFormat:@"%ld",(long)number];
            
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            if ([self.selectedArray containsObject:model]) {
                [self.selectedArray removeObject:model];
                [self.selectedArray addObject:model];
                [self countPrice];
            }
            
            [wself updateCart:model];
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
            
            //调用修改购物车
            [wself updateCart:model];
            
        }];
        
        [cell cellSelectedWithBlock:^(BOOL select) {
            
            model.select = select==YES?@"1":@"0";
            if (select) {
                [self.selectedArray addObject:model];
            } else {
                [self.selectedArray removeObject:model];
            }
            
            if (self.selectedArray.count == self.dataArray.count) {
                self.bottomView.allSellectedButton.selected = YES;
            } else {
                self.bottomView.allSellectedButton.selected = NO;
            }
            
            [self countPrice];
        }];
        
        [cell reloadDataWithModel:model];
        
        tableCell = cell;
    }

    return tableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return self.bounds.size.height;
    }
    return 160;;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return   UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        typeof(self) __weak wself = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            LZCartModel *model = [self.dataArray objectAtIndex:indexPath.row];
            
            NSArray* array = [NSArray arrayWithObject:model];
            [wself deleteShopCart:array];
            
            
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
                self.bottomView.allSellectedButton.selected = YES;
            } else {
                self.bottomView.allSellectedButton.selected = NO;
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
        
        UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LZCartModel *model = [self.dataArray objectAtIndex:indexPath.row];
    !_gotoGoodsDetail?:_gotoGoodsDetail(model);

}
#pragma mark-
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

- (void)deleteSelectedGoods
{
    if (self.selectedArray.count == 0) return;
    
    
    typeof(self) __weak wself = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [wself deleteShopCart:self.selectedArray];
        
        //删除成功后的操作
        for (LZCartModel* model in wself.selectedArray) {
            [wself.dataArray removeObject:model];
        }
        
        [wself countPrice];
        
        self.bottomView.allSellectedButton.selected = NO;
        if (wself.dataArray.count == 0) {
            [wself changeView];
        }
        [wself.myTableView reloadData];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancel];
    
    
    UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:alert animated:YES completion:nil];
}

#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    
    if (self.selectedArray.count > 0) {
        for (NSInteger i = 0; i < self.selectedArray.count; i++) {

            LZCartModel *model = self.selectedArray[i];
            
            if (i == self.selectedArray.count-1) {
                !_gotoConfirmOrder?:_gotoConfirmOrder(self.selectedArray);
            }
        }
    } else {
        [MBProgressHUD MBProgressHUDWithView:self Str:@"你还没有选择任何商品"];
    }
}


#pragma mark- init
- (CartBottomBar *)bottomView{
    if (!_bottomView) {
        _bottomView = [CartBottomBar new];
        [self addSubview:_bottomView];
        [_bottomView.allSellectedButton addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.checkOutButton addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [UITableView new];
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [self addSubview:_myTableView];
    }
    return _myTableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
