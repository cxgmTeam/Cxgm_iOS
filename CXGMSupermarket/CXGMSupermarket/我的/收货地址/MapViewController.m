//
//  MapViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "AddAddressViewController.h"

@interface MapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BMKPoiSearchDelegate>
@property(nonatomic,strong) BMKMapView* mapView;
@property(nonatomic,strong) BMKLocationService* locService;
@property(nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;
@property(nonatomic,strong) BMKReverseGeoCodeOption *reverseGeoCodeOption;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) CustomTextField* textField;
@property(strong,nonatomic) UIButton *mapPin;

@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) NSMutableArray *locationDataArr;

//检索
@property(nonatomic,strong)BMKPoiSearch *poiSearch;    //poi搜索
@property(nonatomic,strong)NSString * cityName;   // 检索城市名
@property(nonatomic,strong)NSString * keyWord;    // 检索关键字
@property(nonatomic,assign)int currentPage;            //  当前页
@property(strong,nonatomic) NSMutableArray *poiResultArray;       //poi结果信息集合

@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UITableView *searchTable;

@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UIButton *cancelButton;

@property(strong,nonatomic) NSMutableArray *pointArray;
@property(assign,nonatomic) NSInteger pointNodeNum;

@property(strong,nonatomic) BMKPolygon *ploygon;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationDataArr = [NSMutableArray array];
    self.pointArray = [NSMutableArray array];
    
    [self initTopBar];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*273/375.f)];
    [self.view addSubview:_mapView];
    
    _mapPin = [UIButton new];
    [_mapPin setImage:[UIImage imageNamed:@"location_pin"] forState:UIControlStateNormal];
    [_mapView addSubview:_mapPin];
    [_mapPin mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.mapView);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [self initLocationService];
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 66;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mapView.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //有关搜索
    _poiSearch = [[BMKPoiSearch alloc]init];
    
    _poiResultArray = [NSMutableArray array];
    
    _maskView = [UIView new];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    [self.view addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView:)]];
    
    _searchTable = [UITableView new];
    _searchTable.rowHeight = 66;
    _searchTable.delegate = self;
    _searchTable.dataSource = self;
    [self.view addSubview:_searchTable];
    [_searchTable mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    _maskView.hidden = YES;
    _searchTable.hidden = YES;
    
    [self performSelector:@selector(findAllPsfw) withObject:nil afterDelay:2.f];
//    [self findAllPsfw];
}


- (void)findAllPsfw
{
    if (![DeviceHelper sharedInstance].shop) return;
    
    NSDictionary* dic = @{@"shopId":[DeviceHelper sharedInstance].shop.id.length>0?[DeviceHelper sharedInstance].shop.id:@""};
    
    [self.pointArray removeAllObjects];
    
    [AFNetAPIClient GET:[LoginBaseURL stringByAppendingString:APIFindAllPsfw] token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            if ([(NSArray*)model.data count] > 0) {
                NSDictionary* dic = [(NSArray *)model.data objectAtIndex:0];
                NSString* psfw = dic[@"psfw"];
                NSArray* array = [psfw componentsSeparatedByString:@","];
                
                self.pointNodeNum = array.count;

                NSMutableArray * pointsArr = [NSMutableArray array];
                
                if (!self.ploygon)
                {
                    for (NSInteger i = 0;i < self.pointNodeNum  ;i++)
                    {
                        NSString* string = array[i];
                        NSArray* arr = [string componentsSeparatedByString:@"_"];
                        if (arr.count>1) {
                            
                            CLLocation *location = [[CLLocation alloc] initWithLatitude:[arr[1] floatValue] longitude:[arr[0] floatValue]];
                            [pointsArr addObject:location];

                        }
                    }

                    CLLocationCoordinate2D commuterLotCoords[self.pointNodeNum];
                    
                    for(int i = 0; i < [pointsArr count]; i++) {
                        commuterLotCoords[i] = [[pointsArr objectAtIndex:i] coordinate];
                    }

                    self.ploygon = [BMKPolygon polygonWithCoordinates:commuterLotCoords count:self.pointNodeNum];
                    [self.mapView addOverlay:self.ploygon];
                }
                
            }
        }
    } failure:^(id JSON, NSError *error){
        
    }];
    
}

// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth = 2.0;
        polygonView.lineDash = YES;
        return polygonView;
    }
    return nil;
}


-(void)inputaction:(UITextField *)textField{
    [self performSelector:@selector(delayToSearch) withObject:self afterDelay:0.5];
}

- (void)delayToSearch
{
    if (_textField.text.length == 0) return;
    
    [self initPoiSearch];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _maskView.hidden = NO;
    
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    
    _topView.frame = CGRectMake(20, (44-28)/2, ScreenW-70, 28);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_textField resignFirstResponder];
    return YES;
}

