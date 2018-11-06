//
//  BindingViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/6/1.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BindingViewController.h"
#import "ThirdPartyLoginHelper.h"

#import "UserInfoAPI.h"

@interface BindingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *bindingInfo;

@property (weak, nonatomic) IBOutlet MainGreenButton *bindingBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnT;

@property (strong, nonatomic) UMSocialUserInfoResponse *info;

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUIWithName:self.bindingName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.labelT.constant = ScreenHeight * 0.16;
    self.btnT.constant = ScreenHeight * 0.17;
}

#pragma mark - UI
-(void)updateUIWithName:(NSString *)name{
    
    switch (self.platform) {
        case ThirdPartyPlatformType_Wechat:
        {
            self.title = @"微信绑定";
            
            if (![NSString stringIsNull:name]) {
                self.bindingInfo.text = [NSString stringWithFormat:@"已绑定微信账号：%@",name];
                [self.bindingBtn setTitle:@"更换微信帐号" forState:UIControlStateNormal];
            } else {
                self.bindingInfo.text = @"暂未绑定微信帐号";
                [self.bindingBtn setTitle:@"绑定微信帐号" forState:UIControlStateNormal];
            }
        }
            break;
            
        case ThirdPartyPlatformType_QQ:
        {
            self.title = @"QQ绑定";
            
            if (![NSString stringIsNull:name]) {
                self.bindingInfo.text = [NSString stringWithFormat:@"已绑定QQ账号：%@",name];
                [self.bindingBtn setTitle:@"更换QQ帐号" forState:UIControlStateNormal];
            } else {
                self.bindingInfo.text = @"暂未绑定QQ帐号";
                [self.bindingBtn setTitle:@"绑定QQ帐号" forState:UIControlStateNormal];
            }
        }

            break;
            
        default:
            break;
    }
    
}

#pragma mark - Button Action
- (IBAction)binding:(MainGreenButton *)sender {
    
    ThirdPartyLoginHelper *loginHelper = [[ThirdPartyLoginHelper alloc] init];
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在处理"];
    [self hideHUDAfter:3];
    
    UMSocialPlatformType type;
    NSString *platformType;
    
    switch (self.platform) {
        case ThirdPartyPlatformType_Wechat:
            type = UMSocialPlatformType_WechatSession;
            platformType = @"0";
            break;
            
        case ThirdPartyPlatformType_QQ:
            type = UMSocialPlatformType_QQ;
            platformType = @"1";
            break;
            
        default:
            break;
    }
    
    [loginHelper getAuthWithUserInfoFrom:type success:^(UMSocialUserInfoResponse *result) {
        
        [UserInfoAPI saveSocialPlatformAuthWithUID:USERUID openID:result.openid nickname:result.name photoPath:result.iconurl type:platformType callback:^(APIReturnState state, id data, NSString *message) {
            if (state == API_SUCCESS) {
                
                [self updateUIWithName:result.name];
                self.info = result;
                
            } else {
                [self updateHUDWithMode:MBProgressHUDModeText message:message];
            }
        }];
        
    } failure:^(NSError *error) {
        [self presentAlertWithTitle:@"绑定失败，请重新绑定" message:@"" actionTitle:@"好的"];
    }];
}

-(void)updateBindingInfo:(void (^)(NSString *, ThirdPartyPlatformType))name{
    
    if (self.info == nil) {
        name(self.bindingName,self.platform);
    } else {
        name(self.info.name,self.platform);
    }
}

@end
