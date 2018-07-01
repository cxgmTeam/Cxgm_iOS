//
//  PaymentViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentButton.h"

#import "WXApi.h"
#import "MXAliPayHandler.h"


#import "PayResultViewController.h"


@interface PaymentViewController ()

@property(nonatomic,strong)UIButton* payButon;

@property(nonatomic,strong)UILabel* timeLabel;
@property(nonatomic,strong)UILabel* moneyLabel;


@property(nonatomic,strong)PaymentButton* weixinBtn;
@property(nonatomic,strong)PaymentButton* alipayBtn;

@property(nonatomic,assign)double surplusTime;
@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,strong)NSString * payType; //微信wx，支付宝zfb
@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付订单";
    
    self.payType = @"wx";
    
    [self setupMainUI];
    
    if (self.order) {
        self.orderId = self.order.id;
        self.orderAmount = self.order.orderAmount;
    }
    
    if (self.orderId) {
        [self getSurplusTime];
    }
    
    if (self.order) {
        _moneyLabel.text = [NSString stringWithFormat:@"￥%@",self.order.orderAmount];
    }else{
        _moneyLabel.text = [NSString stringWithFormat:@"￥%@",self.orderAmount];
    }
     [_payButon setTitle:[NSString stringWithFormat:@"确认支付%@",_moneyLabel.text] forState:UIControlStateNormal];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPayResult:) name:Show_PayResult object:nil];
}

- (void)showPayResult:(NSNotification *)notify
{
    NSDictionary* dic = [notify userInfo];
    
    PayResultViewController* vc = [PayResultViewController new];
    vc.paySuccess = [dic[@"paySuccess"] boolValue];
    vc.orderAmount = self.orderAmount;
    vc.orderId = self.orderId;
    vc.payType = self.payType;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)getSurplusTime
{
    NSDictionary* dic = @{@"orderId":self.orderId};
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:[OrderBaseURL stringByAppendingString:APISurplusTime] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        
        if ([model.code isEqualToString:@"200"]) {
            self.surplusTime = [(NSNumber *)model.data longValue];
            [wself setupTimer];
        }else{
            self.timeLabel.text = @"已超时";
        }
        
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)setupTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)onTimer
{
    self.surplusTime = self.surplusTime-1000;
    if (self.surplusTime > 1000) {
        NSString* surplus = [Utility formateDate:self.surplusTime];
        _timeLabel.text = [NSString stringWithFormat:@"支付剩余时间  %@",surplus];
    }else{
        [self stopTimer];
        _timeLabel.text = @"已超时";
    }
}

- (void)stopTimer
{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)payOrder:(UIButton*)button
{
    if (self.surplusTime == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"订单已超时"];
        return;
    }
    [self weixinPay];
}
//请求订单信息

- (void)weixinPay
{
    NSDictionary* dic = @{@"orderId":self.orderId};
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient POST:[OrderBaseURL stringByAppendingString:APIWeixinPay] token:[UserInfoManager sharedInstance].userInfo.token parameters:dic success:^(id JSON, NSError *error){

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: [JSON dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: nil];
        
        [wself sendRepweixin:dic];
        
    } failure:^(id JSON, NSError *error){
        
    }];
}


-(void)sendRepweixin:(NSDictionary *)dict
{
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    
    
    BOOL isResult = [WXApi sendReq:req];
    if (isResult) {
        //添加事件监听微信支付成功消息

    }else {
        if (![WXApi isWXAppInstalled]) {
            NSString *tipMsg = @"您的手机未安装手机微信或微信版本过低，请升级微信后方可使用微信支付";
            [MBProgressHUD MBProgressHUDWithView:self.view Str:tipMsg];
            return;
        }
        else {
            //用户手机未安装微信、微信版本太低、微信客户端卡住、WXApi的registerApp的appid参数有误
        }
    }
}


-(void)doAlipayPay:(NSDictionary *)dict
{
    [MXAliPayHandler jumpToAliPay:dict];
}


#pragma mark-
- (void)setupMainUI
{
    UIView* bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(TAB_BAR_HEIGHT);
    }];
    
    [bottomView addSubview:self.payButon];
    [self.payButon mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(bottomView);
        make.height.equalTo(49);
    }];

    
    UIView* whiteView1 = [UIView new];
    whiteView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView1];
    [whiteView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(106);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"支付剩余时间  00:00:00";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView1 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(30);
        make.centerX.equalTo(whiteView1);
    }];
    _timeLabel = label;
    
    label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.frame = CGRectMake(25, 123, 326, 18);
    label.text = @"请在规定的时间内完成支付，否则订单将会被自动取消！";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = [UIColor colorWithRed:255/255.0 green:121/255.0 blue:40/255.0 alpha:1/1.0];
    [whiteView1 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.timeLabel.bottom).offset(5);
        make.centerX.equalTo(whiteView1);
        make.width.equalTo(ScreenW-20);
    }];
    
    UIView* whiteView2 = [UIView new];
    whiteView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView2];
    [whiteView2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.view);
        make.top.equalTo(whiteView1.bottom).offset(10);
        make.height.equalTo(45);
    }];
    
    label = [[UILabel alloc] init];
    label.text = @"实付金额：";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView2 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(whiteView2);
    }];
    
    label = [[UILabel alloc] init];
    label.text = @"￥464.14";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [whiteView2 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-15);
        make.centerY.equalTo(whiteView2);
    }];
    _moneyLabel = label;
    
    
    label = [[UILabel alloc] init];
    label.text = @"选择支付方式";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(whiteView2.bottom).offset(10);
        make.left.equalTo(15);
    }];
    

    _weixinBtn = [[PaymentButton alloc] initWithFrame:CGRectZero image:@"wechat_pay" title:@"微信支付"];
    _weixinBtn.tag = 1;
    [self.view addSubview:_weixinBtn];
    [_weixinBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(45);
    }];
    [_weixinBtn addTarget:self action:@selector(selectPayMent:) forControlEvents:UIControlEventTouchUpInside];
    
    _alipayBtn = [[PaymentButton alloc] initWithFrame:CGRectZero image:@"alipay_pay" title:@"支付宝支付"];
    _alipayBtn.tag = 2;
    [self.view addSubview:_alipayBtn];
    [_alipayBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.weixinBtn.bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.equalTo(45);
    }];
    [_alipayBtn addTarget:self action:@selector(selectPayMent:) forControlEvents:UIControlEventTouchUpInside];
    
    _weixinBtn.markView.hidden = NO;
    _alipayBtn.markView.hidden = YES;
}

- (void)selectPayMent:(PaymentButton *)button
{
    if (button.tag == 1) {
        _weixinBtn.markView.hidden = NO;
        _alipayBtn.markView.hidden = YES;
        
        self.payType = @"wx";
    }else{
        _weixinBtn.markView.hidden = YES;
        _alipayBtn.markView.hidden = NO;
        
        self.payType = @"zfb";
    }
}


- (UIButton *)payButon{
    if (!_payButon) {
        _payButon = [UIButton new];
        _payButon.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [_payButon setTitle:@"确认支付￥642.14" forState:UIControlStateNormal];
        _payButon.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [_payButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButon addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButon;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopTimer];
}
@end
