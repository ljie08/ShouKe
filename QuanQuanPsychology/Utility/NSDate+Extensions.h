//
//  NSDate+Extensions.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

+(NSString *)creatTimeCode;

+(NSString *)creatTimeCodeWithDate:(NSDate *)date;

+(NSString *)creatTimeCodeWithString:(NSString *)string;

+(NSDate *)decodeTimeCode:(NSString *)timeCode;

+(NSDate *)formatterWithTime:(NSString *)timeString;

+(NSString *)currentDateString;


@end
