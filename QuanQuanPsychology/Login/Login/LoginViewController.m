//
//  LoginViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/3.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "LoginViewController.h"
#import "RetrievePasswordViewController.h"
#import "BindingPhoneViewController.h"
#import "RegisterViewController.h"

#import "PasswordLoginView.h"
#import "QuickLoginView.h"
#import "ThirdPartyLoginHelper.h"
#import "EnterAppHelper.h"
#import "CountDownTimer.h"

#import "LoginAPI.h"

#import "UITextField+TextFormat.h"

//
#import "LoginFastView.h"//快速登录
#import "LoginPasswdView.h"//密码登录
#import "VerificationCodeViewController.h"//获取验证码vc
#import "RetrievePasswordViewController.h"//找回密码


@interface LoginViewController ()<LoginFastDelegate, LoginPasswdDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginBgView;

@property (weak, nonatomic) IBOutlet UIButton *wechatLoginBtn;

@property (weak, nonatomic) IBOutlet UIButton *qqLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboLoginBtn;

@property (assign, nonatomic) BOOL isPasswordLogin;

@property (nonatomic, strong) LoginFastView *fastView;/**< 快速登录 */
@property (nonatomic, strong) LoginPasswdView *passwdView;/**< 密码登录 */
@property (nonatomic, strong) NSString *phone;/**< <#注释#> */

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateUI];
    
    self.title = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
}

#pragma mark -
-(void)checkBindingStatusWithInfo:(UMSocialUserInfoResponse *)info
                             type:(NSString *)type{
    
    [LoginAPI hasBindPhoneWithOpenID:info.openid nickname:info.name photo:info.iconurl type:type callback:^(APIReturnState state, id data, NSString *message) {
        
        if (state == API_SUCCESS) {
            [self hideHUD];
            
            NSDictionary *dict = (NSDictionary *)data;
            NSDictionary *userinfo = dict[USERINFO];
            
            if (userinfo == nil) {
                
                UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];
                
                BindingPhoneViewController *bindingVC = [registerSB instantiateViewControllerWithIdentifier:@"BindingPhoneViewController"];
                
                bindingVC.authID = dict[@"auth_id"];
                
                [self.navigationController pushViewController:bindingVC animated:YES];
                
            } else {
                
                EnterAppHelper *helper = [[EnterAppHelper alloc] init];
                
                [helper setUserDefaultsAndSaveUserInfo:userinfo withPhone:userinfo[UPHONE] currentVC:self];
                
            }
            
        } else {
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

#pragma mark - Button Action
- (void)changeLoginType:(UIButton *)button {
    if (button.selected) {
        NSLog(@"现在是快速");
        for (UIView *view in self.loginBgView.subviews) {
            if ([view isKindOfClass:[LoginPasswdView class]]) {
                [view removeFromSuperview];
            }
        }
        [self.loginBgView addSubview:self.fastView];
    } else {
        NSLog(@"现在是密码");
        for (UIView *view in self.loginBgView.subviews) {
            if ([view isKindOfClass:[LoginFastView class]]) {
                [view removeFromSuperview];
            }
        }
        [self.loginBgView addSubview:self.passwdView];
    }
    
    button.selected = !button.selected;
}

-(void)loginWithID:(NSString *)ID code:(NSString *)code loginType:(NSString *)type{
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在登录"];
    
    [LoginAPI loginWithPhone:ID andPassword:code loginType:type callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            [self hideHUD];
            NSDictionary *dict = (NSDictionary *)data;
            
            NSDictionary *userInfo = dict[USERINFO];
            
            EnterAppHelper *helper = [[EnterAppHelper alloc] init];
            //            helper.password = self.passwordLoginView.passwordTF.text;
            
            [helper setUserDefaultsAndSaveUserInfo:userInfo withPhone:ID currentVC:self];
            
        } else {
            [self hideHUD];
//            [self showMassage:message];
            [self showHUDWithMode:MBProgressHUDModeIndeterminate message:message];
            [self hideHUDAfter:1];
        }
    }];
}

- (IBAction)thirdLogin:(UIButton *)sender {
    
    ThirdPartyLoginHelper *loginHelper = [[ThirdPartyLoginHelper alloc] init];
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在处理"];
    [self hideHUDAfter:2];
    
    [loginHelper getAuthWithUserInfoFrom:sender.tag success:^(UMSocialUserInfoResponse *result) {
        
        NSString *type ;
        
        if (sender.tag == 1) {
            type = @"0";
        } else {
            type = @"1";
        }
        
        [self checkBindingStatusWithInfo:result type:type];
        
    } failure:^(NSError *error) {
        [self presentAlertWithTitle:@"登录失败，请重新登录" message:@"" actionTitle:@"好的"];
    }];
}

#pragma mark - loginfastdelegate
- (void)getFastCode {
    NSString *phoneNum = [self.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!phoneNum || phoneNum.length == 0 || phoneNum.length < 11) {
        [self showHUDWithMode:MBProgressHUDModeText message:@"手机号有误"];
        [self hideHUDAfter:1];
        return;
    }
    VerificationCodeViewController *verifiy = [[VerificationCodeViewController alloc] init];
    verifiy.phoneNum = self.phone;
    [self.navigationController pushViewController:verifiy animated:YES];
}

- (void)fastTFDidBeginEditing:(UITextField *)textField {
    
}

- (void)fastTFDidEndEditing:(UITextField *)textField {
    self.phone = textField.text;
}

#pragma mark - passwddelegate
- (void)passwdLogin {
    NSString *phone = [self.passwdView.phoneTF.text noneSpaseString];
    NSString *password = self.passwdView.passwdTF.text;
    
    if (!phone.length || !phone) {
        [self showHUDWithMode:MBProgressHUDModeText message:@"手机号码输入有误"];
        [self hideHUDAfter:1];
        return;
    }
    if (!password.length || !password) {
        [self showHUDWithMode:MBProgressHUDModeText message:@"密码输入错误"];
        [self hideHUDAfter:1];
        return;
    }
    
    [self loginWithID:phone code:password loginType:@"2"];
}

- (void)passwdForget {
    UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];
    
    RetrievePasswordViewController *reset = [registerSB instantiateViewControllerWithIdentifier:@"RetrievePasswordViewController"];
    [self.navigationController pushViewController:reset animated:YES];
//    ForgetPasswdViewController *forget = [[ForgetPasswdViewController alloc] init];
//    [self.navigationController pushViewController:forget animated:YES];
}

