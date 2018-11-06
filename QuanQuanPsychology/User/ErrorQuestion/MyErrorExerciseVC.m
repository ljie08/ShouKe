//
//  MyErrorExerciseVC.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/26.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "MyErrorExerciseVC.h"
#import "ErrorExerciseReportViewController.h"

#import "FinishViewController.h"

#import "QuestionTable.h"
#import "BlankView.h"

#import "UserStudyInfoAPI.h"
#import "ErrorQuestionAPI.h"

@interface MyErrorExerciseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,ExerciseDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) BlankView *blankView;

@property (strong, nonatomic) NSMutableArray *questions;/* 题目 */

@property (strong, nonatomic) NSMutableArray *userAnswers;/* 用户答案 */

@property (strong, nonatomic) NSMutableDictionary *analysisBtnStatus;/* 每题解析按钮状态 */

@property (assign, nonatomic) NSInteger currentPage;/* 当前题目页数 */

@property (strong, nonatomic) NSMutableDictionary *qustionID;


@end

@implementation MyErrorExerciseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self initData];
    [self initUI];
    [self updateUI];
    [self fetchErrorQuestions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoreErrorQuestions:) name:@"GetMoreErrorQuestions" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Data
-(void)initData{

    self.analysisBtnStatus = [NSMutableDictionary dictionary];

    self.qustionID = [NSMutableDictionary dictionary];

}

