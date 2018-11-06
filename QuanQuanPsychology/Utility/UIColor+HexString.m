//
//  UIColor+HexString.m
//  HealthManagement
//
//  Created by luoqiang on 15/4/24.
//  Copyright (c) 2015年 guotion. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+ (UIColor *)colorwithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(UIColor *)customisMainGreen{
    return [UIColor colorwithHexString:@"#59dcbd"];
}

+(UIColor *)customisLightBackgroundColor{
    return [UIColor colorwithHexString:@"#f9f9f9"];
}

+(UIColor *)customisDarkGreyColor{
    return [UIColor colorwithHexString:@"#333333"];
}


+(UIColor *)customisLightGreyColor{
    return [UIColor colorwithHexString:@"#c9c9c9"];
}

+(UIColor *)customisRedColor{
    return [UIColor colorwithHexString:@"#fa6060"];
}

+(UIColor *)customisCellBoardColor{
    return [UIColor colorwithHexString:@"#b2b2b2"];
}

+ (UIColor *)customisDarkColor {
    return [UIColor colorwithHexString:@"#3e3e3e"];
}

+ (UIColor *)customisOrangeColor {
    return [UIColor colorwithHexString:@"#FFDE55"];
}

+ (UIColor *)customisDisablesColor {
    return [UIColor colorwithHexString:@"#DBDBDB"];
}

+ (UIColor *)customisMainColor {
    return [UIColor colorwithHexString:@"#62CFC5"];
}

+ (UIColor *)customisTabColor {
    return [UIColor colorwithHexString:@"#1FB3B8"];
}

@end
