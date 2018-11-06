//
//  ExerciseExtension.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/18.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ExerciseBackground) {
    EXERCISE_NO_CHOICE,
    EXERCISE_SELECTED,
    EXERCISE_RIGHT,
    EXERCISE_WRONG
};

typedef NS_ENUM(NSUInteger, ExerciseModule) {
    EXERCISE_PK = 0,
    EXERCISE_STUDY = 2,
    EXERCISE_CHALLENGE = 3,
    EXERCISE_EXAM = 4,
    EXERCISE_SMARTSTUDY = 5,
    EXERCISE_ERROR = 6
};

@interface ExerciseExtension : NSObject

//题干转化
+(NSString *)formatterQuestion:(QuestionModel *)question
                     withIndex:(NSInteger)index
                     showIndex:(BOOL)show;

//index转字母
+(NSString *)changeIndexToAlphabet:(NSInteger)index;

//字母转index
+(NSInteger)changeAlphabetToIndex:(NSString *)alphabet;

//用户正误未选判断
+(ExerciseResult)covertUserAnswerWithStatus:(NSString *)status;

//保存用户做题信息
+(NSDictionary *)userAnswerWithQuesID:(NSString *)quesID
                          errorAnswer:(NSString *)error
                               status:(NSString *)status
                               moduel:(NSString *)module;

//用户全部选项 包含未做的题目
+(NSArray *)combineAllUserAnswer:(NSMutableArray *)userAnswers
                     withAllQues:(NSMutableArray *)allQues
                          module:(NSString *)module
                        forSever:(BOOL)forSever;

//仅为用户做错题目的错误选项
+(NSArray *)filterUserErrorAnswer:(NSMutableArray *)userAnswers
                      withAllQues:(NSMutableArray *)allQues
                           module:(NSString *)module;

//仅为用户做错题目的题干
+(NSArray *)filterErrorQues:(NSMutableArray *)userAnswers
                withAllQues:(NSMutableArray *)allQues;

// 考试模块 技能卷 -- 用户做错题目的卡片内容
+(NSArray *)filterErrorCards:(NSMutableArray *)userAnswers
                withAllCards:(NSMutableArray *)allCards;

// 是否为H5
+(BOOL)isHtml:(NSString *)string;

// 文本附加属性 
+(void)additionalAttributes:(NSMutableAttributedString*)attributedString
                  lineSpace:(CGFloat)space
                       font:(UIFont *)font
                      color:(UIColor *)color;
@end
