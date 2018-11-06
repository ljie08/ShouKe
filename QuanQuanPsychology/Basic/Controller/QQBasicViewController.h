//
//  QQBasicViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/10/12.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"//加载指示器

typedef void(^PortraitUpdateCallback)(BOOL success,UIImage *image);

@interface QQBasicViewController : UIViewController


#pragma mark - Init
-(void)initUI;

-(void)updateUI;

-(void)loadData;

#pragma mark - 头像

@property (strong, nonatomic) PortraitUpdateCallback updateCallback;

-(void)initImagePicker;

#pragma mark - HUD
-(void)showHUDWithMode:(MBProgressHUDMode)mode message:(NSString *)message;

-(void)updateHUDWithMode:(MBProgressHUDMode)mode message:(NSString *)message;

-(void)hideHUD;

-(void)hideHUDAfter:(NSTimeInterval)time;

#pragma mark - Alert
-(void)presentAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle;


#pragma mark - //
/**
 是否显示返回按钮

 @param isShown 是否显示
 @param isBlack 是否为黑色按钮
 */
- (void)setBackButton:(BOOL)isShown isBlackColor:(BOOL)isBlack;

/**
 *  创建UI
 */
- (void)initUIView;

/**
 设置导航栏
 */
- (void)addNavigationWithTitle:(NSString *)title leftItem:(UIBarButtonItem  *)left rightItem:(UIBarButtonItem *)right titleView:(UIView *)view;

- (MBProgressHUD *)showWaiting;//网络请求等待提示
- (void)hideWaiting;//停止等待提示
- (void)showMassage:(NSString *)massage;//提示消息

@end
