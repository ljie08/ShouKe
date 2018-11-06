//
//  RegisterView.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/16.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneTextField.h"

@protocol RegisterViewDelegate<NSObject>

-(void)verifyCodeClicked:(UIButton *)button;

@end

@interface RegisterView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;

@property (weak, nonatomic) IBOutlet PhoneTextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIView *phoneLine;

@property (weak, nonatomic) IBOutlet UILabel *phoneWarning;

@property (weak, nonatomic) IBOutlet UIImageView *verifyCodeIcon;

@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;

@property (weak, nonatomic) IBOutlet UIView *verifyCodeLine;

@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;

@property (weak, nonatomic) IBOutlet UIView *getVerifyCodeLine;

@property (weak, nonatomic) IBOutlet UILabel *verifyCodeWarning;

@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIView *passwordLine;

@property (weak, nonatomic) IBOutlet UILabel *passwordWarning;

- (IBAction)getVerifyCode:(UIButton *)sender;

@property (weak, nonatomic) id<RegisterViewDelegate>delegate;

-(void)updatePhoneView;
-(void)updatePhoneWarning:(NSString *)string;
-(void)updateVerifyCodeView;
-(void)updateVerifyBtnView;
-(void)updateVerifyCodeWarning:(NSString *)string;
-(void)updatePasswordView;
-(void)updatePasswordWarning:(NSString *)string;

@end
