//
//  VerificationCodeViewController.m
//  ShouKe
//
//  Created by Libra on 2018/10/10.
//  Copyright © 2018年 Libra. All rights reserved.
//

#import "VerificationCodeViewController.h"
#import "CountDownBtn.h"
//#import "MQVerCodeInputView.h"
#import "CodeTextView.h"
#import "LoginAPI.h"
#import "EnterAppHelper.h"

@interface VerificationCodeViewController ()

@property (weak, nonatomic) IBOutlet CountDownBtn *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet CodeTextView *codeTextView;

@end

@implementation VerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.codeView.maxLenght = 6;
//    self.codeView.keyBoardType = UIKeyboardTypeNumberPad;
//    [self.codeView mq_verCodeViewWithMaxLenght];
//    self.codeView.block = ^(NSString *text) {
//        NSLog(@"code %@", text);
//    };    
    self.codeTextView.codeLength = 6;
    weakSelf(self);
    self.codeTextView.codeBlock = ^(NSString *code) {
        [weakSelf loginWithCode:code];
    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.codeBtn endCountDown];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.codeBtn setTitle:[NSString stringWithFormat:@"59s后可重新获取"] forState:UIControlStateNormal];
    [self.codeBtn beginCountDown];
    self.phoneNumLab.text = self.phoneNum;
    
    [self getCodeData];
}

- (void)getCodeData {
    NSString *phone = [self.phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isNumber = [phone validateNumber];
    
    if (isNumber) {
        [self showWaiting];
        [LoginAPI getVerifyCodeWithPhone:phone callback:^(APIReturnState state, id data, NSString *message) {
            [self hideWaiting];
            if (state == API_SUCCESS) {
                [self showMassage:@"验证码发送成功"];
            } else {
                [self showMassage:message];
            }
        }];
        
    } else {
        [self showMassage:@"请输入11位手机号"];
    }
}

- (void)loginWithCode:(NSString *)code {
    NSLog(@"login - 00000");
    self.phoneNum = [self.phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self showWaiting];
    weakSelf(self);
    [LoginAPI loginWithPhone:self.phoneNum andPassword:code loginType:@"1" callback:^(APIReturnState state, id data, NSString *message) {
        [weakSelf hideWaiting];
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            
            NSDictionary *userInfo = dict[USERINFO];
            
            EnterAppHelper *helper = [[EnterAppHelper alloc] init];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [helper setUserDefaultsAndSaveUserInfo:userInfo withPhone:weakSelf.phoneNum currentVC:weakSelf];
            });
            
        } else {
            [weakSelf showMassage:message];
        }
    }];
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    UITextView *textview = [self.view viewWithTag:1111];
    [textview resignFirstResponder];
}

#pragma mark - ui
- (void)initUIView {
//    [self setBackButton:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBtn];
    
    //
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
}

- (void)setupBtn {
    self.codeBtn.countNum = 59;
    self.codeBtn.bgColor = [UIColor clearColor];
    self.codeBtn.disabledBgColor = [UIColor clearColor];
    self.codeBtn.fontSize = 13;
    [self.codeBtn initDefault];
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    __weak CountDownBtn *mybtn = self.codeBtn;
    weakSelf(self);
    self.codeBtn.btnBlock = ^{
        [mybtn setTitle:[NSString stringWithFormat:@"59s后可重新获取"] forState:UIControlStateNormal];
        [mybtn beginCountDown];
        
        [weakSelf getCodeData];
    };
    self.codeBtn.countdowningBlock = ^(NSInteger countdown) {
        [mybtn setTitle:[NSString stringWithFormat:@"%lds后可重新获取", countdown] forState:UIControlStateNormal];
    };
    self.codeBtn.completionBlock = ^{
        [mybtn setTitle:@"重新获取短信验证码" forState:UIControlStateNormal];
    };
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

@end
