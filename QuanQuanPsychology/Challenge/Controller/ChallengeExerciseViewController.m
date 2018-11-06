//
//  ChallengeExerciseViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/11/2.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ChallengeExerciseViewController.h"
#import "ChallengeResultViewController.h"
#import "ChallengeViewController.h"

#import "QuestionTable.h"

#import "ChallengeAPI.h"
#import "UserStudyInfoAPI.h"

#import "ChallengeModel.h"

@interface ChallengeExerciseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,ExerciseDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *questions;/* 题目 */

@property (strong, nonatomic) NSMutableArray *userAnswers;/* 用户答案 */

/*  */
@property (assign, nonatomic) CGFloat accuracy;


@end

@implementation ChallengeExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self initData];
    [self updateUI];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)updateUI{
    self.title = [NSString stringWithFormat:@"刷题（1/%lu）",(unsigned long)self.questions.count];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)initUI{
    
    /* 重写返回按钮 */
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToMainVC)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize =CGSizeMake(ScreenWidth, ScreenHeight - NavHeight - StatusHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavHeight + StatusHeight, ScreenWidth, ScreenHeight - NavHeight - StatusHeight) collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    NSString *color = [[NSUserDefaults standardUserDefaults] valueForKey:UDBACKGROUNDCOLOR];
    self.collectionView.backgroundColor = [UIColor colorwithHexString:color];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ExerciseCell"];
    
}


#pragma mark - Data
-(void)initData{
    
    self.userAnswers = [NSMutableArray array];
    
    self.questions = [NSMutableArray array];
    
    for (int i = 0 ; i < self.allQues.count; i++) {
        NSDictionary *dict = self.allQues[i];
        QuestionModel *question = [[QuestionModel alloc] initWithDict:dict];
        [self.questions addObject:question];
    }

}

-(void)sendUserExerciseToSever{
    
    NSArray *list = [ExerciseExtension combineAllUserAnswer:self.userAnswers withAllQues:self.questions module:CHALLENGE forSever:YES];
    
    [UserStudyInfoAPI sendExerciseQuestionWithUID:USERUID quesList:list callback:^(APIReturnState state, id data, NSString *message) {
        NSLog(@"%ld关问题提交-%@",(long)self.challenge.currentLevel,message);
    }];
    
}

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.questions.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"ExerciseCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = 703;//标签 无限挑战
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    QuestionModel *question = self.questions[indexPath.row];
    
    QuestionTable *table = [[QuestionTable alloc] initWithFrame:CGRectMake(0, 0,cell.frame.size.width , cell.frame.size.height)];
    table.module = EXERCISE_CHALLENGE;
    table.tag = indexPath.row;/* tag设置为indexpath.row 相当于page */
    table.totalNo = self.questions.count;
    table.question = question;
    table.exerciseDelegate = self;
    table.analysisStatus = NO;
    
    
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
            table.allowsSelection = NO;
        }
    }
    
    [cell.contentView addSubview:table];
    
    return cell;


}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger page = offsetX / ScreenWidth;
    
    self.title = [NSString stringWithFormat:@"刷题（%ld/%lu）",page + 1,(unsigned long)self.questions.count];
    
}

#pragma mark - <ExerciseDelegate>
-(void)finishQuesSeletion:(NSDictionary *)dict{
    [self.userAnswers addObject:dict];
    NSLog(@"exercise user answer = %@",self.userAnswers);
}

-(void)jumpToNextPage:(NSInteger)page{
    
    self.title = [NSString stringWithFormat:@"刷题（%ld/%lu）",page + 2,(unsigned long)self.questions.count];

    
    [self.collectionView setContentOffset:CGPointMake((page + 1) * ScreenWidth, 0) animated:YES];
}

-(void)exerciseIsFinished{
    
    [self sendUserExerciseToSever];
    
    BOOL pass = [self challengePass:self.userAnswers forQuestions:self.questions];
    
    NSString *level = [NSString stringWithFormat:@"%@",self.challenge.currentLevel];
    NSString *accuracy = [NSString stringWithFormat:@"%.2f",self.accuracy];
    
    [ChallengeAPI challengePassedWithUID:USERUID courseID:USERCOURSE level:level                      accuracy:accuracy callback:^(APIReturnState state, id data, NSString *message) {
        NSLog(@"无限挑战提交通关-%@",message);
    }];
    
    ChallengeResultViewController *challengeResultVC = [[ChallengeResultViewController alloc] init];
    challengeResultVC.pass = pass;
    challengeResultVC.challenge = self.challenge;
    challengeResultVC.accuracy = self.accuracy;
    challengeResultVC.challengeModels = self.challengeModels;
    challengeResultVC.currentLevel = [self.currentLevel integerValue];
    challengeResultVC.allErrorQues = [ExerciseExtension filterErrorQues:self.userAnswers withAllQues:self.questions];
    challengeResultVC.userAnswers = [ExerciseExtension filterUserErrorAnswer:self.userAnswers withAllQues:self.questions module:CHALLENGE];
    [self.navigationController pushViewController:challengeResultVC animated:YES];
}

#pragma mark - 判断无限挑战关卡是否通过
-(BOOL)challengePass:(NSArray *)userAnswers forQuestions:(NSArray *)questions{
    
    /**
     NSDictionary *dict = @{@"question_id":quesID,@"error_answer":error,@"status":status,@"type":module};
     quesID : 题目id  error : 错误选项  status : 0 错 1对  module : 模块
     */
    
    NSInteger count = 0;//用户做错题目个数
    
    if (userAnswers.count != 0) {
        for (NSDictionary *dict in userAnswers) {
            NSString *status = dict[@"status"];
            //做错或者没做的题目
            if ([status isEqualToString:@"1"]) {
                count ++;
            }
        }
    }
    
    NSLog(@"challenge right count = %ld",(long)count);
    
    double accuracy = (double)count / questions.count;
    
    self.accuracy = accuracy;
    
    if (accuracy >= [self.challenge.passingRate doubleValue]) {
        return  YES;
    } else {
        return NO;
    }

}

#pragma mark - Button Action


-(void)popToMainVC{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要离开吗？" message:@"离开后要重新开始哦~" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UINavigationController *navigationVC = self.navigationController;
        
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        
        /* 遍历导航控制器中的控制器 */
        for (UIViewController *vc in navigationVC.viewControllers) {
            
            [viewControllers addObject:vc];
            
            if ([vc isKindOfClass:[ChallengeViewController class]]) {
                break;
            }
        }
        
        /* 把控制器重新添加到导航控制器 */
        [navigationVC setViewControllers:viewControllers animated:YES];
    }]];
    
    alert.view.tintColor = [UIColor customisDarkGreyColor];
    
    [self presentViewController:alert animated:YES completion:nil];

}


@end
