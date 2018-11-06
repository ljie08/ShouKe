//
//  ReSetAlertView.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/11/1.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ResetBlock)(void);

@interface ReSetAlertView : UIView

@property (nonatomic, copy) ResetBlock loginBlock;/**< <#注释#> */

@end

NS_ASSUME_NONNULL_END
