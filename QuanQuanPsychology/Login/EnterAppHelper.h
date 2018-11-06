//
//  EnterAppHelper.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/6/5.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterAppHelper : NSObject

@property (copy, nonatomic) NSString *password;

-(void)setUserDefaultsAndSaveUserInfo:(NSDictionary *)list
                            withPhone:(NSString *)phone
                            currentVC:(UIViewController *)currentVC;

-(void)enterAPPWithVC:(UIViewController *)currentVC;

@end
