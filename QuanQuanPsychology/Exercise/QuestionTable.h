//
//  QuestionTable.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/22.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseDelegate.h"


@interface QuestionTable : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) ExerciseModule module;

@property (strong, nonatomic) NSString *moduleString;/* 模块 */

@property (weak, nonatomic) id<ExerciseDelegate>exerciseDelegate;

@property (assign, nonatomic) NSInteger totalNo;/* 问题总数量 */

@property (strong, nonatomic) QuestionModel *question;/* 题目 */

@property (strong, nonatomic) NSString *status;/* 对错 */

@property (strong, nonatomic) NSString *userAns;/* 用户选项 */

// default NO. if YES, show analysis cell
@property (assign, nonatomic) BOOL analysisStatus;/* 是否显示解析 */

// default YES. if NO, hidden question number
@property (assign, nonatomic) BOOL showQuestionNo;/* 是否显示题号 */


@end
