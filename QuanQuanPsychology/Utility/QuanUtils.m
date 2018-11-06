//
//  QuanUtils.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/12.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "QuanUtils.h"

@implementation QuanUtils

+(void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    if([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        if (@available(iOS 10.0, *)) {
            [application openURL:URL options:@{}
               completionHandler:^(BOOL success) {
                   NSLog(@"Open %@: %d",scheme,success);
               }];
        } else {
            // Fallback on earlier versions
        }
    }else{
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}


+(void)setStatusBarBackgroundColor:(UIColor *)color{
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

+(void)clipViewCornerRadius:(CGFloat)cornerRadius withImage:(UIImage *)image andImageView:(UIImageView*)imageView{
    
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
}

+(CAShapeLayer *)addRoundedCorners:(UIRectCorner)corners
                            radius:(CGSize)radius
                          viewRect:(CGRect)rect {
    
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radius];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    return shape;
}

+(NSMutableAttributedString *)setFontHeightForString:(NSString *)string lineSpacing:(CGFloat)spacing font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)alignment{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];//调整行间距
    paragraphStyle.alignment = alignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [string length])];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [string length])];
    return attributedString;
}

+(CGFloat)caculateLabelHeightWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing andFont:(UIFont *)font andViewSize:(CGSize)viewSize{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentJustified;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@0.5f};
    
    CGSize size = [text boundingRectWithSize:viewSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    CGFloat blankLine = 0;
    //
    //    if ([text containsString:@"\n"]) {
    //        NSArray *strings = [text componentsSeparatedByString:@"\n"];
    //        NSInteger count = strings.count - 1;
    //        blankLine = 5 * count;
    //    }
    
    
    return size.height + blankLine;
}

+(NSData *)downloadImageWithPath:(NSString *)path{
    
    NSString *urlString = [path stringByReplacingOccurrencesOfString:@"C:" withString:SEVER] ;
    
    if ([urlString containsString:@"\\"]) {
        urlString = [urlString stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    }
    
    //    NSString *urlString = [ImagePath stringByAppendingString:[NSString stringWithFormat:@"%@",path]];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return data;
}

+(NSURL *)fullImagePath:(NSString *)path{
    
    NSString *IPAddress = @"http://106.14.45.211:8081";
    
    NSString *urlString = [path stringByReplacingOccurrencesOfString:@"C:" withString:IPAddress] ;
    
    if ([urlString containsString:@"\\"]) {
        urlString = [urlString stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    }
    
    //    NSString *urlString = [ImagePath stringByAppendingString:[NSString stringWithFormat:@"%@",path]];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

+(NSAttributedString *)formatText:(NSString *)string withAttributedText:(NSString *)attributedText color:(UIColor *)color font:(UIFont *)font{
    
    NSMutableAttributedString *attriString =[[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:attributedText];
    [attriString addAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font} range:range];
    
    return attriString;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(NSString *)filterPublishDate:(NSString *)date{
    
    //    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:[date integerValue]];
    
    NSArray *dates = [date componentsSeparatedByString:@" "];
    
    NSString *dateString = dates[0];
    NSString *timeString = dates[1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //    NSString *publishDateStr = [dateFormatter stringFromDate:date];
    //
    //    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    //    [timeFormatter setDateFormat:@"HH:mm:ss"];
    //    NSString *publishTimeStr = [timeFormatter stringFromDate:date];
    
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    
    if ([dateString isEqualToString:currentDateStr]) {
        return timeString;
    } else {
        return dateString;
    }
    
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSString *)jsonStringWithDictionary:(NSDictionary *)dict{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}

+(NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}


@end
