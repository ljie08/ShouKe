//
//  MyLiveCourseViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/19.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "MyLiveCourseViewController.h"
#import <WebKit/WebKit.h>

@interface MyLiveCourseViewController ()

@property (strong, nonatomic) WKWebView *myLiveCourse;

@end

@implementation MyLiveCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self setBackButton:YES isBlackColor:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)initUI{
    
//    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//    
//    self.myLiveCourse = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight) configuration:wkWebConfig];
//    [self.view addSubview:self.myLiveCourse];
//    
//    
//    //    NSString *urlString = [self changeURLWithParams:self.eventURL];
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.189:8081/quan-live/pages/index/index.html"];
//    [self.myLiveCourse loadRequest:[NSURLRequest requestWithURL:url]];
//    
////    self.myLiveCourse.navigationDelegate = self;
}


@end
