//
//  ExerciseAnalysisViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/24.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "ExerciseAnalysisViewController.h"

#import "AnalysisTable.h"

#import "CollectionZoomFlowLayout.h"


#define AnalysisCellWidth  ScreenWidth
#define AnalysisCellHeight ScreenHeight 

@interface ExerciseAnalysisViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ExerciseDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *questions;/* 题目 */

@property (strong, nonatomic) NSArray *userAnswers;/* 用户选项 */

@end

@implementation ExerciseAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{

}

#pragma mark - Data


#pragma mark - UI
-(void)updateUI{
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
  
    if (self.showAllAnalysis) {
        self.questions = self.allQues;
        self.userAnswers = self.allUserAnswers;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView setContentOffset:CGPointMake(self.page * ScreenWidth, 0) animated:YES];
            
        });
        
    } else {
        self.questions = self.errorQues;
        self.userAnswers = self.userErrorAnswers;
    }
    
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.questions.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"ExerciseAnalysisCVCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
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
    
    NSString *color = [[NSUserDefaults standardUserDefaults] valueForKey:UDBACKGROUNDCOLOR];
    table.backgroundColor = [UIColor colorwithHexString:color];
    
    [cell.contentView addSubview:table];
    
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

@end
