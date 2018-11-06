//
//  ExerciseReportCVCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/24.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "ExerciseReportCVCell.h"

@implementation ExerciseReportCVCell

-(void)configureCellWithNumber:(NSString *)number isCorrect:(BOOL)correct{
    self.number.text = number;
    if (correct) {
        self.number.backgroundColor = [UIColor colorwithHexString:@"#FFB62A"];
    } else {
        self.number.backgroundColor = [UIColor colorwithHexString:@"#D2D2D2"];
    }
    self.number.layer.cornerRadius = (ScreenWidth * 0.1) / 2;
    self.number.layer.masksToBounds = YES;
}

@end
