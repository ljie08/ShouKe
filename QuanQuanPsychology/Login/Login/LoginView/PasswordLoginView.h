//
//  PasswordLoginView.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/17.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginDelegate.h"

#import "PhoneTextField.h"

@interface PasswordLoginView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;

@property (weak, nonatomic) IBOutlet PhoneTextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIView *phoneLine;

@property (weak, nonatomic) IBOutlet UILabel *phoneWarning;

@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIView *passwordLine;

@property (weak, nonatomic) IBOutlet UILabel *passwordWarning;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

@property (weak, nonatomic) IBOutlet UIButton *phoneRegisterBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetPadding;

@property (weak, nonatomic) id<LoginDelegate>delegate;

-(void)updatePhoneView;
-(void)updatePhoneWarning:(NSString *)string;
-(void)updatePasswordView;
-(void)updatePasswordWarning:(NSString *)string;


@end
