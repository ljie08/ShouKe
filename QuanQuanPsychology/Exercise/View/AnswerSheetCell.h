//
//  AnswerSheetCell.h
//  QuanQuan
//
//  Created by Jocelyn on 16/11/2.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerSheetCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *number;

@property (strong, nonatomic) NSString *quesID;

-(void)checkID;

@end
