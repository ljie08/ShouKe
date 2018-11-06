//
//  OptionCell.m
//  QuanQuan
//
//  Created by Jocelyn on 16/9/9.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "OptionCell.h"

@interface OptionCell()

@property (strong, nonatomic) NSArray *icons;/* 单选 */

@property (strong, nonatomic) NSArray *selectedIcons;/* 单选选中 */

@property (strong, nonatomic) NSArray *multiIcons;/* 多选 */

@property (strong, nonatomic) NSArray *multiSelectedIcons;/* 多选选中 */

@property (assign, nonatomic) NSInteger questionType;

@end

@implementation OptionCell

-(NSArray *)icons{
    if (!_icons) {
        if (self.questionType == QUESTION_SINGLE) {
            _icons = @[[UIImage imageNamed:@"A"],
                       [UIImage imageNamed:@"B"],
                       [UIImage imageNamed:@"C"],
                       [UIImage imageNamed:@"D"],
                       [UIImage imageNamed:@"E"]];
        } else {
            _icons = @[[UIImage imageNamed:@"multiA"],
                       [UIImage imageNamed:@"multiB"],
                       [UIImage imageNamed:@"multiC"],
                       [UIImage imageNamed:@"multiD"],
                       [UIImage imageNamed:@"multiE"]];
        }
        
    }
    return _icons;
}

