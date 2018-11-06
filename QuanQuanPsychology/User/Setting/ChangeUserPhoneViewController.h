//
//  ChangeUserPhoneViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 16/8/8.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeUserPhoneViewController : QQBasicViewController

@property (strong, nonatomic) NSString *userPhone;

@property (assign, nonatomic) BOOL updateNewPhone;//是否为绑定新号码

@end
