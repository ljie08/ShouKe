//
//  ChallengeExerciseViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 16/11/2.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChallengeModel;

@interface ChallengeExerciseViewController : QQBasicViewController

@property (strong, nonatomic) NSArray *allQues;

/*  */
@property (strong, nonatomic) ChallengeModel *challenge;

/*  */
@property (copy, nonatomic) NSString *currentLevel;

@property (copy, nonatomic) NSArray *challengeModels;


@end