-(NSArray *)selectedIcons{
    if (!_selectedIcons) {
        
        if (self.questionType == QUESTION_SINGLE) {
            if (self.analysisTable) {
                _selectedIcons = @[[UIImage imageNamed:@"analysisA"],
                                   [UIImage imageNamed:@"analysisB"],
                                   [UIImage imageNamed:@"analysisC"],
                                   [UIImage imageNamed:@"analysisD"],
                                   [UIImage imageNamed:@"analysisE"]];
            } else {
                _selectedIcons = @[[UIImage imageNamed:@"selectedA"],
                                   [UIImage imageNamed:@"selectedB"],
                                   [UIImage imageNamed:@"selectedC"],
                                   [UIImage imageNamed:@"selectedD"],
                                   [UIImage imageNamed:@"selectedE"]];
            }
            
        } else {
            
            if (self.analysisTable) {
                _selectedIcons = @[[UIImage imageNamed:@"multiAnalysisA"],
                                   [UIImage imageNamed:@"multiAnalysisB"],
                                   [UIImage imageNamed:@"multiAnalysisC"],
                                   [UIImage imageNamed:@"multiAnalysisD"],
                                   [UIImage imageNamed:@"multiAnalysisE"]];
            } else {
                _selectedIcons = @[[UIImage imageNamed:@"multiselectedA"],
                                   [UIImage imageNamed:@"multiselectedB"],
                                   [UIImage imageNamed:@"multiselectedC"],
                                   [UIImage imageNamed:@"multiselectedD"],
                                   [UIImage imageNamed:@"multiselectedE"]];
            }
            
        }
        
    }
    return _selectedIcons;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    self.optionIcon.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configureCellWithIndex:(NSIndexPath *)indexPath
                        model:(QuestionModel *)question
                   userStatus:(NSString *)status
                   userAnswer:(NSString *)userAnswer{
    
    self.questionType = question.questionType;
    
    NSString *content = question.options[indexPath.row];
    
    if ([ExerciseExtension isHtml:content]) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];

        self.ocontent.attributedText = attributedString;
        
    } else {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        
        [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];

        self.ocontent.attributedText = attributedString;
    }
    
    [self.optionIcon setBackgroundImage:self.icons[indexPath.row] forState:UIControlStateNormal];
    [self.optionIcon setBackgroundImage:self.selectedIcons[indexPath.row] forState:UIControlStateSelected];
    
    //选中背景色
    [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.03]] forState:UIControlStateSelected];
    
    if (status != nil) {
        
        NSInteger row = 0;//行数
        NSMutableArray *mutipleRows = [NSMutableArray array];//多选行数
        
        if ([status isEqualToString:@"0"]) {
            row = [ExerciseExtension changeAlphabetToIndex:userAnswer];
            NSArray *errorAns = [userAnswer componentsSeparatedByString:@"、"];
            mutipleRows = [errorAns mutableCopy];
        } else {
            row = [ExerciseExtension changeAlphabetToIndex:question.answer];
            NSArray *answer = [question.answer componentsSeparatedByString:@"、"];
            mutipleRows = [answer mutableCopy];
        }
        
        switch (question.questionType) {
            case QUESTION_SINGLE:
            {
                
                if (indexPath.row == row) {
                    [self UpdateCellWithState:!self.isSelected];
                } else {
                    [self UpdateCellWithState:self.isSelected];
                }
            }
                break;
                
            case QUESTION_MUTIPLE:
            {
                [self UpdateCellWithState:NO];
                
                for (NSString *string in mutipleRows) {
                    NSInteger mutipleRow = [ExerciseExtension changeAlphabetToIndex:string];
                    if (mutipleRow == indexPath.row) {
                        [self UpdateCellWithState:YES];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)configureAnalysisCellWithIndex:(NSIndexPath *)indexPath
                                model:(QuestionModel *)question
                           userStatus:(NSString *)status
                           userAnswer:(NSString *)userAnswer{
    
    self.questionType = question.questionType;

    NSString *content = question.options[indexPath.row];
    
    if ([ExerciseExtension isHtml:content]) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];
        
        self.ocontent.attributedText = attributedString;
        
    } else {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        
        [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];
        
        self.ocontent.attributedText = attributedString;
    }
    
    NSInteger row = [ExerciseExtension changeAlphabetToIndex:userAnswer];

    if ([status isEqualToString:@"1"]) {
        row = [ExerciseExtension changeAlphabetToIndex:question.answer];
    }
    
    NSInteger rightRow = [ExerciseExtension changeAlphabetToIndex:question.answer];
    
    
    switch (question.questionType) {
        case QUESTION_SINGLE:
            {
                if (indexPath.row == row  && row == rightRow) {
                    [self.optionIcon setBackgroundImage:[UIImage imageNamed:@"单选-对"] forState:UIControlStateNormal];
                    [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[[UIColor colorwithHexString:@"#20C997"] colorWithAlphaComponent:0.06]] forState:UIControlStateNormal];
                    
                } else {
                    
                    if (indexPath.row == row) {
                        [self.optionIcon setBackgroundImage:[UIImage imageNamed:@"单选-错"] forState:UIControlStateNormal];
                       
                        [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[[UIColor colorwithHexString:@"#FF2D55"] colorWithAlphaComponent:0.06]] forState:UIControlStateNormal];
                        
                    } else if (indexPath.row == rightRow) {
                        [self.optionIcon setBackgroundImage:self.selectedIcons[indexPath.row] forState:UIControlStateNormal];

                        [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[[UIColor colorwithHexString:@"#20C997"] colorWithAlphaComponent:0.06]] forState:UIControlStateNormal];
                    } else {
                        [self.optionIcon setBackgroundImage:self.icons[indexPath.row] forState:UIControlStateNormal];
                        [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                    }
                    
                }
                
                
            }
            break;
            
        case QUESTION_MUTIPLE:
        {
            
            [self.optionIcon setBackgroundImage:self.icons[indexPath.row] forState:UIControlStateNormal];
            [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            
            NSArray *userAnswers = [userAnswer componentsSeparatedByString:@"、"];
            NSArray *answer = [question.answer componentsSeparatedByString:@"、"];
            
            NSPredicate *rightPredicate = [NSPredicate predicateWithFormat:@"SELF IN %@",userAnswers];
            
            NSPredicate *wrongPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",answer];
            
            NSPredicate *missPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",userAnswers];
            
            
            //过滤数组
            NSArray *right = [answer filteredArrayUsingPredicate:rightPredicate];
            NSArray *wrong = [userAnswers filteredArrayUsingPredicate:wrongPredicate];
            NSArray *miss = [answer filteredArrayUsingPredicate:missPredicate];
            
            //                NSLog(@"right = %@, wrong = %@, miss = %@",right, wrong, miss);
            
            //对用户所选选项判断正误
            
            for (NSString *string in right) {
                
                NSInteger row = [ExerciseExtension changeAlphabetToIndex:string];
                if (row == indexPath.row) {
                    [self.optionIcon setBackgroundImage:[UIImage imageNamed:@"多选-对"] forState:UIControlStateNormal];
                    [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[[UIColor colorwithHexString:@"#20C997"] colorWithAlphaComponent:0.06]] forState:UIControlStateNormal];
                    
                }
            }
            
            for (NSString *string in wrong) {
                
                NSInteger row = [ExerciseExtension changeAlphabetToIndex:string];
                if (row == indexPath.row) {
                    [self.optionIcon setBackgroundImage:[UIImage imageNamed:@"多选-错"] forState:UIControlStateNormal];
                    [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[[UIColor colorwithHexString:@"#FF2D55"] colorWithAlphaComponent:0.06]] forState:UIControlStateNormal];
                }
            }
            
            //用户未选择的判断是否为遗漏答案
            for (NSString *string in miss) {
                NSInteger row = [ExerciseExtension changeAlphabetToIndex:string];
                if (row == indexPath.row) {
                    [self.optionIcon setBackgroundImage:self.selectedIcons[indexPath.row] forState:UIControlStateNormal];
                    [self.optionBackground setBackgroundImage:[QuanUtils imageWithColor:[[UIColor colorwithHexString:@"#20C997"] colorWithAlphaComponent:0.06]] forState:UIControlStateNormal];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
}

-(void)UpdateCellWithState:(BOOL)select{
    self.optionIcon.selected = select;
    self.optionBackground.selected = select;
    _isSelected = select;
}

@end
