//
//  RetrievePasswordViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/3.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//


//找回(忘记)密码

#import "RetrievePasswordViewController.h"
#import "LoginViewController.h"
#import "CourseSelectionViewController.h"

#import "RegisterView.h"
#import "LoginAPI.h"
#import "CountDownTimer.h"

#import "UITextField+TextFormat.h"

#import "CountDownBtn.h"
#import "ResetViewController.h"//重置密码

@interface RetrievePasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet PhoneNumTextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet CountDownBtn *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation RetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark - action
//确定按钮点击
- (IBAction)sureAction:(id)sender {
    if ([NSString stringIsNull:self.phoneTF.text] || self.phoneTF.text.length < 11) {
        [self showMassage:@"请输入11位手机号"];
        return;
    }
    if ([NSString stringIsNull:self.codeTF.text] || self.codeTF.text.length<=0) {
        [self showMassage:@"请输入验证码"];
        return;
    }
    
//    UIStoryboard *userSB = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
//    ResetPasswordViewController *reset = [userSB instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
    
    ResetViewController *reset = [[ResetViewController alloc] init];
    reset.phone = self.phoneTF.text;
    reset.code = self.codeTF.text;
    [self.navigationController pushViewController:reset animated:YES];
}

//验证码按钮点击
- (void)codeAction{
    NSString *phone = [self.phoneTF.text noneSpaseString];
    
    BOOL isNumber = [phone validateNumber];
    
    if (isNumber) {
        [self hasRegisterPhone:phone];
    } else {
        [self showMassage:@"请输入11位手机号"];
    }
}

#pragma mark - API
//获取验证码前先判断手机号是否注册过
-(void)hasRegisterPhone:(NSString *)phone{
    [LoginAPI hasRegisterPhone:phone callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            BOOL hasRegister = [dict[@"flag"] boolValue];
            if (hasRegister) {
                [self.codeBtn setTitle:[NSString stringWithFormat:@"59s后重试"] forState:UIControlStateNormal];
                [self.codeBtn beginCountDown];
                [self getVerifyCodeByPhone:phone];
            } else {
                self.codeBtn.enabled = YES;
                [self showMassage:@"该手机号未注册"];
            }
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

//获取验证码
-(void)getVerifyCodeByPhone:(NSString *)phone{
    
    [LoginAPI getVerifyCodeWithPhone:phone callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            [self showMassage:@"发送成功"];
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

#pragma mark - UI
- (void)updateUI {
    self.phoneTF.delegate = self;
    self.codeTF.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupBtn];
}

- (void)setupBtn {
    self.codeBtn.countNum = 59;
//    self.codeBtn.bgColor = [UIColor redColor];
//    self.codeBtn.disabledBgColor = [UIColor lightGrayColor];
    self.codeBtn.fontSize = 14;
    [self.codeBtn initDefault];
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    __weak CountDownBtn *mybtn = self.codeBtn;
    self.codeBtn.btnBlock = ^{
//        [mybtn setTitle:[NSString stringWithFormat:@"59s后重试"] forState:UIControlStateNormal];
//        [mybtn beginCountDown];
        [self codeAction];
    };
    self.codeBtn.countdowningBlock = ^(NSInteger countdown) {
        [mybtn setTitle:[NSString stringWithFormat:@"%lds后重试", countdown] forState:UIControlStateNormal];
    };
    self.codeBtn.completionBlock = ^{
        [mybtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Notification
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification{
    
    if (IS_IPHONE4S) {
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
    
}

/* 当用户按下return键或者按回车键，keyboard消失 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (IS_IPHONE4S) {
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
