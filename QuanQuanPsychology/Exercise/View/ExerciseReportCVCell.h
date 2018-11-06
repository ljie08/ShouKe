//
//  ExerciseReportCVCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/24.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseReportCVCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *number;

-(void)configureCellWithNumber:(NSString *)number isCorrect:(BOOL)correct;


@end
