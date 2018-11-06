//
//  RegisterViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/3.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "RegisterViewController.h"
#import "PortraitViewController.h"
#import "BindingPhoneViewController.h"
#import "RegisterView.h"

#import "ThirdPartyLoginHelper.h"
#import "EnterAppHelper.h"
#import "CountDownTimer.h"

#import "LoginAPI.h"
#import "UITextField+TextFormat.h"
#import "RetrievePasswordViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate,RegisterViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *registerLabel;/* 注册label */
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@property (weak, nonatomic) IBOutlet RegisterView *registerView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *wechatLoginBtn;

@property (weak, nonatomic) IBOutlet UIButton *qqLoginBtn;

@property (weak, nonatomic) IBOutlet UIButton *policyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdLoginB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerPadding;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwdPadding;

@property (assign, nonatomic) BOOL phonePress;

@property (assign, nonatomic) BOOL verifyCodePress;

@property (assign, nonatomic) BOOL passwordPress;

@property (strong, nonatomic) CountDownTimer *timer;/* 倒计时 */


@end

@implementation RegisterViewController

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
    
    CGFloat bottom;
    
    if (IS_IPHONE5 || IS_IPHONE4S) {
        bottom = ScreenHeight * 0.1;
    } else {
        bottom = ScreenHeight * 0.15;
    }
    
    self.thirdLoginB.constant = bottom;
    self.tipB.constant = bottom * 0.3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
}

#pragma mark - API
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


-(void)hasRegisterPhone:(NSString *)phone{
    
    [LoginAPI hasRegisterPhone:phone callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            BOOL hasRegister = [dict[@"flag"] boolValue];
            if (hasRegister) {
                [self.registerView updatePhoneWarning:@"该手机号已注册"];
                self.registerView.verifyCodeBtn.userInteractionEnabled = YES;
            } else {
                [self getVerifyCodeByPhone:phone];
            }
        } else {
            self.registerView.verifyCodeBtn.userInteractionEnabled = YES;
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

-(void)getVerifyCodeByPhone:(NSString *)phone{
    
    [LoginAPI getVerifyCodeWithPhone:phone callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            [self initTimer];
            [self.registerView updatePhoneWarning:@""];
        } else {
            [self.registerView updateVerifyCodeWarning:message];
        }
   }];
}

#pragma mark - UI

-(void)updateUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.registerPadding.constant = 10*Heigt_Scale;
    self.passwdPadding.constant = 10*Heigt_Scale;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideTheKeyboard)];
//
//    [self.view addGestureRecognizer:tap];
    
    self.bgView.layer.cornerRadius = 10;
//    self.bgView.layer.masksToBounds = YES;
    //加阴影
    [self.bgView shadowOffset:CGSizeMake(0, 1) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:3 shadowOpacity:1];
    
    self.registerView.delegate = self;
    self.registerView.phoneTF.delegate = self;
    self.registerView.verifyCodeTF.delegate = self;
    self.registerView.passwordTF.delegate = self;
    
    self.nextBtn.enabled = NO;
    
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor colorwithHexString:@"8D8D8D"] forState:UIControlStateDisabled];
    self.nextBtn.layer.cornerRadius = 20;
    
    [QuanUtils formatText:self.policyBtn.titleLabel.text withAttributedText:@"\"用户注册协议\"" color:[UIColor colorwithHexString:@"#000000"] font:[UIFont systemFontOfSize:14]];
    
    /* 对应友盟登录type */
    self.wechatLoginBtn.tag = 1;
    self.qqLoginBtn.tag = 4;
}