-(void)fetchErrorQuestions{

    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];

    [ErrorQuestionAPI fetchMyWrongQuesModuleWithUID:USERUID courseID:USERCOURSE callback:^(APIReturnState state,id data, NSString *message) {
        if (state == API_SUCCESS) {
            [self hideHUD];
            NSDictionary *dict = (NSDictionary *)data;
            NSArray *list = dict[LIST];
            [self saveToQuestionModel:list];
            [self.collectionView reloadData];
        } else if (state == API_NODATA){
            [self initBlankView];
            [self hideHUDAfter:1];
        }  else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}


-(void)saveToQuestionModel:(NSArray *)list{
    
    self.userAnswers = [NSMutableArray array];
    
    self.questions = [NSMutableArray array];
    
    for (int i = 0 ; i < list.count; i++) {
        NSDictionary *dict = list[i];
        QuestionModel *question = [[QuestionModel alloc] initWithDict:dict];
        [self.questions addObject:question];
    }
    
    self.title = [NSString stringWithFormat:@"我的错题（1/%lu）",(unsigned long)self.questions.count];

}

#pragma mark - UI
-(void)updateUI{

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的错题";
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)initUI{
    
//    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
//    [delete setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//    [delete addTarget:self action:@selector(deleteQuestion:) forControlEvents:UIControlEventTouchUpInside];
//    UIView *deleteView = [[UIView alloc] initWithFrame:CGRectMake(0,0,22,22)];
//    delete.frame = CGRectMake(0, 0, 22, 22); // where you can set your insets
//    [deleteView addSubview:delete];
//    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithCustomView:deleteView];
//
//    self.navigationItem.rightBarButtonItem = deleteBtn;
    
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

-(void)initBlankView{
    
    self.blankView = [[BlankView alloc] initWithFrame:self.view.bounds];
    [self.blankView updateImage:[UIImage imageNamed:@"blank"]
                    imageCenter:CGPointMake(self.view.center.x, self.view.center.y - 20)
                        content:@"您现在还没有任何错题"];
    [self.view addSubview:self.blankView];
}

-(void)addAnalysisButtonForCell:(UICollectionViewCell *)cell andTag:(NSInteger)tag{
    
    CGFloat size = 44;
    CGFloat x = cell.frame.size.width - 45 - size;
    CGFloat y = cell.frame.size.height - 78 - size;
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
    
    static NSString *cellID = @"ExerciseCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSNumber *number = [self.analysisBtnStatus valueForKey:key];
    
    
    QuestionModel *question = self.questions[indexPath.row];
    [self.qustionID setValue:question.quesID forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    
    QuestionTable *table = [[QuestionTable alloc] initWithFrame:CGRectMake(0, 0,cell.frame.size.width, cell.frame.size.height)];
    table.module = EXERCISE_ERROR;
    table.tag = indexPath.row;/* tag设置为indexpath.row 相当于page */
    table.totalNo = self.questions.count;
    table.question = question;
    table.exerciseDelegate = self;
    table.analysisStatus = [number boolValue];
    table.layer.cornerRadius = 10;
    table.layer.masksToBounds = YES;
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
    
    [self addAnalysisButtonForCell:cell andTag:indexPath.row];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

#pragma mark - <ExerciseDelegate>
-(void)finishQuesSeletion:(NSDictionary *)dict{
    [self.userAnswers addObject:dict];
    NSLog(@"exercise user answer = %@",self.userAnswers);
}

-(void)jumpToNextPage:(NSInteger)page{
    
    self.title = [NSString stringWithFormat:@"我的错题（%ld/%lu）",page + 2,(unsigned long)self.questions.count];

    
    [self.collectionView setContentOffset:CGPointMake((page + 1) * ScreenWidth, 0) animated:YES];
    
}

-(void)exerciseIsFinished{
    
    [self sendUserExerciseToSever];

    UIStoryboard *study = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    ErrorExerciseReportViewController *finishVC = [study instantiateViewControllerWithIdentifier:@"ErrorExerciseReportViewController"];
    finishVC.errorQues = [ExerciseExtension filterErrorQues:self.userAnswers withAllQues:self.questions];
    finishVC.userErrorAnswers = [ExerciseExtension filterUserErrorAnswer:self.userAnswers withAllQues:self.questions module:ERROR];
    finishVC.allQues = self.questions;
    finishVC.allUserAnswers = [ExerciseExtension combineAllUserAnswer:self.userAnswers withAllQues:self.questions module:ERROR forSever:NO];
    finishVC.questionID = [self.qustionID copy];

    [self.navigationController pushViewController:finishVC animated:YES];
    
}

-(void)sendUserExerciseToSever{
    
    NSArray *list = [ExerciseExtension combineAllUserAnswer:self.userAnswers withAllQues:self.questions module:STUDY forSever:YES];
    
    [UserStudyInfoAPI sendExerciseQuestionWithUID:USERUID quesList:list callback:^(APIReturnState state, id data, NSString *message) {
        NSLog(@"我的错题问题提交-%@",message);
    }];
    
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.currentPage = offsetX / ScreenWidth;
    
    self.title = [NSString stringWithFormat:@"我的错题（%ld/%lu）",self.currentPage + 1,(unsigned long)self.questions.count];
}

#pragma mark - Button Action
-(void)showAnalysis:(UIButton *)button{
    
    button.selected = button.isSelected ? NO : YES;
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)button.tag];
    NSNumber *isSelected = [NSNumber numberWithBool:button.selected];
    [self.analysisBtnStatus setValue:isSelected forKey:key];
    
    [self.collectionView reloadData];
}

//-(void)deleteQuestion:(UIButton *)button{
//    
//    QuestionModel *question = self.questions[self.currentPage];
//    NSString *quesID = question.quesID;
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否要删除错题" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self.questions removeObjectAtIndex:self.currentPage];
//        [self.collectionView reloadData];
//        [self.collectionView setContentOffset:CGPointMake((self.currentPage) * ScreenWidth, 0) animated:YES];
//        
//        [self deleteQuestionWithID:quesID];
//      
//    }];
//    
//    [alert addAction:cancel];
//    [alert addAction:confirm];
//    
//    alert.view.tintColor = [UIColor customisDarkGreyColor];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//    
//}
//
//-(void)deleteQuestionWithID:(NSString *)quesID{
//    
//    [ErrorQuestionAPI deleteMyWrongQuesWithQuesID:quesID callback:^(APIReturnState state, id data, NSString *message) {
//        if (state == API_SUCCESS) {
//            [self showHUDWithMode:MBProgressHUDModeText message:@"错题已删除"];
//            [self hideHUDAfter:1];
//        } else {
//            [self showHUDWithMode:MBProgressHUDModeText message:message];
//            [self hideHUDAfter:1];
//        }
//    }];
//    
//
//}

#pragma mark - Notification
-(void)getMoreErrorQuestions:(NSNotification *)noti{
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self fetchErrorQuestions];
}

@end
