//
//  NSDate+Extensions.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

+(NSString *)creatTimeCode{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSString *timeCode = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeCode;
}

+(NSDate *)decodeTimeCode:(NSString *)timeCode{
    
    NSInteger time = [timeCode integerValue] / 1000;
    
    NSDate *date= [NSDate dateWithTimeIntervalSince1970:time];
    
    return date;
    
}

+(NSDate *)formatterWithTime:(NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeString];
    
    return date;
}

+(NSString *)currentDateString{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSString *)creatTimeCodeWithDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeCode = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeCode;
}

+(NSString *)creatTimeCodeWithString:(NSString *)string{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    
    NSString *timeCode = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeCode;
}

@end
