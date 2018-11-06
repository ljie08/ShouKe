//
//  ChooseViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/2.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ChooseViewController.h"
//#import "CourseSelectionViewController.h"
#import "NewVersionGuideView.h"

@interface ChooseViewController ()


@property (weak, nonatomic) IBOutlet  MainGreenButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *login;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottom;

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self updateUI];
    
    /* 去除导航栏白线 */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor colorwithHexString:@"#333333"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorwithHexString:@"#333333"]}];
    
    
//    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationController.navigationBar.backIndicatorImage = backButtonImage;
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    if (IS_IPHONE4S) {
        self.btnBottom.constant = ScreenHeight * 0.03;
    } else {
        self.btnBottom.constant = ScreenHeight * 0.12;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)initUI{
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
    NSString *value = [USERDEFAULTS valueForKey:[NSString stringWithFormat:@"App新版本引导%@",version]];

    if ([NSString stringIsNull:value]) {
        
        NewVersionGuideView *guide = [[NewVersionGuideView alloc] initWithFrame:self.view.bounds];
        [[[UIApplication sharedApplication] keyWindow] addSubview:guide];
        
        [USERDEFAULTS setObject:@"show" forKey:[NSString stringWithFormat:@"App新版本引导%@",version]];
        [USERDEFAULTS synchronize];
    }
}

-(void)updateUI{
    self.login.layer.borderColor = [UIColor customisMainColor].CGColor;
    self.login.layer.borderWidth = 1;
    self.login.layer.cornerRadius = 5;
}

@end
