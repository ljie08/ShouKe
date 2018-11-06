//
//  ReSetAlertView.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/11/1.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "ReSetAlertView.h"

@interface ReSetAlertView()


@end

@implementation ReSetAlertView

- (IBAction)goLogin:(id)sender {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

@end
