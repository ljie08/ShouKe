//
//  QuickLoginView.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/17.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginDelegate.h"

#import "PhoneTextField.h"

@interface QuickLoginView : UIView

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

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forPadding;

@property (weak, nonatomic) id<LoginDelegate>delegate;

-(void)updatePhoneView;
-(void)updatePhoneWarning:(NSString *)string;
-(void)updateVerifyCodeView;
-(void)updateVerifyBtnView;
-(void)updateVerifyCodeWarning:(NSString *)string;

@end
