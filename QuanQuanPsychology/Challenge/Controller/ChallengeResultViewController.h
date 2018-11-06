//
//  ChallengeResultViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 2016/12/26.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChallengeModel;

@interface ChallengeResultViewController : QQBasicViewController

@property (strong, nonatomic) NSArray *allErrorQues;/* 错题 */

@property (strong, nonatomic) NSArray *userAnswers;/* 用户选项 */

@property (assign, nonatomic) NSInteger currentLevel;/* 当前关卡 */

@property (assign, nonatomic) BOOL pass;/* 是否通过挑战 */

/*  */
@property (strong, nonatomic) ChallengeModel *challenge;

/*  */
@property (assign, nonatomic) CGFloat accuracy;

@property (copy, nonatomic) NSArray *challengeModels;


@end
