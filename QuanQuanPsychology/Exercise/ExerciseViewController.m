//
//  ExerciseViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/11/2.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ExerciseViewController.h"
#import "FinishViewController.h"

#import "CollectionZoomFlowLayout.h"

#import "QuestionTable.h"
#import "StudyExerciseCell.h"

#import "UserStudyInfoAPI.h"
#import "CardPackageAPI.h"

#define ExerciseCellWidth  ScreenWidth
#define ExerciseCellHeight ScreenHeight


@interface ExerciseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,ExerciseDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *questions;/* 题目 */

@property (strong, nonatomic) NSMutableArray *userAnswers;/* 用户答案 */

@property (strong, nonatomic) NSMutableDictionary *analysisBtnStatus;/* 每题解析按钮状态 */

@property (strong, nonatomic) NSMutableDictionary *qustionID;/* 题目编号对应id */

@end

@implementation ExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self saveToQustionModel];
    [self updateUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
-(void)saveToQustionModel{
    
    self.analysisBtnStatus = [NSMutableDictionary dictionary];
    self.qustionID = [NSMutableDictionary dictionary];
    
    self.userAnswers = [NSMutableArray array];
    self.questions = [NSMutableArray array];
    
    for (int i = 0 ; i < self.allQues.count; i++) {
        NSDictionary *dict = self.allQues[i];
        QuestionModel *question = [[QuestionModel alloc] initWithDict:dict];
        [self.questions addObject:question];
    }
}

-(void)sendUserExerciseToSever{
    
    NSArray *questionKeys = self.qustionID.allKeys;
    NSArray *analysisKeys = self.analysisBtnStatus.allKeys;
    
    if (![questionKeys isEqualToArray:analysisKeys]) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",questionKeys];

        NSArray *nocheck = [analysisKeys filteredArrayUsingPredicate:predicate];
                
        NSMutableArray *nocheckUserAnswers = [self.userAnswers mutableCopy];
        NSMutableArray *nocheckQuestions = [self.questions mutableCopy];
        
        for (int i = 0; i < nocheck.count; i++) {
            NSString *quesionID = [self.qustionID valueForKey:nocheck[i]];
            
            for (int j = 0; j < nocheckUserAnswers.count; j++) {
                NSDictionary *dict = nocheckUserAnswers[j];
                NSString *answerQuesID = [dict valueForKey:@"question_id"];
                if (quesionID == answerQuesID) {
                    [nocheckUserAnswers removeObject:dict];
                }
            }
            
            for (int k = 0; k < nocheckQuestions.count; k++) {
                QuestionModel *model = nocheckQuestions[k];
                NSString *quesID = model.quesID;
                if (quesionID == quesID) {
                    [nocheckQuestions removeObject:model];
                }
            }
            
        }
        

        NSArray *list = [ExerciseExtension combineAllUserAnswer:nocheckUserAnswers withAllQues:nocheckQuestions module:STUDY forSever:YES];
        
        if (self.isCardPackage) {
            [self sendCardPackageExerciseQuestionWithUID:USERUID cardID:self.cardID quesList:list];
        } else {
            [self sendExerciseQuestionWithUID:USERUID cardID:self.cardID quesList:list];
        }
        
    }
    
}

-(void)sendExerciseQuestionWithUID:(NSString *)uid cardID:(NSString *)cardID quesList:(NSArray *)list{
    
    [UserStudyInfoAPI sendExerciseQuestionWithUID:uid quesList:list callback:^(APIReturnState state, id data, NSString *message) {
        NSLog(@"%@卡片练习问题提交-%@",cardID,message);
    }];
}

-(void)sendCardPackageExerciseQuestionWithUID:(NSString *)uid cardID:(NSString *)cardID quesList:(NSArray *)list{
    
    [CardPackageAPI sendCardPackageExerciseQuestionWithUID:uid cardID:cardID quesList:list callback:^(APIReturnState state, id data, NSString *message) {
        NSLog(@"%@卡包卡片练习问题提交-%@",self.cardID,message);
    }];
}

#pragma mark - UI

-(void)updateUI{
    
    self.title = [NSString stringWithFormat:@"练习（1/%lu）",(unsigned long)self.questions.count];
    

}

