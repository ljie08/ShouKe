//
//  FinishViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2016/12/29.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "FinishViewController.h"
#import "CardViewController.h"
#import "ExerciseReportCVCell.h"
#import "ExerciseAnalysisViewController.h"

#import "PackageDetailViewController.h"

#import "ShareView.h"
#import "ShareModel.h"
#import "CardExerciseInfoView.h"

#import "CardPackageDetailModel.h"

#import "CardPackageAPI.h"
#import "UserStudyInfoAPI.h"

//#import "UIView+EAFeatureGuideView.h"


@interface FinishViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIView *reportView;

@property (weak, nonatomic) IBOutlet CardExerciseInfoView *rightView;

@property (weak, nonatomic) IBOutlet CardExerciseInfoView *wrongView;

@property (weak, nonatomic) IBOutlet CardExerciseInfoView *rateView;

@property (weak, nonatomic) IBOutlet UICollectionView *questionCollection;

@property (weak, nonatomic) IBOutlet MainGreenButton *studyBtn;

@property (weak, nonatomic) IBOutlet UIButton *showAnalysisBtn;

@property (strong, nonatomic) ShareView *shareView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reportT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reportH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelT;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wrongT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnT;

@end

@implementation FinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUI];
    [self initUI];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.reportT.constant = ScreenHeight * 0.21 + 10;
    self.reportH.constant = ScreenHeight * 0.42;
    self.labelT.constant = ScreenHeight * 0.42 * 0.15;
    
    self.wrongT.constant = ScreenHeight * 0.42 * 0.05;
    
    self.collectionB.constant = ScreenHeight * 0.42 * 0.14;
    
    self.btnT.constant = ScreenHeight * 0.03;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data


#pragma mark - UI
-(void)updateUI{
    
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

    [self.rightView updateNumber:[NSString stringWithFormat:@"%ld",(long)count]
                            unit:@"道题"
                            item:@"正确"];
    
    [self.wrongView updateNumber:[NSString stringWithFormat:@"%lu",self.allUserAnswers.count - count]
                            unit:@"道题"
                            item:@"错误"];
    
    double rate = count / (double)self.allUserAnswers.count;
    
    [self.rateView updateNumber:[NSString stringWithFormat:@"%.f",rate * 100]
                            unit:@"%"
                            item:@"正确率"];
    
    self.showAnalysisBtn.layer.borderWidth = 1;
    self.showAnalysisBtn.layer.borderColor = [UIColor customisMainGreen].CGColor;
    
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
    self.questionCollection.collectionViewLayout = layout;
    
    if ([self.cardID isEqualToString:self.lastCardID]) {
        [self.studyBtn setTitle:@"返回目录" forState:UIControlStateNormal];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"这是本章节最后一张知识卡啦" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        alert.view.tintColor = [UIColor customisDarkGreyColor];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self.studyBtn setTitle:@"继续学习" forState:UIControlStateNormal];
    }
    
    
    /*
    //判断用户是否未查看解析做对 以及 是否错误率为0时，完成卡片总数+1
    if (!self.checkAnalysis && self.userErrorAnswers.count == 0) {
        NSString *cardCount = [[NSUserDefaults standardUserDefaults] valueForKey:UDTOTALALREADYCARDCOUNT];
        cardCount = [NSString stringWithFormat:@"%ld",[cardCount integerValue] + 1];
        [[NSUserDefaults standardUserDefaults] setValue:cardCount forKey:UDTOTALALREADYCARDCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     */
    
}

-(void)initUI{
    
    /* 重写返回按钮 */
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToCardVC)];
    
}

-(void)showAppStoreCommentReminder{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *comment = [userDefaults valueForKey:UDAPPSTORECOMMENT];
    if ([NSString stringIsNull:comment]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"亲，喜欢圈圈考试吗？给个好评吧" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"给个好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [QuanUtils openScheme:@"itms-apps://itunes.apple.com/app/id1409991705"];
        }];
        
        alert.view.tintColor = [UIColor customisDarkGreyColor];
        [alert addAction:sure];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        [userDefaults setValue:@"AppStoreComment" forKey:UDAPPSTORECOMMENT];
    }
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allQues.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"ExerciseReportCVCell";
    
    ExerciseReportCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
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

