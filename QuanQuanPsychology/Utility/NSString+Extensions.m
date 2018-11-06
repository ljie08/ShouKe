//
//  NSString+Extensions.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

-(BOOL)validateNumber{
    
    if (self.length < 11) {
        return NO;
    } else {
        
        BOOL res = YES;
        NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        int i = 0;
        while (i < self.length) {
            NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
            NSRange range = [string rangeOfCharacterFromSet:tmpSet];
            if (range.length == 0) {
                res = NO;
                break;
            }
            i++;
        }
        return res;
    }
    
}

-(NSString *)isOrNoPasswordStyle{
    NSString *message = @"";
    if (self.length == 0) {
        message = @"请输入密码";
    } else if (self.length < 8 || self.length > 20) {
        message=@"密码为8-20位";
    } else if ([self judgeTheillegalCharacter]){
        message=@"密码不能包含特殊字符";
    } else if (![self judgePassWordLegal]){
        message=@"密码必须同时包含字母和数字";
    }
    return message;
    
}

-(NSString *)isNamingStyle{
    NSString *message = @"";
    if (self.length == 0 || self.length > 20) {
        message=@"昵称在20个字符以内";
    } else if ([self judgeTheillegalCharacter]){
        message=@"昵称不能包含特殊字符";
    }
    return message;
}

-(BOOL)judgeTheillegalCharacter{
    //提示标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

-(BOOL)judgePassWordLegal{
    BOOL result ;
    // 判断长度大于8位后再接着判断是否同时包含数字和大小写字母
    //    NSString * regex =@"(?![0-9A-Z]+$)(?![0-9a-z]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$ ";
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}

- (NSString*)disableEmojiString{
    //去除表情规则
    //  \u0020-\\u007E  标点符号，大小写字母，数字
    //  \u00A0-\\u00BE  特殊标点  (¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾)
    //  \u2E80-\\uA4CF  繁简中文,日文，韩文 彝族文字
    //  \uF900-\\uFAFF  部分汉字
    //  \uFE30-\\uFE4F  特殊标点(︴︵︶︷︸︹)
    //  \uFF00-\\uFFEF  日文  (ｵｶｷｸｹｺｻ)
    //  \u2000-\\u201f  特殊字符(‐‑‒–—―‖‗‘’‚‛“”„‟)
    // 注：对照表 http://blog.csdn.net/hherima/article/details/9045765
    
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSString* result = [expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""];
    
    return result;
}

+(BOOL)stringIsNull:(NSString *)string{
    
    if ([string isEqualToString:@"null"] || [string isEqualToString:@""] || string == nil || [string isEqual: [NSNull null]] || [string containsString:@"null"]) {
        return YES;
    } else {
        return NO;
    }
}

-(NSString*)noneSpaseString{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(NSString *)hidePhoneNumber{
    
    if (self.length == 11) {
        NSRange range = NSMakeRange(3, 4);
        NSString *string = [self substringWithRange:range];
        return [self stringByReplacingOccurrencesOfString:string withString:@"****"];
    } else {
        
        return self;
    }
    
}

@end
