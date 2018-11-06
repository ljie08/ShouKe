//
//  CountDownBtn.h
//  MoxiLjieApp
//
//  Created by Libra on 2018/8/20.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 点击
 */
typedef void(^ButtonClickedBlock)(void);

/**
 倒计时进行中
 
 @param countdown 剩余时间
 */
typedef void(^CountDowningBlock)(NSInteger countdown);

/**
 倒计时结束
 */
typedef void(^CountDownCompletionBlock)(void);

@interface CountDownBtn : UIButton

/**
 倒计时时间
 */
@property (nonatomic, assign) NSInteger countNum;

/**
 背景颜色
 */
@property (nonatomic, strong) UIColor *bgColor;

/**
 不可点击时的背景颜色
 */
@property (nonatomic, strong) UIColor *disabledBgColor;

/**
 字体大小
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 点击
 */
@property (nonatomic, copy) ButtonClickedBlock btnBlock;

/**
 倒计时进行中
 */
@property (nonatomic, copy) CountDowningBlock countdowningBlock;

/**
 倒计时结束
 */
@property (nonatomic, copy) CountDownCompletionBlock completionBlock;

/**
 初始化默认配置
 */
- (void)initDefault;

/**
 按钮点击
 
 @param button <#button description#>
 */
- (void)btnClicked:(CountDownBtn *)button;

/**
 开始倒计时
 */
- (void)beginCountDown;

/**
 倒计时结束
 */
- (void)endCountDown;

@end
