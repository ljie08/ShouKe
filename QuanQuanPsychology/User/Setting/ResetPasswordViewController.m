//
//  ResetPasswordViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/11.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordCell.h"

#import "UserInfoAPI.h"

@interface ResetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UITextField *currentTF;
@property (weak, nonatomic) IBOutlet UITextField *newpTF;
@property (weak, nonatomic) IBOutlet UITextField *surepTF;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (IBAction)submit:(UIButton *)sender {
    
    NSString *message = [self.newpTF.text isOrNoPasswordStyle];
    
    if (![NSString stringIsNull:message]) {
        [self presentAlertWithTitle:message message:@"请重新输入" actionTitle:@"好的"];
        
    } else if (![self.newpTF.text isEqualToString:self.surepTF.text]) {
        
        [self presentAlertWithTitle:@"两次密码不一致" message:@"请重新输入" actionTitle:@"好的"];
        
    } else {
        [UserInfoAPI changePassword:self.currentTF.text withNewPassword:self.newpTF.text andUID:USERUID callback:^(APIReturnState state, id data, NSString *message) {
            if (state == API_SUCCESS) {

                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self presentAlertWithTitle:message message:@"请重新输入" actionTitle:@"好的"];
            }
        }];
    }
}

#pragma mark - textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void)updateUI {
    self.currentTF.delegate = self;
    self.newpTF.delegate = self;
    self.surepTF.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
