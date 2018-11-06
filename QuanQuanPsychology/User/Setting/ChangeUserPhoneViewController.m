//
//  ChangeUserPhoneViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/8.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ChangeUserPhoneViewController.h"
#import "SettingViewController.h"

#import "LoginAPI.h"
#import "UserInfoAPI.h"

#import "QuickLoginView.h"
#import "CountDownTimer.h"
#import "ArchiveHelper.h"


@interface ChangeUserPhoneViewController ()<UITextFieldDelegate,LoginDelegate>

@property (weak, nonatomic) IBOutlet UIView *basicView;

@property (strong, nonatomic) IBOutlet QuickLoginView *changePhoneView;

@property (strong, nonatomic) CountDownTimer *timer;/* 倒计时 */

@property (assign, nonatomic) BOOL phonePress;

@property (assign, nonatomic) BOOL passwordPress;


@end

@implementation ChangeUserPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

-(void)dealloc{
    [self.timer invalidate];
}

#pragma mark - UI
-(void)updateUI{
    
    self.changePhoneView.loginBtn.enabled = NO;
    self.changePhoneView.phoneTF.delegate = self;
    self.changePhoneView.verifyCodeTF.delegate = self;
    self.changePhoneView.delegate = self;
    
//    self.changePhoneView.phoneRegisterBtn.hidden = YES;
    
    self.changePhoneView.frame = CGRectMake(0, 0, ScreenWidth * 0.8, 200);

    self.basicView.backgroundColor = [UIColor clearColor];
    [self.basicView addSubview:self.changePhoneView];
    
    if (self.updateNewPhone) {
        self.title = @"绑定新手机";
        [self.changePhoneView.loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        self.title = @"解绑旧手机";
        self.changePhoneView.phoneTF.text = USERPHONE;
        self.changePhoneView.phoneTF.enabled = NO;
        self.phonePress = YES;
        [self.changePhoneView updatePhoneView];
        [self.changePhoneView updateVerifyBtnView];
        [self.changePhoneView.loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
}

#pragma mark - <LoginDelegate>
-(void)loginClicked:(UIButton *)button{
    
    NSString *phone = [self noneSpaseString:self.changePhoneView.phoneTF.text];
    NSString *verifyCode = self.changePhoneView.verifyCodeTF.text;
    
    if ([NSString stringIsNull:phone]) {
        [self.changePhoneView updatePhoneWarning:@"请输入手机号"];
    } else if ([NSString stringIsNull:verifyCode]){
        [self.changePhoneView updateVerifyCodeWarning:@"请输入验证码"];
    } else {
        
        if (self.updateNewPhone) {
            
            [UserInfoAPI changePhoneWithUID:USERUID newPhone:phone verifyCode:verifyCode callback:^(APIReturnState state, id data, NSString *message) {
                if (state == API_SUCCESS) {
                    [self.timer invalidate];

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RenewPhoneNumber" object:phone];
                    UserModel *user = [ArchiveHelper unarchiveModelWithKey:@"userInfo" docePath:@"userInfo"];
                    user.phone = phone;
                    [ArchiveHelper archiveModel:user forKey:@"userInfo" docePath:@"userInfo"];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setValue:phone forKey:UDPHONE];
                    [userDefaults synchronize];
                    
                    
                    [self backToUserInfo];
                } else {
                    [self presentAlertWithTitle:message message:@"" actionTitle:@"确定"];
                }
            }];
            
        } else {
            
            [LoginAPI verifyWithPhone:phone verifyCode:verifyCode callback:^(APIReturnState state, id data, NSString *message) {
                if (state == API_SUCCESS) {
                    [self.timer invalidate];
                    
                    UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
                    
                    ChangeUserPhoneViewController *newPhoneVC = [user instantiateViewControllerWithIdentifier:@"ChangeUserPhoneViewController"];
                    
                    newPhoneVC.updateNewPhone = YES;
                    
                    [self.navigationController pushViewController:newPhoneVC animated:YES];
                } else {
                    [self presentAlertWithTitle:message message:@"" actionTitle:@"好的"];
                }
            }];
        }
        
    }
    
    
    
}

-(void)verifyCodeClicked:(UIButton *)button{
    
    self.changePhoneView.verifyCodeBtn.userInteractionEnabled = NO;
    
    NSString *phone = [self noneSpaseString:self.changePhoneView.phoneTF.text];
    
    BOOL isNumber = [phone validateNumber];
    
    if (isNumber) {
        
        [LoginAPI getVerifyCodeWithPhone:phone callback:^(APIReturnState state, id data, NSString *message) {
            if (state == API_SUCCESS) {
                [self initTimer];
                [self.changePhoneView updatePhoneWarning:@""];
            } else {
                [self.changePhoneView updateVerifyCodeWarning:message];
                
            }
        }];
        
    } else {
        
        [self.changePhoneView updatePhoneWarning:@"请输入11位手机号"];
        self.changePhoneView.verifyCodeBtn.userInteractionEnabled = YES;
        
    }
}

/* 返回系统设置控制器 */
-(void)backToUserInfo{
    
    UINavigationController *navigationVC = self.navigationController;
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    /* 遍历导航控制器中的控制器 */
    for (UIViewController *vc in navigationVC.viewControllers) {
        
        [viewControllers addObject:vc];
        
        if ([vc isKindOfClass:[SettingViewController class]]) {
            break;
        }
    }
    
    /* 把控制器重新添加到导航控制器 */
    [navigationVC setViewControllers:viewControllers animated:YES];
}

-(void)initTimer{
    
    self.timer = [[CountDownTimer alloc] initWithTimeInterval:1.0 totalTime:60];
    self.timer.delegate = self;
}

-(void)timeLeft:(NSString *)seconds{
    [self.changePhoneView.verifyCodeBtn setTitle:seconds forState:UIControlStateNormal];
}

-(void)timeIsUp{
    [self.changePhoneView.verifyCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
    self.changePhoneView.verifyCodeBtn.userInteractionEnabled = YES;
}

#pragma mark - <UITextFieldDelegate>
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.changePhoneView.phoneTF) {
        [self.changePhoneView updatePhoneView];
        [self.changePhoneView updateVerifyBtnView];
        self.phonePress = YES;
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    
    if (textField == self.changePhoneView.verifyCodeTF) {
        [self.changePhoneView updateVerifyCodeView];
        self.passwordPress = YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    
    if (self.phonePress && self.passwordPress) {
        self.changePhoneView.loginBtn.enabled = YES;
        self.changePhoneView.loginBtn.backgroundColor = [UIColor customisMainColor];
        
    }
    
}

/* 输入框3-4-4输入格式 */
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //    NSLog(@"%@",NSStringFromRange(range));
    if (textField == self.changePhoneView.phoneTF) {
        [self.changePhoneView updatePhoneWarning:@""];
        NSString *text = textField.text;
        //删除
        if([string isEqualToString:@""]){
            
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length-1 ) {
                    if ([text characterAtIndex:text.length-1] == ' ') {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self parseString:textField.text];
                
                NSInteger offset = range.location;
                if (range.location == 3 || range.location  == 8) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        
        else if(string.length >0){
            
            //限制输入字符个数
            if (([self noneSpaseString:textField.text].length + string.length - range.length > 11) ) {
                return NO;
            }
            //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
            //                        if(![string isNum]){
            //                            return NO;
            //                        }
            [textField insertText:string];
            textField.text = [self parseString:textField.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
        
    }
    
    if (textField == self.changePhoneView.verifyCodeTF) {
        [self.changePhoneView updateVerifyCodeWarning:@""];
    }
    
    
    return YES;
}

/* 去除空格 */
-(NSString*)noneSpaseString:(NSString*)string{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/* 插入空格 */
-(NSString*)parseString:(NSString*)string{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length >3) {
        [mStr insertString:@" " atIndex:3];
    }if (mStr.length > 8) {
        [mStr insertString:@" " atIndex:8];
        
    }
    
    return  mStr;
}

/* 当用户按下return键或者按回车键，keyboard消失 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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
