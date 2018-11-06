//
//  BindingPhoneViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/8.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BindingPhoneViewController.h"
#import "RegisterView.h"
#import "LoginAPI.h"
#import "EnterAppHelper.h"
#import "CountDownTimer.h"

#import "UITextField+TextFormat.h"

@interface BindingPhoneViewController ()<UITextFieldDelegate,RegisterViewDelegate,CountDownDelegate>

@property (weak, nonatomic) IBOutlet RegisterView *registerView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bindingT;

@property (assign, nonatomic) BOOL phonePress;

@property (assign, nonatomic) BOOL verifyCodePress;

@property (assign, nonatomic) BOOL passwordPress;

@property (strong, nonatomic) CountDownTimer *timer;/* 倒计时 */

@end

@implementation BindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.bindingT.constant = ScreenHeight * 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
}

#pragma mark - UI

-(void)updateUI{
    self.registerView.delegate = self;
    self.registerView.phoneTF.delegate = self;
    self.registerView.verifyCodeTF.delegate = self;
    self.registerView.passwordTF.delegate = self;
    
    self.loginBtn.enabled = NO;
    
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorwithHexString:@"8D8D8D"] forState:UIControlStateDisabled];
    self.loginBtn.layer.cornerRadius = 6;

}

#pragma mark - <RegisterViewDelegate>
-(void)verifyCodeClicked:(UIButton *)button{
    
    self.registerView.verifyCodeBtn.userInteractionEnabled = NO;
    
    NSString *phone = [self.registerView.phoneTF.text noneSpaseString];
    
    BOOL isNumber = [phone validateNumber];

    if (isNumber) {

        [LoginAPI getVerifyCodeWithPhone:phone callback:^(APIReturnState state, id data, NSString *message) {
            if (state == API_SUCCESS) {
                [self initTimer];
                [self.registerView updatePhoneWarning:@""];
            } else {
                [self.registerView updateVerifyCodeWarning:message];
            }
        }];

    } else {

        [self.registerView updatePhoneWarning:@"请输入11位手机号"];
        self.registerView.verifyCodeBtn.userInteractionEnabled = YES;

    }
}

#pragma mark - Button Action

- (IBAction)login:(UIButton *)sender {
    
    
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
            [self bindingPhone];
        } else {
            [self.registerView updatePasswordWarning:msg];
        }
    }
    
}

-(void)bindingPhone{
    
    NSString *phone = [self.registerView.phoneTF.text noneSpaseString];
    
    [LoginAPI bindingPhoneWithAuthID:self.authID uphone:phone verifyCode:self.registerView.verifyCodeTF.text password:self.registerView.passwordTF.text callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSDictionary *userinfo = dict[USERINFO];
            EnterAppHelper *helper = [[EnterAppHelper alloc] init];
            helper.password = self.registerView.passwordTF.text;
            [helper setUserDefaultsAndSaveUserInfo:userinfo withPhone:userinfo[UPHONE] currentVC:self];
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
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
            viewFrame.origin.y = -height + 170;
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
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = [UIColor customisMainColor];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
