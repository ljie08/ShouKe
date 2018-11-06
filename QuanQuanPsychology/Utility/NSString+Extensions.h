//
//  NSString+Extensions.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

-(BOOL)validateNumber;

-(NSString *)isOrNoPasswordStyle;

-(NSString *)isNamingStyle;

-(BOOL)judgeTheillegalCharacter;

-(BOOL)judgePassWordLegal;

- (NSString*)disableEmojiString;

+(BOOL)stringIsNull:(NSString *)string;

-(NSString*)noneSpaseString;

-(NSString *)hidePhoneNumber;

@end
