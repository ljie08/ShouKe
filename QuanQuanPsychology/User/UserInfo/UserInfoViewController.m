//
//  UserInfoViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/8.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ChangeUserNameViewController.h"
#import "ChangeUserPhoneViewController.h"

#import "UserInfoAPI.h"

#import "PortraitCell.h"
#import "ArchiveHelper.h"

@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UserModel *userInfo;

@property (strong, nonatomic) UIImage *portrait;

@property (strong, nonatomic) NSString *userName;/* 用户名 */
@property (strong, nonatomic) NSString *userPhone;/* 手机 */
@property (strong, nonatomic) NSString *userEmail;/* 邮箱 */


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUI];
    
    self.userInfo = [ArchiveHelper unarchiveModelWithKey:@"userInfo" docePath:@"userInfo"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePortrait" object:self.userInfo.portrait];
    
    /* 通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewUserName:) name:@"RenewUserName" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewEmailAddress:) name:@"RenewEmailAddress" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewUserIntroduce:) name:@"RenewUserIntroduce" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
-(void)updateUI{
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, -0.1)];
    self.tableView.backgroundColor = [UIColor colorwithHexString:@"#f9faff"];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

#pragma mark - Data
-(void)fetchData{
    
    [UserInfoAPI fetchUserInfoByUID:USERUID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSDictionary *list = dict[USERINFO];
            [self saveUserInfo:list];
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

-(void)saveUserInfo:(NSDictionary *)list{
    
    UserModel *user = [[UserModel alloc] init];

    user.uid = list[UID];
    user.phone = list[UPHONE];
    user.userName = list[UNAME];
    user.email = list[EMAIL];
    user.introduce = list[INTRODUCE];

    NSString *portraitPath = list[AVATAR];
    if ([NSString stringIsNull:portraitPath]) {
        portraitPath = @"null";
    }
    user.portrait = portraitPath;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:user.portrait forKey:UDPORTRAIT];
    [userDefaults setValue:user.uid forKey:UDUID];

    [userDefaults synchronize];

    [ArchiveHelper archiveModel:user forKey:@"userInfo" docePath:@"userInfo"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePortrait" object:self.userInfo.portrait];
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *portraitIdentifier = @"PortraitCell";
    static NSString *nameIdentifier = @"UserNameCell";
    static NSString *introduceIdentifier = @"UserIntroduceCell";
    
    PortraitCell *portraitCell = [tableView dequeueReusableCellWithIdentifier:portraitIdentifier];
    UITableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:nameIdentifier];
    UITableViewCell *introduceCell = [tableView dequeueReusableCellWithIdentifier:introduceIdentifier];
    
    /* cell 选中无颜色 */
    portraitCell.selectionStyle = UITableViewCellSelectionStyleNone;
    nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    introduceCell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSArray *items = @[@"头像",@"我的昵称", @"我的简介"];
    
    if (indexPath.row == 0) {
        
        portraitCell.item.text = items[indexPath.row];
        
        if (self.portrait) {
            portraitCell.portrait.image = self.portrait;
        } else {

            [portraitCell.portrait sd_setImageWithURL:[QuanUtils fullImagePath:self.userInfo.portrait] placeholderImage:[UIImage imageNamed:@"default_avater"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [QuanUtils clipViewCornerRadius:portraitCell.portrait.frame.size.height / 2 withImage:portraitCell.portrait.image andImageView:portraitCell.portrait];
            }];
        }
        
        [QuanUtils clipViewCornerRadius:portraitCell.portrait.frame.size.height / 2 withImage:portraitCell.portrait.image andImageView:portraitCell.portrait];
        
        
        return portraitCell;
        
    } else if (indexPath.row == 1) {
        
        nameCell.textLabel.text = items[indexPath.row];
        
        if ([NSString stringIsNull:self.userInfo.userName]) {
            nameCell.detailTextLabel.text = @"";
        } else {
            nameCell.detailTextLabel.text = self.userInfo.userName;
        }
        
        return nameCell;
    } else {
        introduceCell.textLabel.text = items[indexPath.row];
        
        if ([NSString stringIsNull:self.userInfo.introduce]) {
            introduceCell.detailTextLabel.text = @"";
        } else {
            introduceCell.detailTextLabel.text = self.userInfo.introduce;
        }
        
        return introduceCell;
    }

}

#pragma mark - <UITableViewDelegate>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        [self initImagePicker];
        
        __weak UserInfoViewController *weakSelf = self;
        
        self.updateCallback = ^(BOOL success, UIImage *image) {
            if (success) {
                weakSelf.portrait = image;
                [weakSelf.tableView reloadData];
                [weakSelf fetchData];
            }
        };
        
    } else if (indexPath.row == 1){
        
        [self performSegueWithIdentifier:@"ChangeUserName" sender:self];
        
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"ChangeUserIntroduce" sender:self];
    }
    
//    else if (indexPath.row == 2) {
//
//        [self performSegueWithIdentifier:@"ChangeUserPhone" sender:self];
//
//    } else if (indexPath.row == 3) {
//
//        [self performSegueWithIdentifier:@"UserMailbox" sender:self];
//
//    }

}

#pragma mark - Notification
-(void)renewUserName:(NSNotification *)noti{
    
    UITextField *textField = noti.object;
    
    self.userInfo.userName = textField.text;
    
    [self.tableView reloadData];
    
    [self fetchData];

}

-(void)renewEmailAddress:(NSNotification *)noti{
    
    UITextField *textField = noti.object;
    self.userInfo.email = textField.text ;
    
    [self.tableView reloadData];
    
    [self fetchData];

}

- (void)renewUserIntroduce:(NSNotification *)noti {
    UITextView *textview = noti.object;
    self.userInfo.introduce = textview.text;
    [self.tableView reloadData];
    
    [self fetchData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ChangeUserPhone"]) {
        ChangeUserPhoneViewController *changeVC = segue.destinationViewController;
        changeVC.userPhone = self.userInfo.phone;
    }
}


@end
