//
//  QuanUtils.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/12.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuanUtils : NSObject

+(void)openScheme:(NSString *)scheme;

+(void)setStatusBarBackgroundColor:(UIColor *)color;

+(void)clipViewCornerRadius:(CGFloat)cornerRadius withImage:(UIImage *)image andImageView:(UIImageView*)imageView;

+(CAShapeLayer *)addRoundedCorners:(UIRectCorner)corners
                            radius:(CGSize)radius
                          viewRect:(CGRect)rect;

+(NSMutableAttributedString *)setFontHeightForString:(NSString *)string lineSpacing:(CGFloat)spacing font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)alignment;

+(NSData *)downloadImageWithPath:(NSString *)path;

+(NSURL *)fullImagePath:(NSString *)path;

+(NSString *)filterPublishDate:(NSString *)date;

+(CGFloat)caculateLabelHeightWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing andFont:(UIFont *)font andViewSize:(CGSize)viewSize;

+(NSAttributedString *)formatText:(NSString *)string withAttributedText:(NSString *)attributedText color:(UIColor *)color font:(UIFont *)font;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(NSString *)jsonStringWithDictionary:(NSDictionary *)dict;

+(NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

@end
