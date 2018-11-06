//
//  ExerciseExtension.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/18.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "ExerciseExtension.h"
//#import "PaperMaterialModel.h"

@implementation ExerciseExtension

+(NSString *)formatterQuestion:(QuestionModel *)question
                     withIndex:(NSInteger)index
                     showIndex:(BOOL)show{
    
    if ([NSString stringIsNull:question.titleYear]) {
        if (show) {
            NSString *string = [NSString stringWithFormat:@"            %ld、%@",(index + 1),question.title];
            return string;
        } else {
            NSString *string = [NSString stringWithFormat:@"            %@",question.title];
            return string;
        }
    } else {
        if (show) {
            NSString *string = [NSString stringWithFormat:@"            %ld、%@",(index + 1),question.title];
            string = [string stringByAppendingString:[NSString stringWithFormat:@"（%@）",question.titleYear]];
            return string;
        } else {
            NSString *string = [NSString stringWithFormat:@"            %@",question.title];
            string = [string stringByAppendingString:[NSString stringWithFormat:@"（%@）",question.titleYear]];
            return string;
        }
    }
    
}

+(NSString *)changeIndexToAlphabet:(NSInteger)index{
    switch (index) {
        case 0:
            return @"A";
            break;
            
        case 1:
            return @"B";
            break;
            
        case 2:
            return @"C";
            break;
            
        case 3:
            return @"D";
            break;
            
        case 4:
            return @"E";
            break;
            
        default:
            return @"";
            break;
    }
}

+(NSInteger)changeAlphabetToIndex:(NSString *)alphabet{
    
    if ([alphabet isEqualToString:@"A"]) {
        return 0;
    } else if ([alphabet isEqualToString:@"B"])  {
        return 1;
    } else if ([alphabet isEqualToString:@"C"])  {
        return 2;
    } else if ([alphabet isEqualToString:@"D"])  {
        return 3;
    } else if ([alphabet isEqualToString:@"E"])  {
        return 4;
    } else {
        return -1;
    }
}

+(ExerciseResult)covertUserAnswerWithStatus:(NSString *)status{
    
    ExerciseResult result;
    
    if ([status isEqualToString:@""]) {
        result = EXERCISE_UNSELECTED;
    } else if ([status isEqualToString:ANSWERRIGHT]){
        result = EXERCISE_CORRECT;
    } else {
        result = EXERCISE_INCORRECT;
    }
    
    return result;
}

/**
 quesID : 题目id
 error : 错误选项
 status : 0 错 1对
 module : 模块
 
 */

+(NSDictionary *)userAnswerWithQuesID:(NSString *)quesID
                          errorAnswer:(NSString *)error
                               status:(NSString *)status
                               moduel:(NSString *)module{
    
    NSDictionary *dict = @{@"question_id":quesID,@"error_answer":error,@"status":status,@"type":module};
    
    return dict;
}

/*  用户全部选项 包含未做的题目
 不上传至服务器status设置为""
 上传至服务器status设置为"0"
 */
+(NSArray *)combineAllUserAnswer:(NSMutableArray *)userAnswers
                     withAllQues:(NSMutableArray *)allQues
                          module:(NSString *)module
                        forSever:(BOOL)forSever{
    /**
     NSDictionary *dict = @{@"question_id":quesID,@"error_answer":error,@"status":status,@"type":module};
     quesID : 题目id  error : 错误选项  status : 0 错 1对  module : 模块
     */
    
    NSMutableArray *errorAnswers = [NSMutableArray array];
    NSMutableArray *questionIDs = [NSMutableArray array];
    NSMutableArray *finishIDs = [NSMutableArray array];
    
    for (int i = 0; i < allQues.count; i++) {
        QuestionModel *question = allQues[i];
        [questionIDs addObject:question.quesID];
    }
    
    for (int i = 0; i < userAnswers.count; i++) {
        NSDictionary *dict = userAnswers[i];
        [finishIDs addObject:dict[@"question_id"]];
    }
    
    NSPredicate *IDPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",finishIDs];
    NSArray *missIDs = [questionIDs filteredArrayUsingPredicate:IDPredicate];
    
    for (int i = 0; i < missIDs.count; i++) {
        NSString *missID = missIDs[i];
        if (forSever) {
            NSDictionary *dict = @{@"question_id":missID,@"error_answer":@"",@"status":ANSWERWRONG,@"type":module};
            [errorAnswers addObject:dict];
        } else {
            NSDictionary *dict = @{@"question_id":missID,@"error_answer":@"",@"status":@"",@"type":module};
            [errorAnswers addObject:dict];
        }
    }
    
    NSArray *array = [userAnswers arrayByAddingObjectsFromArray:errorAnswers];
    
    
    return array;
}

