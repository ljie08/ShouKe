//
//  ResetViewController.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/11/2.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//


//忘记密码 ----> 重置密码
#import "ResetViewController.h"
#import "ReSetAlertView.h"
#import "LoginAPI.h"
#import "LoginViewController.h"

@interface ResetViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *npsTF;
@property (weak, nonatomic) IBOutlet UITextField *sureTF;
@property (nonatomic, strong) ReSetAlertView *alertView;/**< <#注释#> */

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)resetPasswdAction:(id)sender {
    if (!self.npsTF.text) {
        [self showMassage:@"请输入新密码"];
        return;
    }
    if (!self.sureTF.text || ![self.npsTF.text isEqualToString:self.sureTF.text]) {
        [self showMassage:@"两次输入密码不同，请重新输入"];
        return;
    }
    
    [self resetPasswdData];
}

//修改密码接口
- (void)resetPasswdData {
    weakSelf(self);
    [self showWaiting];
    self.phone = [self.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    [LoginAPI resetPasswordWithPhone:self.phone andPassword:self.npsTF.text verifyCode:self.code callback:^(APIReturnState state, id data, NSString *message) {
        [weakSelf hideWaiting];
        
        if (state == API_SUCCESS) {
            [weakSelf setupAlertView];
        } else {
            [weakSelf showMassage:message];
        }
    }];
}

- (void)enterAPP {
    UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];
    
    LoginViewController *loginVC = [registerSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.npsTF resignFirstResponder];
    [self.sureTF resignFirstResponder];
}

#pragma mark - ui
- (void)updateUI {
//    [self setBackButton:YES];
    self.npsTF.delegate = self;
    self.sureTF.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
}

- (void)setupAlertView {
    if (!self.alertView) {
        self.alertView = [[NSBundle mainBundle] loadNibNamed:@"ReSetAlertView" owner:self options:nil].firstObject;
        self.alertView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    weakSelf(self);
    self.alertView.loginBlock = ^{
        [UIView animateWithDuration:1 animations:^{
            [weakSelf.alertView removeFromSuperview];
        }];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
}

@end