- (void)tapMaskView:(UIGestureRecognizer *)gesture
{
    [_textField resignFirstResponder];
    _topView.frame = CGRectMake(50, (44-28)/2, ScreenW-70, 28);
    
    _maskView.hidden = YES;
    _searchTable.hidden = YES;
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.rightBarButtonItem =  nil;
}
#pragma mark --初始化poi类
-(void)initPoiSearch
{
    self.currentPage = 0;
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = self.currentPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city = @"";
    citySearchOption.keyword = _textField.text;
    BOOL flag = [_poiSearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

#pragma mark 初始化地图，定位
-(void)initLocationService
{
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    
    _mapView.zoomLevel=11;
    _mapView.delegate=self;
    _mapView.showsUserLocation = YES;

    [_mapView bringSubviewToFront:_mapPin];
    

    if (_locService==nil) {

        _locService = [[BMKLocationService alloc]init];

        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];
    }

    _locService.delegate = self;
    [_locService startUserLocationService];


    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _poiSearch.delegate = self;
    
    _topView.hidden = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _poiSearch.delegate = nil;
    
    _topView.hidden = YES;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *在地图View停止定位后，会调用此函数

 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    //设置地图中心为用户经纬度
    [_mapView updateLocationData:userLocation];


    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    //和覆盖范围冲突
    
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.004;//纬度范围
    [_mapView setRegion:region animated:YES];
    
}

#pragma mark BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];

    if (_geoCodeSearch==nil) {
        //初始化地理编码类
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;

    }
    if (_reverseGeoCodeOption==nil) {

        //初始化反地理编码类
        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    }

    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    
}

#pragma mark BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        
        [self.locationDataArr removeAllObjects];
        
//        for(BMKPoiInfo *poiInfo in result.poiList)
        for (int i = 0; i < result.poiList.count; i++)
        {
            BMKPoiInfo* poiInfo = [result.poiList objectAtIndex:i];
            
            LocationModel *model=[[LocationModel alloc]init];
            model.name=poiInfo.name;
            model.address=poiInfo.address;
            model.latitude = poiInfo.pt.latitude;
            model.longitude = poiInfo.pt.longitude;
            
            model.inScope = [Utility checkAddress:[NSString stringWithFormat:@"%lf",poiInfo.pt.longitude] dimension:[NSString stringWithFormat:@"%lf",poiInfo.pt.latitude]];
            
            [self.locationDataArr addObject:model];
            
            if (i == result.poiList.count-1) {
                [self.tableView reloadData];
            }
        }
        
        
    }else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表

        NSLog(@"起始点有歧义");
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
    
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
    
    
    
    if (error == BMK_SEARCH_NO_ERROR) {
//        NSMutableArray *annotations = [NSMutableArray array];
        
        [self.poiResultArray removeAllObjects];
        
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            
            LocationModel *model=[[LocationModel alloc]init];
            model.name=poi.name;
            model.address=poi.address;
            model.latitude = poi.pt.latitude;
            model.longitude = poi.pt.longitude;
            model.inScope = [Utility checkAddress:[NSString stringWithFormat:@"%lf",poi.pt.longitude] dimension:[NSString stringWithFormat:@"%lf",poi.pt.latitude]];
            
//            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//            item.coordinate = poi.pt;
//            item.title = poi.name;
//            [annotations addObject:item];
            
            [self.poiResultArray addObject:model];
            
            if (i == result.poiInfoList.count-1) {
                [self.searchTable reloadData];
            }
        }

        self.searchTable.hidden = self.poiResultArray.count > 0 ?NO:YES;
        
//        [_mapView addAnnotations:annotations];
//        [_mapView showAnnotations:annotations animated:YES];
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchTable) {
         return self.poiResultArray.count;
    }
    return self.locationDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    LocationTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[LocationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (tableView == _searchTable) {
        cell.location = self.poiResultArray[indexPath.row];
    }else{
        cell.location = self.locationDataArr[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LocationModel* model;
    if (tableView == _searchTable) {
        model = self.poiResultArray[indexPath.row];
    }else{
        model = self.locationDataArr[indexPath.row];
    }
//    if (!model.inScope) {
//        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"不在配送范围内"]; return;
//    }
    
    if (self.selectedAddress) {
        self.selectedAddress(model);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        AddAddressViewController* vc = [AddAddressViewController new];
        vc.selectedLoacation = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark-
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (void)backButtonClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:Color333333 forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_cancelButton addTarget:self action:@selector(onTapCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)onTapCancelButton:(id)sender
{
    [_textField resignFirstResponder];
    _topView.frame = CGRectMake(50, (44-28)/2, ScreenW-70, 28);
    
    _maskView.hidden = YES;
    _searchTable.hidden = YES;
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.rightBarButtonItem =  nil;
}

#pragma mark-
- (void)initTopBar
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(50, (44-28)/2, ScreenW-70, 28)];
    [self.navigationController.navigationBar addSubview:_topView];
    
    _textField = [CustomTextField new];
    _textField.delegate = self;
    _textField.layer.cornerRadius = 14;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:242/255.0 alpha:1/1.0];
    _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"top_searchBar_search"];
    _textField.leftView = imgView;
    _textField.placeholder = @"搜索小区/大厦";
    _textField.returnKeyType = UIReturnKeySearch;
    [_topView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.topView);
    }];
    [_textField addTarget:self action:@selector(inputaction:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark-
- (void)dealloc {
    if (_poiSearch != nil) {
        _poiSearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
@end