#pragma mark - Button Action
- (IBAction)nextCard:(MainGreenButton *)sender {
    
    if ([self.cardID isEqualToString:self.lastCardID]) {
        
        [self backToMenu];
        
    } else {
        
        NSDictionary *dict = @{@"cardID":self.cardID,@"isNext":[NSNumber numberWithBool:YES]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JumpToSelectedCard" object:nil userInfo:dict];
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[CardViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
    

    
}

/* 返回目录 */
-(void)backToMenu{
    
    UINavigationController *navigationVC = self.navigationController;
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    BOOL exist = NO;
    
    /* 遍历导航控制器中的控制器 */
    for (UIViewController *vc in navigationVC.viewControllers) {
        
        [viewControllers addObject:vc];
        
        if (self.isCardPackage) {
            if ([vc isKindOfClass:[PackageDetailViewController class]]) {
                exist = YES;
                break;
            }
        } else {
            
        }
    }
    
    if (exist) {
        /* 把控制器重新添加到导航控制器 */
        [navigationVC setViewControllers:viewControllers animated:YES];
    } else {
        
    }
    
    
}

/* 返回知识卡 */
-(void)popToCardVC{
    
    UINavigationController *navigationVC = self.navigationController;
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    /* 遍历导航控制器中的控制器 */
    for (UIViewController *vc in navigationVC.viewControllers) {
        
        [viewControllers addObject:vc];
        
        if ([vc isKindOfClass:[CardViewController class]]) {
            break;
        }
        
    }
    
    /* 把控制器重新添加到导航控制器 */
    [navigationVC setViewControllers:viewControllers animated:YES];
    
    NSDictionary *dict = @{@"cardID":self.cardID,@"isNext":[NSNumber numberWithBool:NO]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JumpToSelectedCard" object:nil userInfo:dict];
}

//- (IBAction)shareCard:(UIBarButtonItem *)sender {
//    
//    self.shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    
//    [self.navigationController.view addSubview:self.shareView];
//    
//    NSString *path = [SEVER_QUAN_API stringByAppendingString:@"share/card_knowledge.html?id="];
//    NSString *cardCount = @"";
//    
//    //精编卡包
//    if (self.isCardPackage) {
//        
//        if (self.cpDetailModel.cpType == CP_Paid) {
//            path = [SEVER_QUAN_API stringByAppendingString:@"share/jb_card_knowledge.html?id="];
//        }
//        cardCount = [[NSUserDefaults standardUserDefaults] valueForKey:UDCPTOTALALREADYCARDCOUNT];
//        
//    } else {
//        
//        cardCount = [[NSUserDefaults standardUserDefaults] valueForKey:UDTOTALALREADYCARDCOUNT];
//        
//    }
//    
//    
//    NSString *urlString = [path stringByAppendingString:self.cardID];
//    
////    CourseModel *course = [[DataManager shareDataMangaer] fetchCourseInfoWithCourseID:USERCOURSE];
//    NSString *courseName = @"";
//    
//    UIImage *image = [UIImage imageNamed:@"分享小人"];
//    
//    //微博、QQ、微信好友一样
//    ShareModel *wechat = [[ShareModel alloc] init];
//    wechat.shareTitle = @"手握这张卡，逢考必过";
//    wechat.shareSubTitle = [NSString stringWithFormat:@"%@学生最爱用的考试APP！",courseName];
//    
//    ShareModel *moment = [[ShareModel alloc] init];
//    moment.shareTitle = [NSString stringWithFormat:@"这是我在圈圈考试掌握的第%@个考点，猛戳分享考运！",cardCount];
//    moment.shareSubTitle = @"手握这张卡，逢考必过";
//    
//    self.shareView.platformView.shareIcon = image;
//    self.shareView.platformView.shareURL = urlString;
//    self.shareView.platformView.shareMaterialDifferent = YES;
//    self.shareView.platformView.materials = @[wechat,moment,wechat,wechat];
//    self.shareView.platformView.currentVC = self;
//
//}

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

@end
