//
//  LoginPasswdView.h
//  ShouKe
//
//  Created by Libra on 2018/10/9.
//  Copyright © 2018年 Libra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginPasswdDelegate <NSObject>

- (void)passwdLogin;
- (void)passwdForget;
//- (void)passwdTFDidBeginEditing:(UITextField *)textField;
- (void)passwdTFDidEndEditing:(UITextField *)textField;

@end

@interface LoginPasswdView : UIView

@property (weak, nonatomic) IBOutlet PhoneNumTextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwdTF;

@property (nonatomic, weak) id <LoginPasswdDelegate> delegate;/**< <#注释#> */

@end