/* 仅为用户做错题目的错误选项 */
+(NSArray *)filterUserErrorAnswer:(NSMutableArray *)userAnswers
                      withAllQues:(NSMutableArray *)allQues
                           module:(NSString *)module{
    
    /**
     NSDictionary *dict = @{@"question_id":quesID,@"error_answer":error,@"status":status,@"type":module};
     quesID : 题目id  error : 错误选项  status : 0 错 1对  module : 模块
     */
    
    NSMutableArray *errorAnswers = [NSMutableArray array];
    NSMutableArray *questionIDs = [NSMutableArray array];
    NSMutableArray *finishIDs = [NSMutableArray array];
    
    for (int i = 0; i < allQues.count; i++) {
        QuestionModel *question = allQues[i];
        [questionIDs addObject:question.quesID];
    }
    
    for (int i = 0; i < userAnswers.count; i++) {
        NSDictionary *dict = userAnswers[i];
        [finishIDs addObject:dict[@"question_id"]];
    }
    
    NSPredicate *IDPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",finishIDs];
    NSArray *missIDs = [questionIDs filteredArrayUsingPredicate:IDPredicate];
    
    for (int i = 0; i < missIDs.count; i++) {
        NSString *missID = missIDs[i];
        NSDictionary *dict = @{@"question_id":missID,@"error_answer":@"",@"status":@"",@"type":module};
        [errorAnswers addObject:dict];
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(status == %@)", @"0"];
    
    NSArray *userErrorAnswers = [userAnswers filteredArrayUsingPredicate:predicate];
    
    NSArray *array = [userErrorAnswers arrayByAddingObjectsFromArray:errorAnswers];
    
    
    return array;
}

/* 仅为用户做错题目的题干 */
+(NSArray *)filterErrorQues:(NSMutableArray *)userAnswers withAllQues:(NSMutableArray *)allQues{
    
    /**
     NSDictionary *dict = @{@"question_id":quesID,@"error_answer":error,@"status":status,@"type":module};
     quesID : 题目id  error : 错误选项  status : 0 错 1对  module : 模块
     */
    
    NSMutableArray *errorID = [NSMutableArray array];
    //    NSMutableArray *rightID = [NSMutableArray array];
    
    NSMutableArray *questionIDs = [NSMutableArray array];
    NSMutableArray *finishIDs = [NSMutableArray array];
    
    for (NSDictionary *dict in userAnswers) {
        NSInteger status = [dict[@"status"] integerValue];
        if (status == 0) {
            [errorID addObject:dict[@"question_id"]];
        }
        
    }
    
    for (int i = 0; i < allQues.count; i++) {
        QuestionModel *question = allQues[i];
        [questionIDs addObject:question.quesID];
    }
    
    for (int i = 0; i < userAnswers.count; i++) {
        NSDictionary *dict = userAnswers[i];
        [finishIDs addObject:dict[@"question_id"]];
    }
    
    NSPredicate *IDPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",finishIDs];
    NSArray *missIDs = [questionIDs filteredArrayUsingPredicate:IDPredicate];
    
    [errorID addObjectsFromArray:missIDs];
    
    NSMutableArray *errorQues = [NSMutableArray array];
    for (int i = 0; i < errorID.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(quesID == %@)", errorID[i]];
        NSArray *result = [allQues filteredArrayUsingPredicate:predicate];
        [errorQues addObject:result.firstObject];
    }
    
    return [errorQues copy];
}

///* 考试模块 技能卷 -- 用户做错题目的卡片内容 */
//+(NSArray *)filterErrorCards:(NSMutableArray *)userAnswers withAllCards:(NSMutableArray *)allCards{
//    
//    /**
//     NSDictionary *dict = @{@"question_id":quesID,@"error_answer":error,@"status":status,@"type":module};
//     quesID : 题目id  error : 错误选项  status : 0 错 1对  module : 模块
//     */
//    
//    NSMutableArray *rightID = [NSMutableArray array];
//    
//    for (NSDictionary *dict in userAnswers) {
//        NSInteger status = [dict[@"status"] integerValue];
//        
//        if (status == 1) {
//            [rightID addObject:dict[@"question_id"]];
//        }
//    }
//    
//    for (int i = 0; i < allCards.count; i++) {
//        
//        PaperMaterialModel *materialModel = allCards[i];
//        
//        NSMutableArray *questions = materialModel.questions;
//        
//        NSMutableArray *questionsCopy = [questions mutableCopy];
//
//        
//        for (int j = 0; j < questionsCopy.count; j++) {
//            QuestionModel *model = questionsCopy[j];
//            NSString *quesID = model.quesID;
//            if ([rightID containsObject:quesID]) {
//                [questions removeObject:model];
//            }
//        }
//        
//        if (questions.count == 0) {
//            [allCards removeObjectAtIndex:i];
//        }
//        
////        NSDictionary *dict = allCards[i];
////        NSArray *value = dict.allValues;
////
////        if ([value.firstObject isKindOfClass:[NSArray class]]) {
////            NSMutableArray *questionModel = value.firstObject;
////            NSMutableArray *questionModelCopy = [questionModel mutableCopy];
////
////
////            for (int j = 0; j < questionModelCopy.count; j++) {
////                QuestionModel *model = questionModelCopy[j];
////                NSString *quesID = model.quesID;
////                if ([rightID containsObject:quesID]) {
////                    [questionModel removeObject:model];
////                }
////            }
////
////            if (questionModel.count == 0) {
////                [allCards removeObjectAtIndex:i];
////            }
//    }
//    
//    return [allCards copy];
//}

+(BOOL)isHtml:(NSString *)string{
    
    if ([NSString stringIsNull:string]) {
        return NO;
    } else {
        
        NSString *last = [string substringFromIndex:(string.length - 1)];
        
        if ([last isEqualToString:@">"]) {
            return YES;
        }
        
        return NO;
    }
}

+(void)additionalAttributes:(NSMutableAttributedString*)attributedString
                  lineSpace:(CGFloat)space
                       font:(UIFont *)font
                      color:(UIColor *)color{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];//调整行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    if (font == nil) {
        NSDictionary *attrs = @{NSParagraphStyleAttributeName:paragraphStyle,
                                NSForegroundColorAttributeName:color
                                };
        
        [attributedString addAttributes:attrs range:NSMakeRange(0, [attributedString length])];
    } else {
        NSDictionary *attrs = @{NSParagraphStyleAttributeName:paragraphStyle,
                                NSFontAttributeName:font,
                                NSForegroundColorAttributeName:color
                                };
        
        [attributedString addAttributes:attrs range:NSMakeRange(0, [attributedString length])];
    }
}


@end
