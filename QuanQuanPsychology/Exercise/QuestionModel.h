//
//  QuestionModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/17.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,QuestionType) {
    QUESTION_SINGLE = 1, //单选
    QUESTION_MUTIPLE = 2 //多选
};

typedef NS_ENUM(NSUInteger, ExerciseResult) {
    EXERCISE_CORRECT,
    EXERCISE_INCORRECT,
    EXERCISE_UNSELECTED
};

@interface QuestionModel : NSObject

/* 后台返回 model */
@property (strong, nonatomic) NSString *quesID;/* 题目ID */

@property (assign, nonatomic) NSInteger questionType;/* 题目类型 1单选 2多选 */

@property (strong, nonatomic) NSString *title;/* 题干 */

@property (strong, nonatomic) NSString *titleYear;/* 题干年份 */

@property (strong, nonatomic) NSString *titleType;/* 题干类型 1无图 2有图 */

@property (strong, nonatomic) NSString *titleURL;/* 题干图片url */

@property (strong, nonatomic) NSMutableArray *options;/* 选项 */

@property (strong, nonatomic) NSString *answer;/* 答案 */

@property (strong, nonatomic) NSString *analysis;/* 解析 */

/* 自定义 */

@property (assign, nonatomic) ExerciseResult exeResult;/* 用户正误未选 */

@property (strong, nonatomic) NSString *userAnswer;/* 用户所选答案 */

/* height */
@property (assign, nonatomic) CGFloat titleH;/* 题干高度 */

@property (strong, nonatomic) NSMutableArray *optionHs;/* 选项高度 */

@property (assign, nonatomic) CGFloat analysisH;/* 解析高度 */

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
