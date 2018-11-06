//
//  AnalysisTable.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/2.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "AnalysisTable.h"

#import "QuestionCell.h"
#import "QuestionImageCell.h"
#import "OptionCell.h"
#import "AnalysisCell.h"

#import "FullImageView.h"


@interface AnalysisTable()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableDictionary *heightDict;/* 行高字典 */


@end

@implementation AnalysisTable

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSetting];
        
        
    }
    return self;
}

-(void)initSetting{
    
    self.delegate = self;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = NO;
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    
    self.heightDict = [NSMutableDictionary dictionary];
    
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section == 0) {
        
        if ([self.question.titleType isEqualToString:QUESTIONHASIMAGE]) {
            return 2;
        } else {
            return 1;
        }
        
    } else if (section == 1) {
        return self.question.options.count;
    } else {
        return 3;//正确答案+我的答案+解析
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *question = @"QuestionCell";
    static NSString *questionImage = @"QuestionImageCell";
    static NSString *option = @"OptionCell";
    static NSString *analysis = @"AnalysisCell";

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
        cell.analysisTable = YES;

        [cell configureAnalysisCellWithIndex:indexPath
                                       model:self.question
                                  userStatus:self.status
                                  userAnswer:self.userAns];
        
        return cell;
        
    } else {
        
        AnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:analysis];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExerciseCells" owner:nil options:nil];
            cell = [nib objectAtIndex:3];
        }
        
        cell.indexPath = indexPath;
        cell.analysisStatus = self.analysisStatus;
        cell.analysisTable = YES;
        self.question.exeResult = [ExerciseExtension covertUserAnswerWithStatus:self.status];
        self.question.userAnswer = self.userAns;
        
        [cell configureCellWithModel:self.question];
        
        return cell;
        
        
        
    }
        
}

#pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        
        if (indexPath.row != 2) {
            height = 30;
        } else {
            
            if ([ExerciseExtension isHtml:self.question.analysis]) {
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithData:[self.question.analysis dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                
                [ExerciseExtension additionalAttributes:attributedString lineSpace:6 font:[UIFont systemFontOfSize:15] color:[UIColor customisDarkGreyColor]];
                
                
                labelHeight = [attributedString boundingRectWithSize:CGSizeMake(self.frame.size.width - 20 - 31, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
                
            } else {
                
                labelHeight = [QuanUtils caculateLabelHeightWithText:self.question.analysis lineSpacing:6 andFont:[UIFont systemFontOfSize:15] andViewSize:CGSizeMake(self.frame.size.width - 20 - 31, MAXFLOAT)];
                
            }
            
            height = 65 - 18 + labelHeight;
            
            
        }
    }
    
//    [self.heightDict setObject:[NSString stringWithFormat:@"%f",height] forKey:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row]];
    
    return height;
    
}


@end
