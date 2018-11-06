//
//  PasswordLoginView.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/17.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "PasswordLoginView.h"

@implementation PasswordLoginView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];

    self.phoneWarning.hidden = YES;
    self.passwordWarning.hidden = YES;
    self.loginBtn.layer.cornerRadius = 20;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorwithHexString:@"8D8D8D"] forState:UIControlStateDisabled];

    self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写手机号" attributes:@{NSForegroundColorAttributeName:[UIColor colorwithHexString:@"#BFBFBF"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor colorwithHexString:@"#BFBFBF"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    self.forgetPadding.constant = 20*Width_Scale;
}

-(void)updatePhoneView{
    self.phoneIcon.image = [UIImage imageNamed:@"login_phone_action"];
    self.phoneLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
}

-(void)updatePhoneWarning:(NSString *)string{
    self.phoneWarning.text = string;
    self.phoneWarning.hidden = NO;
}

-(void)updatePasswordView{
    self.passwordIcon.image = [UIImage imageNamed:@"login_password_action"];
    self.passwordLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
}

-(void)updatePasswordWarning:(NSString *)string{
    self.passwordWarning.text = string;
    self.passwordWarning.hidden = NO;
}

- (IBAction)passLogin:(id)sender {
    if ([_delegate respondsToSelector:@selector(loginClicked:)]) {
        [_delegate loginClicked:sender];
    }
}

- (IBAction)forgetPassword:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(forgetPasswordClicked:)]) {
        [_delegate forgetPasswordClicked:sender];
    }
}

- (IBAction)registerByPhone:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(registerByPhoneClicked:)]) {
        [_delegate registerByPhoneClicked:sender];
    }
}
@end
