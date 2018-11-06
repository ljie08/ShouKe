//
//  SettingViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/8.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "SettingViewController.h"
#import "ChooseViewController.h"
#import "AboutAppViewController.h"
#import "ChangeUserPhoneViewController.h"
#import "BindingViewController.h"

#import "UserInfoAPI.h"

#import "JPUSHService.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet MainGreenButton *quitBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableH;

@property (copy, nonatomic) NSString *wechatName;

@property (copy, nonatomic) NSString *qqName;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewPhoneNumber:) name:@"RenewPhoneNumber" object:nil];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self getWechatInfo];
    [self getQQInfo];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    if (IS_IPHONE5 || IS_IPHONE4S) {
        self.tableH.constant = ScreenHeight - NavHeight - StatusHeight - 100;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - API
-(void)getWechatInfo{
    [self getSocialAuthInfoWithType:@"0"];
}

-(void)getQQInfo{
    [self getSocialAuthInfoWithType:@"1"];
}

-(void)getSocialAuthInfoWithType:(NSString *)type{
    
    [UserInfoAPI getSocialAuthInfoWithUID:USERUID type:type callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            [self hideHUD];
            NSDictionary *dict = (NSDictionary *)data;
            NSDictionary *userInfo = dict[USERINFO];
            NSString *name = userInfo[UNAME];
            
            if ([type isEqualToString:@"0"]) {
                self.wechatName = name;
            } else {
                self.qqName = name;
            }
            
            [self.tableView reloadData];
            
        } else {
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 4;
            break;
            
        case 1:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *settingIdentifier = @"SettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingIdentifier];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.detailTextLabel.hidden = YES;

    
    NSArray *items = @[@[@"修改密码",@"修改手机号",@"微信绑定设置",@"QQ绑定设置"],@[@"给个好评",@"关于知邻"]];
    
    cell.textLabel.text = items[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.text = USERPHONE;
        } else if (indexPath.row == 2) {
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.text = self.wechatName;
        } else if (indexPath.row == 3) {
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.text = self.qqName;
        }
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"ResetPassword" sender:self];
                break;
                
            case 1:
                [self performSegueWithIdentifier:@"ChangeUserPhone" sender:self];
                break;
                
            case 2:
                [self performSegueWithIdentifier:@"BindingInfo" sender:@"wechat"];
                break;
                
            case 3:
                [self performSegueWithIdentifier:@"BindingInfo" sender:@"qq"];
                break;
                
        }
        
    } else {
        
        switch (indexPath.row) {
                
            case 0:
                [QuanUtils openScheme:@"itms-apps://itunes.apple.com/app/id1409991705"];
                break;
            
            case 1:
                [self performSegueWithIdentifier:@"AboutApp" sender:self];
                break;
                
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.0;

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    return [[UIView alloc] init];
}

#pragma mark - Notification
-(void)renewPhoneNumber:(NSNotification *)noti{
    
//    NSString *phoneNumber = noti.object;
    
//    self.userInfo.phone = phoneNumber;
    
    [self.tableView reloadData];
}

#pragma mark - Button Action
- (IBAction)quitApp:(UIButton *)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:UDPHONE];
    [userDefaults removeObjectForKey:UDUID];
    [userDefaults removeObjectForKey:UDSINGLESIGNONUUID];
    [userDefaults synchronize];
    
    [self deleteJPushAlias];
    
    UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];
    UINavigationController *nav = [registerSB instantiateViewControllerWithIdentifier:@"NavigationChooseController"];

    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark - JPush
-(void)deleteJPushAlias{
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"退出登录");
    } seq:0];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"AboutApp"]) {
        AboutAppViewController *appVC = segue.destinationViewController;
        appVC.navTitle = @"关于知邻";
        appVC.content = @"“知邻”APP 是华东人才教育集团独创的在线心理学习平台，继承了集团在传统教 育行业长达十五年的心理培训经验和授课精华。\n“知邻”APP 具备自主题库研发团队，使用题库知识卡片式学习和预估考分模型， 改进传统枯燥的线性学习方法，以自适应学习结合人工智能开启了全新的学习体验！\n无需万元学费，无需大量时间，更不要堆聚如山教辅资料；有效利用碎片化时间，聚沙成塔， 打造更强大的记忆方式，开启更高效的学习模式。不论学生、家长、职场白领，0 基础或者 专业人士均可轻松在线学习心理学！";
    }
    
    if ([segue.identifier isEqualToString:@"ChangeUserPhone"]) {
        ChangeUserPhoneViewController *changeVC = segue.destinationViewController;
        changeVC.userPhone = USERPHONE;
    }
    
    if ([segue.identifier isEqualToString:@"BindingInfo"]) {
        BindingViewController *bindingVC = segue.destinationViewController;
        
        if ([sender isEqualToString:@"wechat"]) {
            bindingVC.platform = ThirdPartyPlatformType_Wechat;
            bindingVC.bindingName = self.wechatName;
        } else if ([sender isEqualToString:@"qq"]){
            bindingVC.platform = ThirdPartyPlatformType_QQ;
            bindingVC.bindingName = self.qqName;
        }
        
        [bindingVC updateBindingInfo:^(NSString *name, ThirdPartyPlatformType platform) {
            if (platform == ThirdPartyPlatformType_Wechat) {
                self.wechatName = name;
            } else {
                self.qqName = name;
            }
            
            [self.tableView reloadData];
        }];
    }
}


@end
