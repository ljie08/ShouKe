//
//  ExerciseDelegate.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/18.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#ifndef ExerciseDelegate_h
#define ExerciseDelegate_h

@protocol ExerciseDelegate <NSObject>

@optional
-(void)finishQuesSeletion:(NSDictionary *)dict;//每题完成

-(void)jumpToNextPage:(NSInteger)page;// 跳转下一题
-(void)exerciseIsFinished;//当前关卡题目答完
-(void)currentPage:(NSInteger)page;//考试 当前题目页面

-(void)addNewNoteButtonClick:(UIButton *)button;
-(void)addNewQAButtonClick:(UIButton *)button;

-(void)addGuideViewRect:(CGRect)rect;

@end


#endif /* ExerciseDelegate_h */