- (void)passwdTFDidEndEditing:(UITextField *)textField {
    
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    UITextField *codePhoneTF = [self.view viewWithTag:50];
    [codePhoneTF resignFirstResponder];
    
    UITextField *phoneTF = [self.view viewWithTag:60];
    UITextField *passwdTF = [self.view viewWithTag:61];
    [phoneTF resignFirstResponder];
    [passwdTF resignFirstResponder];
}

#pragma mark - ui
- (void)initUIView {
    /* 对应友盟登录type */
    /*
     UMSocialPlatformType_Predefine_Begin    = -1,
     UMSocialPlatformType_Sina               = 0, //新浪
     UMSocialPlatformType_WechatSession      = 1, //微信聊天
     UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
     UMSocialPlatformType_WechatFavorite     = 3,//微信收藏
     UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
     */
    self.wechatLoginBtn.tag = 1;
    self.qqLoginBtn.tag = 4;
    self.weiboLoginBtn.tag = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 100, 30);
    [rightBtn setTitle:@"密码登录" forState:UIControlStateNormal];
    [rightBtn setTitle:@"快速登录" forState:UIControlStateSelected];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(changeLoginType:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self addNavigationWithTitle:nil leftItem:nil rightItem:rightItem titleView:nil];
    
    [self.loginBgView addSubview:self.fastView];
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
}

- (LoginFastView *)fastView {
    if (!_fastView) {
        _fastView = [[NSBundle mainBundle] loadNibNamed:@"LoginFastView" owner:self options:nil].firstObject;
        _fastView.frame = self.loginBgView.bounds;
        _fastView.delegate = self;
    }
    return _fastView;
}

- (LoginPasswdView *)passwdView {
    if (!_passwdView) {
        _passwdView = [[NSBundle mainBundle] loadNibNamed:@"LoginPasswdView" owner:self options:nil].firstObject;
        _passwdView.frame = self.loginBgView.bounds;
        _passwdView.delegate = self;
    }
    return _passwdView;
}

#pragma mark - Notification
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification{
    
    if (IS_IPHONE4S || IS_IPHONE5) {
        //获取键盘的高度
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat height = [aValue CGRectValue].size.height;
        
        //使视图上移
        [UIView animateWithDuration:0.5 animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y = -height + 100;
            self.view.frame = viewFrame;
        }];
    }
}

#pragma mark - Touch Event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (IS_IPHONE4S || IS_IPHONE5) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y = 0;
            self.view.frame = viewFrame;
        } completion:^(BOOL finished) {
            [self.view endEditing:YES];
            
        }];
    } else {
        [self.view endEditing:YES];
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
