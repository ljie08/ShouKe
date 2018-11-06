//
//  OptionCell.h
//  QuanQuan
//
//  Created by Jocelyn on 16/9/9.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *optionBackground;


@property (weak, nonatomic) IBOutlet UIButton *optionIcon;

@property (weak, nonatomic) IBOutlet UILabel *ocontent;

@property (assign, nonatomic) NSInteger page;

@property (assign, nonatomic) BOOL isSelected;

@property (assign, nonatomic) BOOL analysisTable;//是否为解析列表

-(void)UpdateCellWithState:(BOOL)select;

-(void)configureCellWithIndex:(NSIndexPath *)indexPath
                        model:(QuestionModel *)question
                   userStatus:(NSString *)status
                   userAnswer:(NSString *)userAnswer;

-(void)configureAnalysisCellWithIndex:(NSIndexPath *)indexPath
                                model:(QuestionModel *)question
                           userStatus:(NSString *)status
                           userAnswer:(NSString *)userAnswer;

@end
