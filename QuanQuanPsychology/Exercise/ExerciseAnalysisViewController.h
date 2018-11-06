//
//  ExerciseAnalysisViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/24.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseAnalysisViewController : QQBasicViewController

@property (strong, nonatomic) NSArray *errorQues;/* 错题 */

@property (strong, nonatomic) NSArray *userErrorAnswers;/* 用户错题选项 */

@property (strong, nonatomic) NSArray *allQues;/* 全部题目 */

@property (strong, nonatomic) NSArray *allUserAnswers;/* 全部用户选项 */

@property (assign, nonatomic) BOOL showAllAnalysis;/* 是否显示全部解析 */

@property (assign, nonatomic) NSInteger page;

@end
