//
//  QuestionCell.m
//  QuanQuan
//
//  Created by Jocelyn on 16/9/9.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithQuesIndex:(NSInteger)index
                        showIndex:(BOOL)show
                            model:(QuestionModel *)question{
    
    
    
    if (question.questionType == QUESTION_SINGLE) {
        self.qType.layer.cornerRadius = self.qType.frame.size.height / 2;
    } else {
        self.qType.text = @"多选";
    }
    
    self.qType.layer.borderWidth = 0.5;
    self.qType.layer.borderColor = [UIColor customisMainGreen].CGColor;
    self.qType.layer.masksToBounds = YES;
        
    if ([NSString stringIsNull:question.titleYear]) {
        self.qTime.text = @"";
    } else {
        self.qTime.text = [NSString stringWithFormat:@"(%@)",question.titleYear];
    }
    
    self.qNo.text = [NSString stringWithFormat:@"%ld、",(index + 1)];

    self.qNo.hidden = !show;
    
    if (show) {
        self.qTypeL.constant = self.qNo.frame.size.width + self.qNo.frame.origin.x + 3;
    } else {
        self.qTypeL.constant = 15;
    }
    
    
    NSString *content = question.title;
    
    if (![NSString stringIsNull:content]) {
        if ([ExerciseExtension isHtml:content]) {
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            
            
            [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];
            
            self.qcontent.attributedText = attributedString;
            
        } else {
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
            
            [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];
            
            self.qcontent.attributedText = attributedString;
        }
    }
}



@end
