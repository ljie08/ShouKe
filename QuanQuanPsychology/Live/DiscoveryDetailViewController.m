//
//  DiscoveryDetailViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/19.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "DiscoveryDetailViewController.h"
#import "LiveViewController.h"
#import "LiveVideoCommentViewController.h"

#import "ShareView.h"
#import "KeyboardTextView.h"

#import "WebInteractionHelper.h"

#import <SafariServices/SafariServices.h>

#import "ArchiveHelper.h"

#import "ShareAPI.h"//分享得积分

@interface DiscoveryDetailViewController ()<UISearchBarDelegate, SharePlatformViewDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;

@property (assign, nonatomic) BOOL isNewVC;

@property (strong, nonatomic) KeyboardTextView *textView;

@property (nonatomic, strong) UIView *headerView;/**< <#注释#> */
@property (nonatomic, assign) NSInteger web_y;/**< <#注释#> */

@end

@implementation DiscoveryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.web_y = 0;
    
    [self initWebView];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.urlRequest containsString:@"flag=3"] || [self.urlRequest containsString:@"flag=4"]) {//黄色
        [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor customisMainColor]] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        /* 导航栏字体颜色 */
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self setBackButton:YES isBlackColor:NO];
    }
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self refresh];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.webView clearWebCache];
}

-(void)dealloc{

    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"setTitleMenuOption"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"onMenuShare"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"onComment"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"onBrowser"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"onDialog"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"onBack"];
}

#pragma mark - UI
-(void)updateUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}


-(void)initWebView{

    [self updateUIFromURLComponent];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    [wkWebConfig.userContentController addScriptMessageHandler:self name:@"setTitleMenuOption"];
    [wkWebConfig.userContentController addScriptMessageHandler:self name:@"onMenuShare"];
    [wkWebConfig.userContentController addScriptMessageHandler:self name:@"onComment"];
    [wkWebConfig.userContentController addScriptMessageHandler:self name:@"onBrowser"];
    [wkWebConfig.userContentController addScriptMessageHandler:self name:@"onDialog"];
    [wkWebConfig.userContentController addScriptMessageHandler:self name:@"onBack"];
    
    CGFloat y = self.web_y ? self.web_y : NavHeight + StatusHeight;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - NavHeight - StatusHeight) configuration:wkWebConfig];
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    self.urlRequest = [WebInteractionHelper formatDiscoveryURLWithCurrentURL:self.urlRequest];
    NSURL *url = [NSURL URLWithString:self.urlRequest];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

-(void)updateUIFromURLComponent{
    
    if ([self.urlRequest containsString:@"flag=2"]) {
        [self removeHeader];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else if ([self.urlRequest containsString:@"flag=1"]){
        [self removeHeader];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else if ([self.urlRequest containsString:@"flag=3"]) {//黄色
//        NSString *uStr = [self.urlRequest stringByReplacingOccurrencesOfString:@"?flag=3" withString:@""];
//        self.urlRequest = uStr;
        [self removeHeader];
        
    } else if ([self.urlRequest containsString:@"flag=4"]) {//带头像
//        NSString *uStr = [self.urlRequest stringByReplacingOccurrencesOfString:@"?flag=4" withString:@""];
//        self.urlRequest = uStr;
        
        [self initHeader];
    } else {
        [self removeHeader];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)initHeader {
    if (!self.headerView) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 155)];
        self.headerView.backgroundColor = [UIColor clearColor];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 117, ScreenWidth, 38)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [whiteView shadowOffset:CGSizeMake(0, 1) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:3 shadowOpacity:1];
        [self.headerView addSubview:whiteView];
        
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
        bgview.backgroundColor = [UIColor customisMainColor];
        [self.headerView addSubview:bgview];
        
        UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-76)/2, 68, 76, 76)];
        
        UserModel *user = [ArchiveHelper unarchiveModelWithKey:@"userInfo" docePath:@"userInfo"];
        
        [header sd_setImageWithURL:[QuanUtils fullImagePath:user.portrait] placeholderImage:[UIImage imageNamed:@"default_avater"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [QuanUtils clipViewCornerRadius:38 withImage:header.image andImageView:header];
        }];
        [self.headerView addSubview:header];
        [self.view addSubview:self.headerView];
    }
    self.web_y = CGRectGetMaxY(self.headerView.frame);
}

- (void)removeHeader {
    [self.headerView removeFromSuperview];
    self.headerView = nil;
}

