
//
//  ResetPasswdView.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/11/1.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "ResetPasswdView.h"

@interface ResetPasswdView()

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation ResetPasswdView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)sureAction:(id)sender {
    if (self.block) {
        self.block();
    }
}

@end
