//
//  QuestionImageCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/9/7.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *questionImage;

-(void)configureCellWithModel:(QuestionModel *)question;

@end