-(void)customiseNavWithParams:(NSDictionary *)params{
    
    /*
     title 导航栏
     menu  导航栏右侧标题文字
     opt   导航栏右侧图标
     */
    
    [self.searchBar removeFromSuperview];
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.titleView = nil;
    
    self.title = [params objectForKey:@"title"];
    
    NSString *menu = [params objectForKey:@"menu"];
    NSString *opt = [params objectForKey:@"opt"];
    
    NSInteger rightNavType = [opt integerValue];
    
    switch (rightNavType) {
            
        case 0:
        {
            //nothing
        }
            break;
            
        case 1:
        {
            //search
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStylePlain target:self action:@selector(searchInfo:)];
        }
            break;
            
        case 2:
        {
            //share
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(shareDiscoveryInfo:)];
        }
            break;
            
        case 3:
        {
            //search bar
            self.navigationItem.hidesBackButton = YES;
            
            self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 30, NavHeight)];
            self.searchBar.delegate = self;
            self.searchBar.placeholder = @"搜索";
            self.searchBar.barTintColor = [UIColor whiteColor];
            self.searchBar.showsCancelButton = YES;
            self.searchBar.barStyle = UIBarMetricsDefault;
            [self.searchBar setTranslucent:YES];// 设置是否透明
            self.searchBar.backgroundImage = [QuanUtils imageWithColor:[UIColor clearColor]];
            [self.searchBar becomeFirstResponder];
            
            UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
            searchField.backgroundColor = [[UIColor colorwithHexString:@"#8E8E93"] colorWithAlphaComponent:0.12];
            
            /*
            UIView *searchBarView = [[UIView alloc] init];
            searchBarView.backgroundColor = [UIColor clearColor];
            [searchBarView addSubview:self.searchBar];
             */
            
            self.navigationItem.titleView = self.searchBar;
            self.navigationItem.titleView.frame = CGRectMake(0, 0, ScreenWidth - 30, NavHeight);
        }
            break;
    }

}

-(void)initShareViewWithParams:(NSDictionary *)params{
    
    ShareView *shareView = [[ShareView alloc] initWithFrame:self.view.bounds];
    
    
    [self.navigationController.view addSubview:shareView];
    
//    UIImage *image = [UIImage imageNamed:@"圈圈icon"];
    
    NSString *iconPath = params[@"shareIcon"];
    
    UIImage *shareIcon = [UIImage imageWithData:[QuanUtils downloadImageWithPath:iconPath]];
    
    
    shareView.platformView.shareTitle = params[@"title"];
    shareView.platformView.shareSubTitle = params[@"content"];
    shareView.platformView.shareIcon = shareIcon;
    shareView.platformView.shareURL = params[@"url"];
    shareView.platformView.currentVC = self;
    shareView.platformView.delegate = self;
}

//分享得积分
- (void)getShareSucessScore {
    [ShareAPI getShareIntegrationWithUID:USERUID type:@"4" callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}


-(void)initKeyboardTextView{
    
    self.textView = [[KeyboardTextView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    self.textView.maxWordCount = 100;
//    textView.textView.text = self.noteCache;
    self.textView.wordCount.text = [NSString stringWithFormat:@"(0/%ld)字",(long)self.textView.maxWordCount];
    [self.textView.doneBtn addTarget:self action:@selector(finishTyping:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:self.textView];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        self.textView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
}

- (void)finishTyping:(UIButton *)button {
    
    NSString *content = self.textView.textView.text;
    
    if (content.length != 0) {
        
        NSString *comment = [NSString stringWithFormat:@"comment('%@')",content];

        [self.webView evaluateJavaScript:comment completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            NSLog(@"comment - %@",error.localizedDescription);
        }];
        
        [UIView animateWithDuration:0.05 animations:^{
            self.textView.frame = CGRectMake(0, self.textView.frame.size.height, self.textView.frame.size.width, self.textView.frame.size.height);
        } completion:^(BOOL finished) {
            [self.textView removeFromSuperview];
        }];
        
    } else {
        
        [self presentAlertWithTitle:@"请输入评论内容" message:@"" actionTitle:@"好的"];
    }
    
}

-(void)creatMaterialErrorAlert:(NSDictionary *)dict{
    
    NSString *title = dict[@"title"];
    NSArray *btns = dict[@"btns"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i = 0; i < btns.count; i++) {
        NSString *actionTitle = btns[i];
        
        if (i == 0) {
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self reportMaterialError];
            }];
            
            [alert addAction:confirm];
            [alert setPreferredAction:confirm];
        } else {
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancel];
        }
    }
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Navigation Item Action
-(void)searchInfo:(UIBarButtonItem *)buttonItem{
    
    NSString *search = [NSString stringWithFormat:@"jumpSearch()"];

    [self.webView evaluateJavaScript:search completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"search type - %@",error.localizedDescription);
    }];
    
}

