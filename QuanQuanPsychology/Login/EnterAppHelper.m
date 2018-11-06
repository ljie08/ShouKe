//
//  EnterAppHelper.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/6/5.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "EnterAppHelper.h"
#import "MainViewController.h"
#import "CourseSelectionViewController.h"
#import "PortraitViewController.h"
#import "ArchiveHelper.h"

@implementation EnterAppHelper

-(void)setUserDefaultsAndSaveUserInfo:(NSDictionary *)list
                            withPhone:(NSString *)phone
                            currentVC:(UIViewController *)currentVC{
        
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePortrait" object:user.portrait];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:user.portrait forKey:UDPORTRAIT];
    [userDefaults setValue:user.uid forKey:UDUID];
    [userDefaults setValue:user.phone forKey:UDPHONE];
    [userDefaults synchronize];
    
    NSString *color = [userDefaults valueForKey:UDBACKGROUNDCOLOR];
    
    if (!color) {
        [userDefaults setObject:@"#ffffff" forKey:UDBACKGROUNDCOLOR];
        [userDefaults synchronize];
    }
    
    [ArchiveHelper archiveModel:user forKey:@"userInfo" docePath:@"userInfo"];
    
    
    if ([NSString stringIsNull:user.userName]) {
        [self fillBlankWithUserInfo:user currentVC:currentVC];
    } else {
        [self enterAPPWithVC:currentVC];
    }
}

-(void)enterAPPWithVC:(UIViewController *)currentVC{
    
    if (USERCOURSE) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        
        MainViewController *mainVC = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        
        
        [currentVC.navigationController pushViewController:mainVC animated:YES];
        
    } else {
        
        UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];
        
        CourseSelectionViewController *courseVC = [registerSB instantiateViewControllerWithIdentifier:@"CourseSelectionViewController"];
        
        [currentVC.navigationController pushViewController:courseVC animated:YES];
        
    }
    
}

-(void)fillBlankWithUserInfo:(UserModel *)user currentVC:(UIViewController *)currentVC{
    UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];

    PortraitViewController *portraitVC = [registerSB instantiateViewControllerWithIdentifier:@"PortraitViewController"];

    portraitVC.portraitPath = user.portrait;
    portraitVC.uid = user.uid;
    portraitVC.phone = user.phone;

    [currentVC.navigationController pushViewController:portraitVC animated:YES];
}

@end
