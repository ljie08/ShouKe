//
//  QuestionCell.h
//  QuanQuan
//
//  Created by Jocelyn on 16/9/9.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *qType;

@property (weak, nonatomic) IBOutlet UILabel *qTime;

@property (weak, nonatomic) IBOutlet UILabel *qNo;

@property (weak, nonatomic) IBOutlet UILabel *qcontent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qTypeL;


-(void)configureCellWithQuesIndex:(NSInteger)index
                        showIndex:(BOOL)show
                            model:(QuestionModel *)question;


@end
