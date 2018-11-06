//
//  PhoneTextField.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneTextField : UITextField

- (BOOL)valueChangeValueString:(NSString *)string shouldChangeCharactersInRange:(NSRange)range;

@end
