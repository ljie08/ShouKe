//
//  ResetViewController.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/11/2.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "QQBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResetViewController : QQBasicViewController

@property (nonatomic, strong) NSString *phone;/**< 手机号 */
@property (nonatomic, strong) NSString *code;/**< 验证码 */

@end

NS_ASSUME_NONNULL_END
