//
//  FinishViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 2016/12/29.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishViewController : QQBasicViewController

@property (strong, nonatomic) NSArray *errorQues;/* 错题 */

@property (strong, nonatomic) NSArray *userErrorAnswers;/* 用户错题选项 */

@property (strong, nonatomic) NSArray *allQues;/* 全部题目 */

@property (strong, nonatomic) NSArray *allUserAnswers;/* 全部用户选项 */

@property (strong, nonatomic) NSDictionary *questionID;/* 题目编号对应id */

@property (strong, nonatomic) NSString *cardID;//当前知识卡ID

@property (strong, nonatomic) NSString *lastCardID;//最后一张知识卡ID

@property (assign, nonatomic) BOOL checkAnalysis;//是否查看解析做对

@property (assign, nonatomic) BOOL isCardPackage;


@end
