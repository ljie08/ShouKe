//
//  LoginFastView.m
//  ShouKe
//
//  Created by Libra on 2018/10/9.
//  Copyright © 2018年 Libra. All rights reserved.
//

#import "LoginFastView.h"

@interface LoginFastView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *hintLab;

@end

@implementation LoginFastView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.phoneTF.delegate = self;
    self.codeBtn.enabled = NO;
    self.codeBtn.backgroundColor = [UIColor colorwithHexString:@"#dcdcdc"];
}

- (IBAction)getCode:(id)sender {
    if ([self.delegate respondsToSelector:@selector(getFastCode)]) {
        [self.delegate getFastCode];
    }
}

#pragma mark - text
- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    self.hintLab.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(fastTFDidBeginEditing:)]) {
        [self.delegate fastTFDidBeginEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (newString.length) {
        self.hintLab.hidden = YES;
        self.codeBtn.enabled = YES;
        self.codeBtn.backgroundColor = [UIColor customisMainColor];
    } else {
        self.hintLab.hidden = NO;
        self.codeBtn.enabled = NO;
        self.codeBtn.backgroundColor = [UIColor colorwithHexString:@"#dcdcdc"];
    }
    return (newString.length <= 13);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.text.length) {
        self.hintLab.hidden = NO;
        self.codeBtn.enabled = NO;
        self.codeBtn.backgroundColor = [UIColor colorwithHexString:@"#dcdcdc"];
    } else {
        self.hintLab.hidden = YES;
        self.codeBtn.enabled = YES;
        self.codeBtn.backgroundColor = [UIColor customisMainColor];
    }
    if ([self.delegate respondsToSelector:@selector(fastTFDidEndEditing:)]) {
        [self.delegate fastTFDidEndEditing:textField];
    }
}

@end
