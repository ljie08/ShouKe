//
//  MainViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/5.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* 设置tab bar 选中时图标及文字颜色 */
    UITabBarItem *first = [self.tabBar.items objectAtIndex:0];
    first.selectedImage = [[UIImage imageNamed:@"tab_home_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [first setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customisTabColor]} forState:UIControlStateSelected];
    
    UITabBarItem *second = [self.tabBar.items objectAtIndex:1];
    second.selectedImage = [[UIImage imageNamed:@"tab_course_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [second setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customisTabColor]} forState:UIControlStateSelected];
    
    UITabBarItem *third = [self.tabBar.items objectAtIndex:2];
    third.selectedImage = [[UIImage imageNamed:@"tab_card_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [third setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customisTabColor]} forState:UIControlStateSelected];
    
    UITabBarItem *forth = [self.tabBar.items objectAtIndex:3];
    forth.selectedImage = [[UIImage imageNamed:@"tab_exercise_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [forth setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customisTabColor]} forState:UIControlStateSelected];
    
    UITabBarItem *fifth = [self.tabBar.items objectAtIndex:4];
    fifth.selectedImage = [[UIImage imageNamed:@"tab_user_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [fifth setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customisTabColor]} forState:UIControlStateSelected];
    
    
    /* tabbar 去除白线，设置阴影 */
//    self.tabBar.backgroundColor = [UIColor whiteColor];
//    self.tabBar.backgroundImage = [[UIImage alloc] init];
//    self.tabBar.shadowImage = [[UIImage alloc] init];
//    
//    self.tabBar.layer.shadowOffset = CGSizeMake(0, 1);
//    self.tabBar.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    self.tabBar.layer.shadowRadius = 10.0;
//    self.tabBar.layer.shadowOpacity = 0.8;
    
    self.selectedIndex = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    switch (item.tag) {
        case 1:
            break;
            
        case 2:
            break;
    }
}

- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


@end
