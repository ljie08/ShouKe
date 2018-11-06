//
//  ResetPasswdView.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/11/1.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ResetPasswdBlock)(void);

@interface ResetPasswdView : UIView

@property (weak, nonatomic) IBOutlet UITextField *passwdTF1;
@property (weak, nonatomic) IBOutlet UITextField *passwdTF2;
@property (nonatomic, copy) ResetPasswdBlock block;/**< <#注释#> */

@end

NS_ASSUME_NONNULL_END
