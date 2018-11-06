//
//  UIColor+HexString.h
//  HealthManagement
//
//  Created by luoqiang on 15/4/24.
//  Copyright (c) 2015年 guotion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
/**
 *  十六进制的颜色转换为UIColor
 *
 *  @param color   十六进制的颜色
 *
 *  @return   UIColor
 */
+ (UIColor *)colorwithHexString:(NSString *)color;



+(UIColor *)customisMainGreen;

+(UIColor *)customisLightBackgroundColor;

+(UIColor *)customisDarkGreyColor;/* 字体深灰 */

+(UIColor *)customisLightGreyColor;/* 字体浅灰 */

+(UIColor *)customisRedColor;/* 通关失败红色 */

+(UIColor *)customisCellBoardColor;/* 答题卡选项描边灰色 */

+ (UIColor *)customisDarkColor;/* 字体黑色 */

+ (UIColor *)customisOrangeColor;

+ (UIColor *)customisDisablesColor;

+ (UIColor *)customisMainColor;//主题色

+ (UIColor *)customisTabColor;//tab字体颜色

@end
