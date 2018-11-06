//
//  RegisterView.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/16.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "RegisterView.h"

@interface RegisterView()


@end

@implementation RegisterView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"RegisterView" owner:self options:nil];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.view.frame = CGRectMake(0, 0, (width-40) * 0.8+15, 155);
//        self.layer.masksToBounds = YES;
        
        [self addSubview:self.view];
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.phoneWarning.hidden = YES;
    self.verifyCodeWarning.hidden = YES;
    self.passwordWarning.hidden = YES;
    
    self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写手机号" attributes:@{NSForegroundColorAttributeName:[UIColor colorwithHexString:@"#BFBFBF"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    self.verifyCodeTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor colorwithHexString:@"#BFBFBF"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    self.passwordTF.secureTextEntry = YES;
    
    self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请设置密码（8-20位字母数字组合）" attributes:@{NSForegroundColorAttributeName:[UIColor colorwithHexString:@"#BFBFBF"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
}

- (IBAction)getVerifyCode:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(verifyCodeClicked:)]) {
        [_delegate verifyCodeClicked:sender];
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

-(void)updatePasswordView{
    self.passwordIcon.image = [UIImage imageNamed:@"login_password_action"];
    self.passwordLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
}

-(void)updatePasswordWarning:(NSString *)string{
    self.passwordWarning.text = string;
    self.passwordWarning.hidden = NO;
}


@end
