//
//  LiveVideoCommentViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/7/2.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "LiveVideoCommentViewController.h"

@interface LiveVideoCommentViewController ()


@end

@implementation LiveVideoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self.webView clearWebCache];
}

-(void)updateUI{
    [super updateUI];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.webView setOpaque:NO];
    
//    self.webView.frame = CGRectMake(20, StatusHeight + 20, ScreenWidth - 20 * 2, ScreenHeight - (StatusHeight + 20 * 2));
    self.webView.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight - StatusHeight);

}

#pragma mark - <WKScriptMessageHandler>
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
    NSLog(@"body:%@,name:%@", message.body,message.name);
    
#pragma mark - 弹窗消失
    
    if ([message.name isEqualToString:@"onBack"]){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
