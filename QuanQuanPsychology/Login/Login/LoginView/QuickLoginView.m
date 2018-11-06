//
//  QuickLoginView.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/17.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "QuickLoginView.h"

@implementation QuickLoginView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.phoneWarning.hidden = YES;
    self.verifyCodeWarning.hidden = YES;
    
    self.loginBtn.layer.cornerRadius = 20;
    
//    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.loginBtn setTitleColor:[UIColor colorwithHexString:@"8D8D8D"] forState:UIControlStateDisabled];
    
    self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写手机号" attributes:@{NSForegroundColorAttributeName:[UIColor colorwithHexString:@"#BFBFBF"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    self.verifyCodeTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor colorwithHexString:@"#BFBFBF"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    self.forPadding.constant = 20*Width_Scale;
}

- (IBAction)getVerify:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(verifyCodeClicked:)]) {
        [_delegate verifyCodeClicked:sender];
    }
}

- (IBAction)quickLogin:(id)sender {
    if ([_delegate respondsToSelector:@selector(loginClicked:)]) {
        [_delegate loginClicked:sender];
    }
}

- (IBAction)registerByPhone:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(registerByPhoneClicked:)]) {
        [_delegate registerByPhoneClicked:sender];
    }
}

- (IBAction)forget:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(registerByPhoneClicked:)]) {
        [_delegate registerByPhoneClicked:sender];
    }
}

-(void)updatePhoneView{
    self.phoneIcon.image = [UIImage imageNamed:@"login_phone_action"];
    self.phoneLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
}

-(void)updatePhoneWarning:(NSString *)string{
    self.phoneWarning.text = string;
    self.phoneWarning.hidden = NO;
}

-(void)updateVerifyCodeView{
    self.verifyCodeIcon.image = [UIImage imageNamed:@"login_verifycode_action"];
    self.verifyCodeLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
}

-(void)updateVerifyBtnView{
    [self.verifyCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.getVerifyCodeLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
}

-(void)updateVerifyCodeWarning:(NSString *)string{
    self.verifyCodeWarning.text = string;
    self.verifyCodeWarning.hidden = NO;
}

@end
