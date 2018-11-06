//
//  ChangeUserNameViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/8.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ChangeUserNameViewController.h"
#import "UserInfoAPI.h"
#import "ArchiveHelper.h"


@interface ChangeUserNameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *userName;/* 用户名 */

@end

@implementation ChangeUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改用户名";
    
    /* 添加导航栏按钮 */
    UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem = finish;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
-(void)finishAction{
    
    if (self.userName.text.length != 0) {
        
        [UserInfoAPI changeUserName:self.userName.text withUID:USERUID callback:^(APIReturnState state, id data, NSString *message) {
            if (state == API_SUCCESS) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RenewUserName" object:self.userName];
                UserModel *user = [ArchiveHelper unarchiveModelWithKey:@"userInfo" docePath:@"userInfo"];
                user.userName = self.userName.text;
                [ArchiveHelper archiveModel:user forKey:@"userInfo" docePath:@"userInfo"];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self presentAlertWithTitle:message message:@"请稍后再试" actionTitle:@"确定"];
            }
        }];

    }
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