-(void)shareDiscoveryInfo:(UIBarButtonItem *)buttonItem{
    
    NSString *share = [NSString stringWithFormat:@"share()"];
    
    [self.webView evaluateJavaScript:share completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"share type - %@",error.localizedDescription);
    }];
}

#pragma mark - JS交互
/* 刷新web view */
-(void)refresh{
    
    NSString *refresh = [NSString stringWithFormat:@"refreshView()"];
    
    [self.webView evaluateJavaScript:refresh completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"refresh web view - %@",error.localizedDescription);
    }];
}

/* 资料报错 */
-(void)reportMaterialError{
    
    NSString *define = [NSString stringWithFormat:@"define()"];
    
    [self.webView evaluateJavaScript:define completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"report material error - %@",error.localizedDescription);
    }];
}

#pragma mark - <WKScriptMessageHandler>
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"body:%@,name:%@", message.body,message.name);
    
#pragma mark - 设置Nav

    if ([message.name isEqualToString:@"setTitleMenuOption"]){
        
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = message.body;
            
            [self customiseNavWithParams:dict];

        }
        
    }
    
#pragma mark - 分享
    
    else if ([message.name isEqualToString:@"onMenuShare"]){
        
        
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = message.body;
            
            [self initShareViewWithParams:dict];
        }
        
    }
    
#pragma mark - 评论

    else if ([message.name isEqualToString:@"onComment"]){
        
        [self initKeyboardTextView];
    }
    
#pragma mark - 跳转浏览器
    
    else if ([message.name isEqualToString:@"onBrowser"]){
        
        NSString *urlString = message.body;

        NSURL *url = [NSURL URLWithString:urlString];
        
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
        
        [self presentViewController:safariVC animated:YES completion:nil];
        
    }
    
#pragma mark - 资料报错
    else if ([message.name isEqualToString:@"onDialog"]){
        
        NSDictionary *dict = message.body;
        
        [self creatMaterialErrorAlert:dict];
        
    }
    
#pragma mark - 跳转上一级
    
    if ([message.name isEqualToString:@"onBack"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{

    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if ([strRequest containsString:@"is_new"]) {
        self.isNewVC = YES;
    } else {
        self.isNewVC = NO;
    }


    if([strRequest isEqualToString:self.urlRequest] || !self.isNewVC) {//主页面加载内容
        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转

    } else {//截获页面里面的链接点击
        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
        //do something you want

        if ([strRequest containsString:@"is_player"]) {
            LiveViewController *liveVC = [[LiveViewController alloc] init];

            liveVC.urlRequest = strRequest;

            [self.navigationController pushViewController:liveVC animated:YES];

        } else if ([strRequest containsString:@"is_comment"]){

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Discovery" bundle:[NSBundle mainBundle]];

            LiveVideoCommentViewController *liveVideoCommentVC = [storyboard instantiateViewControllerWithIdentifier:@"LiveVideoCommentViewController"];

            liveVideoCommentVC.urlRequest = strRequest;

            liveVideoCommentVC.modalPresentationStyle = UIModalPresentationCustom;
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:liveVideoCommentVC animated:YES completion:nil];

//            [self.navigationController pushViewController:liveVideoCommentVC animated:YES];


        } else if ([strRequest containsString:SEVER]) {

            DiscoveryDetailViewController *detailVC = [[DiscoveryDetailViewController alloc] init];
            detailVC.urlRequest = strRequest;

            [self.navigationController pushViewController:detailVC animated:YES];
        }

    }

}


#pragma mark - <UISearchBarDelegate>
// UISearchBar得到焦点并开始编辑时，执行该方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    NSString *search = [NSString stringWithFormat:@"search('%@')",searchBar.text];

    [self.webView evaluateJavaScript:search completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"search - %@",error.localizedDescription);

    }];
}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

@end