#pragma mark - <RegisterViewDelegate>
-(void)verifyCodeClicked:(UIButton *)button{
    
    self.registerView.verifyCodeBtn.userInteractionEnabled = NO;
    
    NSString *phone = [self.registerView.phoneTF.text noneSpaseString];

    BOOL isNumber = [phone validateNumber];

    if (isNumber) {

        [self hasRegisterPhone:phone];

    } else {

        [self.registerView updatePhoneWarning:@"请输入11位手机号"];
        self.registerView.verifyCodeBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - Button Action

- (IBAction)forgetPasswd:(id)sender {
    UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];
    
    RetrievePasswordViewController *retrievePasswordVC = [registerSB instantiateViewControllerWithIdentifier:@"RetrievePasswordViewController"];
    
    [self.navigationController pushViewController:retrievePasswordVC animated:YES];
}
- (IBAction)nextStep:(UIButton *)sender {
    
    if ([NSString stringIsNull:self.registerView.phoneTF.text] || [NSString stringIsNull:self.registerView.verifyCodeTF.text] ) {

        NSString *msg = @"";

        if ([NSString stringIsNull:self.registerView.phoneTF.text]) {
            msg = @"请输入手机号";
            [self.registerView updatePhoneWarning:msg];
        } else {
            msg = @"请输入验证码";
            [self.registerView updateVerifyCodeWarning:msg];
        }

    } else {
        NSString *msg = [self.registerView.passwordTF.text isOrNoPasswordStyle];

        if ([NSString stringIsNull:msg]) {
            [self verifyPhoneAndCode];
        } else {
            [self.registerView updatePasswordWarning:msg];
        }
    }
    
}

-(void)verifyPhoneAndCode{
    
    NSString *phone = [self.registerView.phoneTF.text noneSpaseString];

    [LoginAPI verifyWithPhone:phone
                   verifyCode:self.registerView.verifyCodeTF.text
                     password:self.registerView.passwordTF.text
                     callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];

            PortraitViewController *portraitVC = [registerSB instantiateViewControllerWithIdentifier:@"PortraitViewController"];

            portraitVC.portraitPath = dict[AVATAR];
            portraitVC.uid = dict[UID];
            portraitVC.phone = phone;
            portraitVC.password = self.registerView.passwordTF.text;

            [self.navigationController pushViewController:portraitVC animated:YES];
        } else {
            [self.registerView updateVerifyCodeWarning:message];

        }
    }];
    
}


- (IBAction)thirdLogin:(UIButton *)sender {
    
    ThirdPartyLoginHelper *loginHelper = [[ThirdPartyLoginHelper alloc] init];
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在处理"];
    [self hideHUDAfter:2];
    
    [loginHelper getAuthWithUserInfoFrom:sender.tag success:^(UMSocialUserInfoResponse *result) {
//        // 授权信息
//        NSLog(@"Wechat uid: %@", result.uid);
//        NSLog(@"Wechat openid: %@", result.openid);
//        NSLog(@"Wechat unionid: %@", result.unionId);
//        NSLog(@"Wechat accessToken: %@", result.accessToken);
//        NSLog(@"Wechat refreshToken: %@", result.refreshToken);
//        NSLog(@"Wechat expiration: %@", result.expiration);
//
//        // 用户信息
//        NSLog(@"Wechat name: %@", result.name);
//        NSLog(@"Wechat iconurl: %@", result.iconurl);
//        NSLog(@"Wechat gender: %@", result.unionGender);
//
//        // 第三方平台SDK源数据
//        NSLog(@"Wechat originalResponse: %@", result.originalResponse);
        
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



#pragma mark - 倒计时
-(void)initTimer{
    
    self.timer = [[CountDownTimer alloc] initWithTimeInterval:1.0 totalTime:60];
    self.timer.delegate = self;
}

-(void)timeLeft:(NSString *)seconds{
    [self.registerView.verifyCodeBtn setTitle:seconds forState:UIControlStateNormal];
}

-(void)timeIsUp{
    [self.registerView.verifyCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
    self.registerView.verifyCodeBtn.userInteractionEnabled = YES;
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

#pragma mark - <UITextFieldDelegate>
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.registerView.phoneTF) {
        [self.registerView updatePhoneView];
        [self.registerView updateVerifyBtnView];
        self.phonePress = YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (textField == self.registerView.verifyCodeTF) {
        [self.registerView updateVerifyCodeView];
        self.verifyCodePress = YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (textField == self.registerView.passwordTF) {
        [self.registerView updatePasswordView];
        self.passwordPress = YES;
        textField.keyboardType = UIKeyboardTypeDefault;
    }
    
    if (self.phonePress && self.verifyCodePress && self.passwordPress) {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = [UIColor customisMainColor];
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.registerView.phoneTF) {
        [self.registerView updatePhoneWarning:@""];
        [textField valueChangeValueString:string shouldChangeCharactersInRange:range];
    }
    
    if (textField == self.registerView.verifyCodeTF) {
        [self.registerView updateVerifyCodeWarning:@""];
        return YES;

    }
    
    if (textField == self.registerView.passwordTF) {
        [self.registerView updatePasswordWarning:@""];
        return YES;

    }

    return NO;
    
}

/* 当用户按下return键或者按回车键，keyboard消失 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (IS_IPHONE4S || IS_IPHONE5) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y = 0;
            self.view.frame = viewFrame;
        } completion:^(BOOL finished) {
            [textField resignFirstResponder];
            
        }];
    }
    return YES;
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

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowLoginVC"]) {
    }
}

@end