-(void)addAnalysisButtonForCell:(UICollectionViewCell *)cell andTag:(NSInteger)tag{
    
    CGFloat size = 44;
    CGFloat x = ExerciseCellWidth - size * 2;
    CGFloat y = cell.frame.size.height * 0.8;
    UIButton *analysisBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, size, size)];
    [analysisBtn setImage:[UIImage imageNamed:@"解析关"] forState:UIControlStateNormal];
    [analysisBtn setImage:[UIImage imageNamed:@"解析开"] forState:UIControlStateSelected];
    analysisBtn.tag = tag;
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)analysisBtn.tag];
    NSNumber *number = [self.analysisBtnStatus valueForKey:key];
    analysisBtn.selected = [number boolValue];
    
    
    analysisBtn.layer.shadowOffset = CGSizeMake(0, 2);
    analysisBtn.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.12].CGColor;
    analysisBtn.layer.shadowRadius = 2;
    analysisBtn.layer.shadowOpacity = 1;
    
    [analysisBtn addTarget: self action:@selector(showAnalysis:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:analysisBtn];
}

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.questions.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"StudyExerciseCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
//    cell.tag = 702;// 标签 练习
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)(indexPath.row + 1)];
    NSNumber *number = [self.analysisBtnStatus valueForKey:key];


    QuestionModel *question = self.questions[indexPath.row];
    [self.qustionID setValue:question.quesID forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

    
    QuestionTable *table = [[QuestionTable alloc] initWithFrame:CGRectMake(0, 0,cell.frame.size.width, cell.frame.size.height)];
    table.module = EXERCISE_STUDY;
    table.tag = indexPath.row;/* tag设置为indexpath.row 相当于page */
    table.totalNo = self.questions.count;
    table.question = question;
    table.exerciseDelegate = self;
    table.analysisStatus = [number boolValue];
    NSString *color = [[NSUserDefaults standardUserDefaults] valueForKey:UDBACKGROUNDCOLOR];
    table.backgroundColor = [UIColor colorwithHexString:color];

    if (self.userAnswers.count != 0) {
        NSMutableArray *array = [NSMutableArray array];

        for (NSDictionary *dict in self.userAnswers) {
            NSString *quesID = dict[@"question_id"];
            [array addObject:quesID];
        }

        if ([array containsObject:question.quesID]) {
            NSInteger index = [array indexOfObject:question.quesID];
            table.status = self.userAnswers[index][@"status"];
            table.userAns = self.userAnswers[index][@"error_answer"];
        }
    }
    [cell.contentView addSubview:table];


    
    [self addAnalysisButtonForCell:cell andTag:(indexPath.row + 1)];

    return cell;

}

#pragma mark - <UICollectionViewDelegate>
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);

}

//设置每个item line spaceing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 0;
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger page = offsetX / ScreenWidth;
    
    self.title = [NSString stringWithFormat:@"练习（%ld/%lu）",page + 1,(unsigned long)self.questions.count];
    
}

#pragma mark - <ExerciseDelegate>
-(void)addGuideViewRect:(CGRect)rect __attribute__((deprecated("QuanQuan 2.1.4 版本已过期")));{
    
//    CGFloat x = ScreenWidth * 0.075;
//    CGFloat y = ScreenHeight * 0.05;
//
//    CGRect newRect = CGRectMake(rect.origin.x + x, rect.origin.y + y, rect.size.width, rect.size.height);

    
//    EAFeatureItem *exercise = [[EAFeatureItem alloc] initWithFocusRect:rect focusCornerRadius:0 focusInsets:UIEdgeInsetsZero];
//    exercise.introduce = @"点击选项选择答案.png";
//    exercise.indicatorImageName = @"点击";
//    exercise.buttonBackgroundImageName = @"朕知道了";
//    exercise.action = ^(id sender){
//        
//    };
//    
//    
//    [self.navigationController.view showWithFeatureItems:@[exercise] saveKeyName:UDCARDEXERCISEGUIDE inVersion:nil];
}

-(void)finishQuesSeletion:(NSDictionary *)dict{
    [self.userAnswers addObject:dict];
    NSLog(@"exercise user answer = %@",self.userAnswers);
}

-(void)jumpToNextPage:(NSInteger)page{
    
    [self.collectionView setContentOffset:CGPointMake((page + 1) * ScreenWidth , 0) animated:YES];
    
    self.title = [NSString stringWithFormat:@"练习（%ld/%lu）",page + 2,(unsigned long)self.questions.count];
    
}

-(void)exerciseIsFinished{
    
    [self sendUserExerciseToSever];
    
    
    UIStoryboard *study = [UIStoryboard storyboardWithName:@"Study" bundle:[NSBundle mainBundle]];
    FinishViewController *finishVC = [study instantiateViewControllerWithIdentifier:@"FinishViewController"];
    finishVC.errorQues = [ExerciseExtension filterErrorQues:self.userAnswers withAllQues:self.questions];
    finishVC.userErrorAnswers = [ExerciseExtension filterUserErrorAnswer:self.userAnswers withAllQues:self.questions module:STUDY];
    finishVC.allQues = self.questions;
    finishVC.allUserAnswers = [ExerciseExtension combineAllUserAnswer:self.userAnswers withAllQues:self.questions module:STUDY forSever:NO];
    finishVC.questionID = [self.qustionID copy];
    finishVC.cardID = self.cardID;
    finishVC.lastCardID = self.lastCardID;
    finishVC.isCardPackage = self.isCardPackage;
    
    NSArray *questionKeys = self.qustionID.allKeys;
    NSArray *analysisKeys = self.analysisBtnStatus.allKeys;
    
    if ([questionKeys isEqualToArray:analysisKeys]) {
        finishVC.checkAnalysis = YES;
    } else {
        finishVC.checkAnalysis = NO;
    }
    
    
    [self.navigationController pushViewController:finishVC animated:YES];
}

#pragma mark - Button Action
-(void)showAnalysis:(UIButton *)button{
    
    button.selected = button.isSelected ? NO : YES;

    NSString *key = [NSString stringWithFormat:@"%ld",(long)button.tag];
    NSNumber *isSelected = [NSNumber numberWithBool:button.selected];
    [self.analysisBtnStatus setValue:isSelected forKey:key];
    
    [self.collectionView reloadData];
    
    NSString *analysis = [[NSUserDefaults standardUserDefaults] valueForKey:UDSHOWANALYSIS];
    
    if (!analysis) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:@"analysis" forKey:UDSHOWANALYSIS];
        [userDefaults synchronize];
        
        [self presentAlertWithTitle:@"点击提示会显示本题答案和解析。但答案成绩将不会被统计在预估考分内。" message:@"" actionTitle:@"我知道了"];
    }
    

}

@end
