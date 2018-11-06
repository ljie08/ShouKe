//
//  LoginFastView.h
//  ShouKe
//
//  Created by Libra on 2018/10/9.
//  Copyright © 2018年 Libra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginFastDelegate <NSObject>

- (void)getFastCode;
- (void)fastTFDidBeginEditing:(UITextField *)textField;
- (void)fastTFDidEndEditing:(UITextField *)textField;

@end

@interface LoginFastView : UIView

@property (weak, nonatomic) IBOutlet PhoneNumTextField *phoneTF;
@property (nonatomic, weak) id <LoginFastDelegate> delegate;/**< <#注释#> */

@end
