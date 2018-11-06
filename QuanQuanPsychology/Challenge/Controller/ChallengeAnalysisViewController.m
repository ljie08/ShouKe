//
//  ChallengeAnalysisViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2016/12/27.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ChallengeAnalysisViewController.h"

#import "AnalysisTable.h"

@interface ChallengeAnalysisViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ExerciseDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *multipleOption;/* 该题是否为多选题数组 */

@property (strong, nonatomic) NSArray *questions;/* 题目 */


@end

@implementation ChallengeAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.questions = self.allErrorQues;
    
    [self updateUI];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Data

#pragma mark - UI
-(void)updateUI{
    self.title = @"错题解析";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

-(void)initUI{
    
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
    
    QuestionModel *question = self.questions[indexPath.row];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in self.userAnswers) {
        NSString *quesID = dict[@"question_id"];
        [array addObject:quesID];
    }
    
    AnalysisTable *table = [[AnalysisTable alloc] initWithFrame:CGRectMake(0, 0,cell.frame.size.width, cell.frame.size.height)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.tag = indexPath.row;/* tag设置为indexpath.row 相当于page */
    table.exerciseDelegate = self;
    table.question = question;
    NSInteger index = [array indexOfObject:question.quesID];
    table.status = self.userAnswers[index][@"status"];
    table.userAns = self.userAnswers[index][@"error_answer"];
    table.analysisStatus = YES;
    table.showQuestionNo = YES;
    
    [cell.contentView addSubview:table];

    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

#pragma mark - <UIScrollViewDelegate>

@end
