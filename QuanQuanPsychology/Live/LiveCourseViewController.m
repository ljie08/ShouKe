//
//  LiveCourseViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/16.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "LiveCourseViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebView+CleanWebCache.h"

#import "DiscoveryDetailViewController.h"
#import "LiveViewController.h"

#import "WebInteractionHelper.h"

#import "DefaultNetworkView.h"

#define DISCOVERYPATH  [SEVER_QUAN_API stringByAppendingString:@"hcxl/course/course_list.html"]

@interface LiveCourseViewController ()<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *discoveryHomePage;

@end

@implementation LiveCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewVC:) name:@"renewVC" object:nil];
    
    [self initUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [self setBackButton:NO isBlackColor:YES];
    [self refresh];
    
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.discoveryHomePage clearWebCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
-(void)initUI{
    
    if (@available(iOS 11.0, *)) {
    self.discoveryHomePage.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];    

    self.discoveryHomePage = [[WKWebView alloc] initWithFrame:CGRectMake(0,NavHeight + StatusHeight , ScreenWidth, ScreenHeight - NavHeight - StatusHeight - TabHeight) configuration:wkWebConfig];
    self.discoveryHomePage.opaque = NO;
    [self.view addSubview:self.discoveryHomePage];
    
    self.discoveryHomePage.navigationDelegate = self;
    
    [self loadDiscoveryHomePage];
    
}

-(void)loadDiscoveryHomePage{
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
    
    NSString *urlString = [WebInteractionHelper formatDiscoveryURLWithCurrentURL:DISCOVERYPATH];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.discoveryHomePage loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - JS交互 - 刷新web view
-(void)refresh{
    
    NSString *refresh = [NSString stringWithFormat:@"refreshView()"];
    
    [self.discoveryHomePage evaluateJavaScript:refresh completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"refresh web view - %@",error.localizedDescription);
    }];
}

#pragma mark - Notification
-(void)renewVC:(NSNotification *)noti{
    
    [self loadDiscoveryHomePage];
    
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{

    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *urlString = [WebInteractionHelper formatDiscoveryURLWithCurrentURL:DISCOVERYPATH];

    BOOL isNewVC = NO;

    if ([strRequest containsString:@"is_new"]) {
        isNewVC = YES;
    }

    if([strRequest isEqualToString:urlString] || !isNewVC) {//主页面加载内容
        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转

    } else {//截获页面里面的链接点击
        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
        //do something you want

        if ([strRequest containsString:@"is_player"]) {
            
            LiveViewController *liveVC = [[LiveViewController alloc] init];


            liveVC.urlRequest = strRequest;

            [self.navigationController pushViewController:liveVC animated:YES];
        } else if ([strRequest containsString:SEVER]) {
            DiscoveryDetailViewController *detailVC = [[DiscoveryDetailViewController alloc] init];
            detailVC.urlRequest = strRequest;

            [self.navigationController pushViewController:detailVC animated:YES];
        }

    }

}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//    NSString *strRequest = [navigationResponse.response.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    NSString *urlString = [WebInteractionHelper formatDiscoveryURLWithCurrentURL:DISCOVERYPATH];
//
//    BOOL isNewVC = NO;
//
//    if ([strRequest containsString:@"is_new"]) {
//        isNewVC = YES;
//    }
//
//    if([strRequest isEqualToString:urlString] || !isNewVC) {//主页面加载内容
//        decisionHandler(WKNavigationResponsePolicyAllow);//允许跳转
//
//    } else {//截获页面里面的链接点击
//        decisionHandler(WKNavigationResponsePolicyCancel);//不允许跳转
//        //do something you want
//
//        if ([strRequest containsString:@"is_player"]) {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Discovery" bundle:[NSBundle mainBundle]];
//
//            LiveViewController *liveVC = [storyboard instantiateViewControllerWithIdentifier:@"LiveViewController"];
//
//            liveVC.urlRequest = strRequest;
//
//            [self.navigationController pushViewController:liveVC animated:YES];
//        } else {
//            DiscoveryDetailViewController *detailVC = [[DiscoveryDetailViewController alloc] init];
//            detailVC.urlRequest = strRequest;
//
//            [self.navigationController pushViewController:detailVC animated:YES];
//        }
//
//    }
//
//}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    [self hideHUD];
    
    DefaultNetworkView *refreshView = [[DefaultNetworkView alloc] initWithFrame:CGRectMake(0, NavHeight + StatusHeight, ScreenWidth, ScreenHeight - NavHeight - StatusHeight - TabHeight)];
    refreshView.refreshView = ^{
        [self loadDiscoveryHomePage];
    };
    
    [self.view addSubview:refreshView];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self hideHUDAfter:0.5];
}


@end
