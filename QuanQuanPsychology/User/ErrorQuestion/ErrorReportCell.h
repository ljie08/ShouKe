//
//  ErrorReportCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/9.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorReportCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *number;

-(void)configureCellWithNumber:(NSString *)number isCorrect:(BOOL)correct;


@end
