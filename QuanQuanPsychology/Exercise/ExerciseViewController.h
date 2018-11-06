//
//  ExerciseViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 16/11/2.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExerciseViewController : QQBasicViewController

@property (strong, nonatomic) NSArray *allQues;

@property (strong, nonatomic) NSString *cardID;//当前知识卡ID

@property (strong, nonatomic) NSString *lastCardID;//最后一张知识卡ID

@property (assign, nonatomic) BOOL isCardPackage;



@end
