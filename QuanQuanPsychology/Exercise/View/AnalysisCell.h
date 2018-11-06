//
//  AnalysisCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/2.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysisCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) BOOL analysisStatus;//是否显示解析

@property (assign, nonatomic) BOOL analysisTable;//是否为解析列表

-(void)configureCellWithModel:(QuestionModel *)question;

@end
