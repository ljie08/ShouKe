//
//  LoginPasswdView.m
//  ShouKe
//
//  Created by Libra on 2018/10/9.
//  Copyright © 2018年 Libra. All rights reserved.
//

#import "LoginPasswdView.h"

@interface LoginPasswdView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginPasswdView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.phoneTF.delegate = self;
    self.passwdTF.delegate = self;
    self.loginBtn.backgroundColor = [UIColor colorwithHexString:@"#dcdcdc"];
}

- (IBAction)forgetPasswd:(id)sender {
    if ([self.delegate respondsToSelector:@selector(passwdForget)]) {
        [self.delegate passwdForget];
    }
}

- (IBAction)login:(id)sender {
    if ([self.delegate respondsToSelector:@selector(passwdLogin)]) {
        [self.delegate passwdLogin];
    }
}

#pragma mark - textfiled
- (void)textFieldChangedString:(UITextField *)textField {
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(passwdTFDidEndEditing:)]) {
        [self.delegate passwdTFDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    
    if (newString.length) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = [UIColor customisMainColor];
    } else {
        self.loginBtn.enabled = NO;
        self.loginBtn.backgroundColor = [UIColor colorwithHexString:@"#dcdcdc"];
    }
    if (textField.tag == 60) {
        return (newString.length <= 13);
    } else if (textField.tag == 61) {
        
    }
    return YES;
}

@end
