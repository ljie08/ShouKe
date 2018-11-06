//
//  ErrorReportCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/9.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "ErrorReportCell.h"

@implementation ErrorReportCell

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
