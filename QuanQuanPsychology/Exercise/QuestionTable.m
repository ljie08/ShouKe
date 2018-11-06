//
//  QuestionTable.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/22.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "QuestionTable.h"

#import "QuestionCell.h"
#import "QuestionImageCell.h"
#import "OptionCell.h"
#import "SubmitTVCell.h"
#import "AnalysisCell.h"

#import "FullImageView.h"

@interface QuestionTable()<ExerciseSubmitDelegate>

@property (strong, nonatomic) NSIndexPath *currentSelectIndex;/* 当前选择的indexpath */

@property (strong, nonatomic) NSMutableArray *chooseArray;/* 用户该题的多选答案 */

@property (strong, nonatomic) NSMutableDictionary *submitBtnEnabledDict;/* 提交按钮是否可以点击 */

@property (strong, nonatomic) NSMutableDictionary *heightDict;/* 行高字典 */

@end

@implementation QuestionTable

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSetting];

    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initSetting];
}

-(void)initSetting{
    self.delegate = self;
    self.dataSource = self;
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = NO;
    
    self.showQuestionNo = YES;
    
    self.submitBtnEnabledDict = [NSMutableDictionary dictionary];
    self.heightDict = [NSMutableDictionary dictionary];
    
}

-(NSMutableArray *)chooseArray{
    if (!_chooseArray) {
        
        if (self.userAns) {
            NSArray *answer = [self.userAns componentsSeparatedByString:@"、"];
            _chooseArray = [answer mutableCopy];
        } else {
            _chooseArray = [NSMutableArray array];
        }
    }
    
    return _chooseArray;
}

-(NSString *)moduleString{
    
    if (!_moduleString) {
        switch (self.module) {
            case EXERCISE_STUDY:
                _moduleString = STUDY;
                break;
                
            case EXERCISE_CHALLENGE:
                _moduleString = CHALLENGE;
                break;
                
            case EXERCISE_EXAM:
                _moduleString = EXAM;
                break;
                
            case EXERCISE_SMARTSTUDY:
                _moduleString = SMARTSTUDY;
                break;
                
            default:
                _moduleString = STUDY;
                break;
        }
    }
    
    return _moduleString;
}


#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.question.questionType == QUESTION_SINGLE) {
        return 3;
    }
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            if ([self.question.titleType isEqualToString:QUESTIONHASIMAGE]) {
                return 2;
            } else {
                return 1;
            }
        }
            break;
            
        case 1:
            return self.question.options.count;
        break;
            
        case 2:
        {
            if (self.question.questionType == QUESTION_SINGLE) {
                return 2;//单选 答案+解析
            } else {
                return 1;//提交按钮
            }
        }
        break;
            
        case 3:
            return 2;//多选 答案+解析
        break;
            
        default:
            return 0;
            break;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *question = @"QuestionCell";
    static NSString *questionImage = @"QuestionImageCell";
    static NSString *option = @"OptionCell";
    static NSString *analysis = @"AnalysisCell";
    static NSString *submit = @"SubmitTVCell";

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:question];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExerciseCells" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            [cell configureCellWithQuesIndex:tableView.tag
                                   showIndex:self.showQuestionNo model:self.question];
            
            return cell;
            
        } else {
            
            QuestionImageCell *cell = [tableView dequeueReusableCellWithIdentifier:questionImage];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExerciseCells" owner:nil options:nil];
                cell = [nib objectAtIndex:4];
            }

            [cell configureCellWithModel:self.question];
            
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        
        OptionCell *cell = [tableView dequeueReusableCellWithIdentifier:option];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExerciseCells" owner:nil options:nil];
            cell = [nib objectAtIndex:1];
        }
        
        NSString *userAnswer = [self.chooseArray componentsJoinedByString:@"、"];
        
        [cell configureCellWithIndex:indexPath
                               model:self.question
                          userStatus:self.status
                          userAnswer:userAnswer];
        
        return cell;
        
    } else {
        
        if (indexPath.section == 2 && self.question.questionType == QUESTION_MUTIPLE) {
            
            SubmitTVCell *cell = [tableView dequeueReusableCellWithIdentifier:submit];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExerciseCells" owner:nil options:nil];
                cell = [nib objectAtIndex:2];
            }
            
            NSString *key = [NSString stringWithFormat:@"%ld",tableView.tag];
            
            NSNumber *enable = [self.submitBtnEnabledDict valueForKey:key];
            
            cell.submitBtn.enabled = [enable boolValue];
            
            cell.delegate = self;
            
            return cell;
        } else {
            
            
            AnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:analysis];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExerciseCells" owner:nil options:nil];
                cell = [nib objectAtIndex:3];
            }
            
            cell.indexPath = indexPath;
            cell.analysisStatus = self.analysisStatus;
            
            [cell configureCellWithModel:self.question];
            
            return cell;
            
            
        }
    }

}

