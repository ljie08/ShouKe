//
//  DiscoveryDetailViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/19.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "QQBasicViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebView+CleanWebCache.h"

@interface DiscoveryDetailViewController : QQBasicViewController<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>


@property (copy, nonatomic) NSString *urlRequest;

@property (strong, nonatomic) WKWebView *webView;

-(void)initShareViewWithParams:(NSDictionary *)params;
-(void)updateUIFromURLComponent;
-(void)refresh;

@end
