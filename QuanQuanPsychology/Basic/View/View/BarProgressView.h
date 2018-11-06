//
//  BarProgressView.h
//  QuanQuan
//
//  Created by Jocelyn on 16/8/5.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarProgressView : UIView

/**
 *  进度条高度  height: 5~100
 */
@property (nonatomic) CGFloat progressHeight;

/**
 *  进度值  maxValue:  <= YSProgressView.width
 */
@property (nonatomic) CGFloat progressValue;

/**
 *   动态进度条颜色  Dynamic progress
 */
@property (nonatomic, strong) UIColor *trackTintColor;
/**
 *  静态背景颜色    static progress
 */
@property (nonatomic, strong) UIColor *progressTintColor;




@end
