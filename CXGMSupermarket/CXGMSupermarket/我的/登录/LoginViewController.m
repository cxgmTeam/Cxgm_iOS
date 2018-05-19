//
//  LoginViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField* phoneField;
@property(nonatomic,strong)UITextField* codeField;
@property(nonatomic,strong)UIButton* codeButton;
@property(nonatomic,strong)UIButton* loginBtn;

@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)int times;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupUI];
    
}

- (void)backButtonClicked:(UIButton *)button
{
    if (self.showCart) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DontShowCart_Notify object:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)textFieldTextChange:(UITextField *)textField{

    if (textField == _phoneField) {
        _codeButton.backgroundColor = textField.text.length>0 ? Color00A862:[UIColor colorWithHexString:@"C6C6C6"];
    }
    if (textField == _codeField) {
        _loginBtn.backgroundColor = textField.text.length>0 ? Color00A862:[UIColor colorWithHexString:@"C6C6C6"];
    }
}

- (void)onTapCodeButton:(UIButton *)button
{
    [self.view endEditing:YES];
    
    if (![Utility checkTelNumber:_phoneField.text]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入正确的手机号码"];
        return;
    }
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        _times = 60;
    }
    WEAKSELF;
    NSDictionary* dic = @{@"phone":_phoneField.text};
    [AFNetAPIClient POST:[LoginBaseURL stringByAppendingString:APISendSMS] token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code integerValue] == 200) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"发送成功,请注意查收"];
        }else{
            [weakSelf sendCodeFailed];
        }
    } failure:^(id JSON, NSError *error){
        [weakSelf sendCodeFailed];
    }];
}

- (void)sendCodeFailed
{
    [MBProgressHUD MBProgressHUDWithView:self.view Str:@"验证码发送失败,请重新获取"];
    self.codeButton.enabled = YES;
    self.codeButton.titleLabel.text =@"获取验证码";
    [self stopTimer];
}

- (void)onTimer
{
    _times--;
    _codeButton.titleLabel.text = [NSString stringWithFormat:@"剩余%ds",_times];
    _codeButton.enabled = NO;
    if (_times == 0) {
        _codeButton.enabled = YES;
        _codeButton.titleLabel.text =@"获取验证码";
        [self stopTimer];
    }
}

//废弃定时器
- (void)stopTimer
{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
        _times = 60;
    }
}

- (void)validateSMSMessage
{
    NSDictionary* dic = @{@"phone":_phoneField.text,@"checkcode":_codeField.text};
    
    WEAKSELF;
    [AFNetAPIClient POST:[LoginBaseURL stringByAppendingString:APIValidaSMS] token:nil parameters:dic success:^(id JSON, NSError *error){

        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code integerValue] == 200) {
            [weakSelf loginAccount];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}

- (void)loginAccount
{    
    WEAKSELF;
    NSDictionary* dict = @{@"userAccount":_phoneField.text,@"mobileValidCode":_codeField.text};
    
    [Utility CXGMPostRequest:[LoginBaseURL stringByAppendingString:APIUserLogin] token:nil parameter:dict success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithDictionary:JSON error:nil];
        if ([model.data isKindOfClass:[NSDictionary class]]) {
            
            [UserInfoManager sharedInstance].userInfo = [[UserInfo alloc] initWithDictionary:(NSDictionary *)model.data error:nil];
            [[UserInfoManager sharedInstance] saveUserInfo:(NSDictionary *)model.data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}


- (void)onTapLoginButton:(UIButton *)button
{
    if (_codeField.text.length <= 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入验证码"];
        return;
    }

    [self validateSMSMessage];
}

#pragma mark- init
- (void)setupUI
{
    UIView* topView = [UIView new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(NAVIGATION_BAR_HEIGHT);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, STATUS_BAR_HEIGHT, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"登录";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(topView);
        make.bottom.equalTo(-14);
    }];
    
    
    
    UIView* line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(75+NAVIGATION_BAR_HEIGHT);
        make.left.equalTo(27);
        make.right.equalTo(-27);
        make.height.equalTo(1);
    }];
    
    _phoneField = [UITextField new];
    _phoneField.delegate = self;
    _phoneField.placeholder = @"请输入您的手机号";
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneField];
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(line1);
        make.bottom.equalTo(line1.top).offset(-8);
        make.height.equalTo(27);
        make.width.equalTo(200);
    }];
    [_phoneField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    _codeButton = [UIButton new];
    _codeButton.layer.cornerRadius = 3;
    _codeButton.backgroundColor = [UIColor colorWithHexString:@"C6C6C6"];
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _codeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.view addSubview:_codeButton];
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(line1);
        make.bottom.equalTo(line1.top).offset(-8);
        make.size.equalTo(CGSizeMake(82, 27));
    }];
    [_codeButton addTarget:self action:@selector(onTapCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* line2 = [UIView new];
    line2.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(124+NAVIGATION_BAR_HEIGHT);
        make.left.equalTo(27);
        make.right.equalTo(-27);
        make.height.equalTo(1);
    }];
    
    _codeField = [UITextField new];
    _codeField.placeholder = @"请输入验证码";
    [self.view addSubview:_codeField];
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(line2);
        make.bottom.equalTo(line2.top).offset(-8);
        make.height.equalTo(27);
        make.width.equalTo(200);
    }];
    [_codeField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    _loginBtn = [UIButton new];
    _loginBtn.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1/1.0];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.right.equalTo(line1);
        make.top.equalTo(line2.bottom).offset(42);
        make.height.equalTo(42);
    }];
    [_loginBtn addTarget:self action:@selector(onTapLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"未注册过的手机号码将自动注册为菜鲜果美账户";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(line1);
        make.top.equalTo(self.loginBtn.bottom).offset(12);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.numberOfLines = 0;
    label1.text = @"登录即代表同意《菜鲜果美注册协议》《菜鲜果美用户隐私协议》";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.right.equalTo(line1);
        make.bottom.equalTo(-39);
    }];
    
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:label1.text];
    [attr setAttributes:@{NSForegroundColorAttributeName:Color999999} range:NSMakeRange(0, 7)];
    [attr setAttributes:@{NSForegroundColorAttributeName:Color00A862} range:NSMakeRange(7, attr.length-7)];
    label1.attributedText = attr;
}

#pragma mark-
- (void)dealloc{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
}
@end
