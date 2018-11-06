//
//  QQBasicViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/10/12.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "QQBasicViewController.h"
#import "UserInfoAPI.h"
//#import "APPStatistics.h"
#import "JPUSHService.h"
#import "QuanPsychologyRequest.h"

#import "BasicNavigationController.h"
//#import "ChooseViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

static NSString *const SingleSignOn = @"SingleSignOn";

@interface QQBasicViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation QQBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[APPStatistics shareAPPStatistics] addNewPage];
//    [[APPStatistics shareAPPStatistics] printCount];
    
    self.view.backgroundColor = [UIColor customisLightBackgroundColor];
    
    [self initUIView];
    [self updateUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singleLogin:) name:SingleSignOn object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNav];

    NSString *pageName = NSStringFromClass([self class]);
    [MobClick beginLogPageView:pageName];//("PageOne"为页面名称，可自定义)
    
    NSLog(@"pageName = %@",pageName);

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *pageName = NSStringFromClass([self class]);
    [MobClick endLogPageView:pageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSString *pageName = NSStringFromClass([self class]);
    NSLog(@"%@ - dealloc",pageName);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
-(void)singleLogin:(NSNotification *)noti{
    
    [self showHUDWithMode:MBProgressHUDModeText message:@"您的账号已在别的设备上登录"];
    [self hideHUDAfter:2];
    
    [[QuanPsychologyRequest sharedInstance] cancelRequest];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:UDPHONE];
        [userDefaults removeObjectForKey:UDUID];
        [userDefaults removeObjectForKey:UDSINGLESIGNONUUID];
        [userDefaults synchronize];

        [self deleteJPushAlias];

        [self presentLoginVC];
    });
}

//登录
- (void)presentLoginVC{
    
    UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];
    
    LoginViewController *loginVC = [registerSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    BasicNavigationController *loginNav = [[BasicNavigationController alloc] initWithRootViewController:loginVC];
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    /* viewController.presentedViewController只有present才有值，push的时候为nil
     */
    
    //防止重复弹
    if ([viewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (id)viewController.presentedViewController;
        if ([navigation.topViewController isKindOfClass:[LoginViewController class]]) {
            return;
        }
    }
    if (viewController.presentedViewController) {
        //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
        [viewController.presentedViewController dismissViewControllerAnimated:false completion:^{
            [viewController presentViewController:loginNav animated:true completion:nil];
        }];
    }else {
        [viewController presentViewController:loginNav animated:true completion:nil];
    }
}

#pragma mark - JPush
-(void)deleteJPushAlias{
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"单点登录退出");
    } seq:0];
}

#pragma mark -
-(void)loadData{
    
}

-(void)initUI{
    
}

-(void)updateUI{
    
}

-(void)setNav{
    /* 导航栏字体颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
    
//    /* 去除导航栏白线，设置导航栏阴影 */
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    if (![self isKindOfClass:[HomeViewController class]]) {
        [self setBackButton:YES isBlackColor:YES];
    }
    
//    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationController.navigationBar.backIndicatorImage = backButtonImage;
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;
}

#pragma mark - MBProgressHUD
-(void)showHUDWithMode:(MBProgressHUDMode)mode message:(NSString *)message{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = mode;
    self.hud.label.text = message;
    self.hud.delegate = self;
}

-(void)updateHUDWithMode:(MBProgressHUDMode)mode message:(NSString *)message{
    self.hud.mode = mode;
    self.hud.label.text = message;
}

-(void)hideHUD{
    [self.hud hideAnimated:YES];
}

-(void)hideHUDAfter:(NSTimeInterval)time{
    [self.hud hideAnimated:YES afterDelay:time];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    self.hud = nil;
    [self.hud removeFromSuperview];
}


#pragma mark - Alert
-(void)presentAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
//    alert.view.tintColor = [UIColor customisDarkGreyColor];
    
    [alert addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ImagePicker
-(void)initImagePicker{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *chooseFromLibrary = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:takePhoto];
    [alert addAction:chooseFromLibrary];
    [alert addAction:cancel];
    
    alert.view.tintColor = [UIColor customisDarkGreyColor];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);

    [UserInfoAPI changeUserPortraitWithUID:USERUID image:image callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            self.updateCallback(YES,image);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePortrait" object:imageData];
        } else {
            [self presentAlertWithTitle:message message:@"" actionTitle:@"确定"];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - //
#pragma mark - 页面UI初始化搭建
- (void)initUIView {
}

/**
 * @brief  设置导航的标题 左右item
 *
 * @param
 *
 * @return
 */

/**
 设置导航栏
 
 @param title 标题
 @param left 左item
 @param right 右item
 @param view 标题view
 */
- (void)addNavigationWithTitle:(NSString *)title leftItem:(UIBarButtonItem  *)left rightItem:(UIBarButtonItem *)right titleView:(UIView *)view {
    if (title) {
        // 设置导航的标题
        self.navigationItem.title = title;
    }
    
    if (left) {
        // 设置左边的item
        self.navigationItem.leftBarButtonItem = left;
    }
    
    if (right) {
        // 设置右边的item
        self.navigationItem.rightBarButtonItem = right;
    }
    
    if (view) {
        // 设置标题view
        self.navigationItem.titleView = view;
    }
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@""];
}

//设置返回按钮是否显示
- (void)setBackButton:(BOOL)isShown isBlackColor:(BOOL)isBlack {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//避免iOS 11上导航栏按钮frame小，点不到区域。将按钮设置大点，居左显示
//    image
    UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    if (!isBlack) {
        backBtn.tintColor = [UIColor whiteColor];
    }
    if (isShown) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        self.navigationItem.leftBarButtonItem = leftItem;//[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

//返回
- (void)goBack {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - 网络小菊花
//网络请求等待
- (MBProgressHUD *)showWaiting {
    return [self showWaitingOnView:self.view];
}

//停止网络请求等待
- (void)hideWaiting {
    [self hidewaitingOnView:self.view];
}

- (MBProgressHUD *)showWaitingOnView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud) {
        return hud;
    }
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = @"加载中...";
    return hud;
}

- (void)hidewaitingOnView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)showMassage:(NSString *)massage {//提示消息
    if (massage) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = massage;
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.margin = 10.f;
        [hud setOffset:CGPointMake(0, 0)];
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.0f];
        
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //    alert.view.tintColor = [UIColor customisDarkGreyColor];
    
    [alert addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