#pragma mark - <UITableViewDelegate>


/** collection view tag
 701 == 学习模块练习题
 702 == 练习模块练习题
 703 == 无限挑战练习题
 704 == 考试模块练习题
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if (self.currentSelectIndex != nil && self.currentSelectIndex != indexPath) {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.currentSelectIndex];
//        if ([cell isKindOfClass:[OptionCell class]]) {
//            OptionCell *option = (OptionCell *)cell;
//            [option UpdateCellWithState:NO];
//        }
//    }
    

    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[QuestionImageCell class]]) {
        QuestionImageCell *image = (QuestionImageCell *)cell;
        
        FullImageView *fullImage = [[FullImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[UIApplication sharedApplication].keyWindow addSubview:fullImage];
        [fullImage showBigPicWithImage:image.questionImage.image];
        
    } else if ([cell isKindOfClass:[OptionCell class]]) {
        
        OptionCell *option = (OptionCell *)cell;
        [option UpdateCellWithState:!option.isSelected];
        
        NSString *rightAnswer = self.question.answer;
        
        NSString *index = [ExerciseExtension changeIndexToAlphabet:indexPath.row];
        
        NSString *key = [NSString stringWithFormat:@"%ld",(long)tableView.tag];
        
        if (self.question.questionType == QUESTION_SINGLE) {
            
            //            self.currentSelectIndex = indexPath;
            
            
            if ([rightAnswer isEqualToString:index]) {
                
                NSDictionary *dict = [ExerciseExtension userAnswerWithQuesID:self.question.quesID errorAnswer:@"" status:ANSWERRIGHT moduel:self.moduleString];
                [self.exerciseDelegate finishQuesSeletion:dict];
                
            } else {
                
                NSDictionary *dict = [ExerciseExtension userAnswerWithQuesID:self.question.quesID errorAnswer:index status:ANSWERWRONG moduel:self.moduleString];
                [self.exerciseDelegate finishQuesSeletion:dict];
                
            }
            
            switch (self.module) {
                case EXERCISE_EXAM:
                {
                    [self.exerciseDelegate jumpToNextPage:self.tag];
                }
                    break;
                    
                case EXERCISE_SMARTSTUDY:
                {
                    if (tableView.tag == self.totalNo - 1) {
                        [self.exerciseDelegate exerciseIsFinished];
                    } else {
                        [self.exerciseDelegate jumpToNextPage:self.tag];
                    }
                }
                    break;
                    
                default:
                {
                    if (tableView.tag == self.totalNo - 1) {
                        [self.exerciseDelegate exerciseIsFinished];
                    } else {
                        [self.exerciseDelegate jumpToNextPage:self.tag];
                    }
                    self.allowsSelection = NO;
                }
                    break;
            }
            
        } else {
            
            if (option.isSelected) {
                [self.chooseArray addObject:index];
            } else{
                [self.chooseArray removeObject:index];
            }
            
            if (self.chooseArray.count == 0 ) {
                NSNumber *enable = [NSNumber numberWithBool:NO];
                [self.submitBtnEnabledDict setValue:enable forKey:key];
            } else {
                NSNumber *enable = [NSNumber numberWithBool:YES];
                [self.submitBtnEnabledDict setValue:enable forKey:key];
            }
            
            [self reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger count = self.question.options.count + 2;

    if (self.question.questionType == QUESTION_SINGLE) {

        if ([self.question.titleType isEqualToString:QUESTIONHASIMAGE]) {
            count = count + 2;
        } else {
            count = count + 1;
        }
    } else {
        if ([self.question.titleType isEqualToString:QUESTIONHASIMAGE]) {
            count = count + 2 + 1;
        } else {
            count = count + 1 + 1;
        }

    }


    if (self.heightDict.count == count) {

        return [[self.heightDict valueForKey:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row]] floatValue];
    } else {

        CGFloat labelHeight;//文本label高度
        
        CGFloat height;//cell高度

        if (indexPath.section == 0) {

            if (indexPath.row == 0) {
                
                if ([ExerciseExtension isHtml:self.question.title]) {
                    
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[self.question.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    
                    [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];

                    
                    labelHeight = [attributedString boundingRectWithSize:CGSizeMake(self.frame.size.width - 20 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
                    
                } else {
                    
                    labelHeight = [QuanUtils caculateLabelHeightWithText:self.question.title lineSpacing:6 andFont:[UIFont systemFontOfSize:15] andViewSize:CGSizeMake(self.frame.size.width - 20 * 2, MAXFLOAT)];
                    
                }
                
                height = 72 - 18 + labelHeight;


            } else {
                height = 160;
            }

        } else if (indexPath.section == 1){

            if ([ExerciseExtension isHtml:self.question.options[indexPath.row]]) {
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithData:[self.question.options[indexPath.row] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                
                [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];

                
                labelHeight = [attributedString boundingRectWithSize:CGSizeMake(self.frame.size.width - 20 * 2 - 25 - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
                
            } else {
                NSString *text = self.question.options[indexPath.row];

                labelHeight = [QuanUtils caculateLabelHeightWithText:text lineSpacing:6 andFont:[UIFont systemFontOfSize:15] andViewSize:CGSizeMake(self.frame.size.width - 20 * 2 - 25 - 10, MAXFLOAT)];
                
            }

            height = 12 * 2 + labelHeight;


        } else {

            if (indexPath.section == 2 && self.question.questionType == QUESTION_MUTIPLE) {
                height = 120;
            } else {
                if (indexPath.row == 0) {
                    height = 30;
                    
                } else {

                    if (self.analysisStatus) {
                        
                        if ([ExerciseExtension isHtml:self.question.analysis]) {
                            
                            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithData:[self.question.analysis dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                            
                            [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];

                            
                            labelHeight = [attributedString boundingRectWithSize:CGSizeMake(self.frame.size.width - 20 - 31, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
                            
                        } else {
                            
                            labelHeight = [QuanUtils caculateLabelHeightWithText:self.question.analysis lineSpacing:6 andFont:[UIFont systemFontOfSize:15] andViewSize:CGSizeMake(self.frame.size.width - 20 - 31, MAXFLOAT)];
                            
                        }
                        
                        height = 65 - 18 + labelHeight;

                    } else {
                        height = 0;
                    }

                }
            }

        }

        [self.heightDict setObject:[NSString stringWithFormat:@"%f",height] forKey:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row]];

        return height;

    }


}

#pragma mark - <ExerciseSubmitDelegate>
-(void)submitButtonClicked:(UIButton *)button{
    if (self.chooseArray.count == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.alpha = 0.7;
        hud.label.text = @"选项为空";
        [hud hideAnimated:YES afterDelay:1];
        
    } else {
        
        NSArray *rightAnswer = [self.question.answer componentsSeparatedByString:@"、"];
        
        //考试模块 module == 4
        if ([self compareUserAnswer:self.chooseArray withRightAnswer:rightAnswer]) {
            
            NSDictionary *dict = [ExerciseExtension userAnswerWithQuesID:self.question.quesID errorAnswer:@"" status:ANSWERRIGHT moduel:self.moduleString];
            [self.exerciseDelegate finishQuesSeletion:dict];
            
        } else {
            
            NSString *userAnswer = [self.chooseArray componentsJoinedByString:@"、"];
            NSDictionary *dict = [ExerciseExtension userAnswerWithQuesID:self.question.quesID errorAnswer:userAnswer status:ANSWERWRONG moduel:self.moduleString];
            [self.exerciseDelegate finishQuesSeletion:dict];
            
        }
        
        if (self.module == EXERCISE_EXAM) {
            [self.exerciseDelegate jumpToNextPage:self.tag];
        } else {
            self.allowsSelection = NO;
            
            if (self.tag == self.totalNo - 1) {
                [self.exerciseDelegate exerciseIsFinished];
            } else {
                [self.exerciseDelegate jumpToNextPage:self.tag];
            }
        }
    }
}

/* 多选判断用户选项和正确答案是否一样 */
-(BOOL)compareUserAnswer:(NSArray *)userAnswer withRightAnswer:(NSArray *)rightAnswer{
    
    NSMutableArray *user = [NSMutableArray arrayWithArray:userAnswer];
    NSMutableArray *right = [NSMutableArray arrayWithArray:rightAnswer];
    
    [user sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return obj1 > obj2;
    }];
    
    [right sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return obj1 > obj2;
    }];
    
    BOOL correct = YES;
    
    if (user.count == right.count) {
        
        for (int i = 0; i < user.count; i++) {
            
            NSString *u = [user objectAtIndex:i];
            NSString *r = [right objectAtIndex:i];
            
            if (![u isEqualToString:r]) {
                correct = NO;
                break;
            }
        }
    } else {
        correct = NO;
    }
    
    return correct;
}

@end
