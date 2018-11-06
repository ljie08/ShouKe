//
//  AnalysisCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/2.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "AnalysisCell.h"

@interface AnalysisCell()

@property (weak, nonatomic) IBOutlet UIView *icon;

@property (weak, nonatomic) IBOutlet UILabel *item;

@property (weak, nonatomic) IBOutlet UILabel *answer;

@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation AnalysisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithModel:(QuestionModel *)question{
    
    if (self.indexPath.row == 0) {
        self.item.text = @"正确答案：";
        self.answer.text = question.answer;
    } else {
        
        if (self.analysisTable && self.indexPath.row == 1) {
            
            self.item.text = @"我的答案：";
            
            switch (question.exeResult) {
                case EXERCISE_CORRECT:
                {
                    self.answer.text = question.answer;
                }
                    break;
                    
                case EXERCISE_INCORRECT:
                {
                    self.answer.text = question.userAnswer;
                    self.answer.textColor = [UIColor customisMainGreen];
                }
                    break;
                    
                case EXERCISE_UNSELECTED:
                {
                    self.answer.text = @"未选";
                    self.answer.textColor = [UIColor customisMainGreen];
                }
                    break;
            }

        } else {
            
            self.item.text = @"解析：";
            
            NSString *content = question.analysis;
            
            if (![NSString stringIsNull:content]) {
                if ([ExerciseExtension isHtml:content]) {
                    
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    
                    [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];
                    
                    self.content.attributedText = attributedString;
                    
                } else {
                    
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
                    
                    [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];
                    
                    self.content.attributedText = attributedString;
                }
            }
        }
        
    }
    
    if (self.analysisStatus) {
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
    
}

@end
