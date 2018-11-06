//
//  ErrorExerciseReportViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/8.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "ErrorExerciseReportViewController.h"
#import "CardExerciseInfoView.h"
#import "ExerciseAnalysisViewController.h"
#import "ErrorReportCell.h"
#import "MyErrorExerciseVC.h"

@interface ErrorExerciseReportViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *basicView;

@property (weak, nonatomic) IBOutlet CardExerciseInfoView *rightView;

@property (weak, nonatomic) IBOutlet CardExerciseInfoView *wrongView;

@property (weak, nonatomic) IBOutlet CardExerciseInfoView *rateView;

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet MainGreenButton *exerciseBtn;

@property (weak, nonatomic) IBOutlet UIButton *showAnalysisBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoR;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnB;

@end

@implementation ErrorExerciseReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.labelT.constant = ScreenHeight * 0.05;
    self.infoT.constant = ScreenHeight * 0.03;
    self.infoL.constant = self.infoR.constant = ( ScreenWidth - 70 * 3 ) / 4;
    
    if (IS_IPHONE4S) {
        self.btnB.constant = 5;
    } else {
        self.btnB.constant = ScreenHeight * 0.075;
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

#pragma mark - UI
-(void)updateUI{
    
    /* 重写返回按钮 */
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToMainVC)];
    
    self.showAnalysisBtn.layer.borderWidth = 1;
    self.showAnalysisBtn.layer.borderColor = [UIColor customisMainGreen].CGColor;

    [self.basicView shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:7 shadowOpacity:1];
    
    self.basicView.layer.cornerRadius = 6;
    
    [self addDashLine];

    NSInteger count = 0;
    
    for (NSDictionary *dict in self.allUserAnswers) {
        NSString *status = dict[@"status"];
        if ([status isEqualToString:@"1"]) {
            count ++;
        }
    }
    
    self.rightView.number.textColor = [UIColor colorwithHexString:@"#20C997"];
    self.wrongView.number.textColor = [UIColor colorwithHexString:@"#FF3B30"];
    self.rateView.number.textColor = [UIColor colorwithHexString:@"#FFC107"];
    
    [self.rightView updateNumber:[NSString stringWithFormat:@"%ld",count]
                            unit:@"道题"
                            item:@"正确"];
    
    [self.wrongView updateNumber:[NSString stringWithFormat:@"%ld",self.allUserAnswers.count - count]
                            unit:@"道题"
                            item:@"错误"];
    
    double rate = count / (double)self.allUserAnswers.count;
    
    [self.rateView updateNumber:[NSString stringWithFormat:@"%.f",rate * 100]
                           unit:@"%"
                           item:@"正确率"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat size = ScreenWidth * 0.1;
    if (size > 40) {
        size = 40;
    }
    layout.itemSize = CGSizeMake(size, size);
    layout.minimumInteritemSpacing = ScreenWidth * 0.05;
    CGFloat left = (ScreenWidth - 30 - ScreenWidth * 0.1 * 5 - ScreenWidth * 0.07 * 4) / 2;
    CGFloat top = (40 - size ) / 2;
    layout.sectionInset = UIEdgeInsetsMake(top, left, top, left);
    self.collectionView.collectionViewLayout = layout;
    
}

-(void)addDashLine{
    
//    CGRect width = self.line.frame;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.line.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.line.frame) / 2, CGRectGetHeight(self.line.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[UIColor colorwithHexString:@"#CCCCCC"].CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(self.line.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:4], [NSNumber numberWithInt:1], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, (ScreenWidth - (15 + 27) * 2), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.line.layer addSublayer:shapeLayer];
}

#pragma mark - Data

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allQues.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"ErrorReportCell";
    
    ErrorReportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.number.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    NSString *number = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    NSString *currentID = [self.questionID valueForKey:number];
    
    for (NSDictionary *dict in self.allUserAnswers) {
        NSString *quesID = dict[@"question_id"];
        NSString *status = dict[@"status"];
        
        if (currentID == quesID ) {
            if ([status isEqualToString:@"1"]) {
                [cell configureCellWithNumber:number isCorrect:YES];
            } else {
                [cell configureCellWithNumber:number isCorrect:NO];
            }
        }
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *study = [UIStoryboard storyboardWithName:@"Study" bundle:[NSBundle mainBundle]];
    ExerciseAnalysisViewController *analysisVC = [study instantiateViewControllerWithIdentifier:@"ExerciseAnalysisViewController"];
    analysisVC.showAllAnalysis = YES;
    analysisVC.page = indexPath.row;
    analysisVC.allQues = self.allQues;
    analysisVC.allUserAnswers = self.allUserAnswers;
    analysisVC.errorQues = self.errorQues;
    analysisVC.userErrorAnswers = self.userErrorAnswers;
    [self.navigationController pushViewController:analysisVC animated:YES];
}

#pragma mark - Button
- (IBAction)exercise:(MainGreenButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMoreErrorQuestions" object:nil];
    
}

- (IBAction)showAnalysis:(MainGreenButton *)sender {
    
    
    [self pushToExerciseAnalysisViewController:YES];
}

-(void)pushToExerciseAnalysisViewController:(BOOL)showAllAnalysis{
    UIStoryboard *study = [UIStoryboard storyboardWithName:@"Study" bundle:[NSBundle mainBundle]];
    ExerciseAnalysisViewController *analysisVC = [study instantiateViewControllerWithIdentifier:@"ExerciseAnalysisViewController"];
    analysisVC.showAllAnalysis = showAllAnalysis;
    analysisVC.allQues = self.allQues;
    analysisVC.allUserAnswers = self.allUserAnswers;
    analysisVC.errorQues = self.errorQues;
    analysisVC.userErrorAnswers = self.userErrorAnswers;
    [self.navigationController pushViewController:analysisVC animated:YES];
}

-(void)popToMainVC{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
