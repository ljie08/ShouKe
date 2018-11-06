//
//  QuestionModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/17.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        /*
         analysis == 解析
         answer1-5 == 选项
         id == 题目ID
         question_name == 题目
         is_pic == 是否有图片 1：文字 2：图片
         pic_url == 题目图片路径
         right_answer == 正确答案
         type == 题目类型 1：单选 2：多选
         */
        
        self.quesID = [NSString stringWithFormat:@"%@",dict[QUESTIONID]];
        
        NSString *type = [NSString stringWithFormat:@"%@",dict[QUESTIONTYPE]];
        
        if ([type isEqualToString:@"1"]) {
            self.questionType = QUESTION_SINGLE;
        } else {
            self.questionType = QUESTION_MUTIPLE;
        }
        
        self.title = [dict[QUESTIONNAME] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        
        if (dict[@"yearQuestion"]) {
            self.titleYear = dict[@"yearQuestion"];
        } else {
            self.titleYear = @"";
        }
        
        self.titleType = [NSString stringWithFormat:@"%@",dict[QUESTIONIMAGE]];
        self.titleURL = dict[PICPATH];
        
        if (![NSString stringIsNull:dict[OPTIONONE]]) {
            self.options = [NSMutableArray array];
            [self.options addObject:dict[OPTIONONE]];
        }
        
        if (![NSString stringIsNull:dict[OPTIONTWO]]) {
            [self.options addObject:dict[OPTIONTWO]];
        }
        
        if (![NSString stringIsNull:dict[OPTIONTHREE]]) {
            [self.options addObject:dict[OPTIONTHREE]];
        }
        
        if (![NSString stringIsNull:dict[OPTIONFOUR]]) {
            [self.options addObject:dict[OPTIONFOUR]];
        }
        
        if (![NSString stringIsNull:dict[OPTIONFIVE]]) {
            [self.options addObject:dict[OPTIONFIVE]];
        }
        
        self.answer = dict[RIGHTANSWER];
        
        if ([self.answer containsString:@","]) {
            self.answer = [self.answer stringByReplacingOccurrencesOfString:@"," withString:@"、"];
        }
        
        if ([self.answer containsString:@" "]) {
            self.answer = [self.answer stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        self.analysis = [dict[QUESTIONANALYSIS] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    }
    
    return self;
}


@end
