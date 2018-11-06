//
//  ChallengeResultViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2016/12/26.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ChallengeResultViewController.h"
#import "ChallengeExerciseViewController.h"
#import "ChallengeAnalysisViewController.h"
#import "ChallengeViewController.h"

#import "ShareView.h"
#import "ChallengeAPI.h"

#import "ChallengeModel.h"

@interface ChallengeResultViewController ()

@property (strong, nonatomic) NSString *challengeResult;

@property (strong, nonatomic) ShareView *shareView;

/*  */
@property (copy, nonatomic) NSString *message;

@end

@implementation ChallengeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)updateUI{
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)initUI{
    
    /* 重写返回按钮 */
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToMainVC)];
    
    if (self.pass) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareResult)];
    }
    
    [self initResultView];

}

-(void)initResultView{
    
    UIImageView *backgroundImgae = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 100) / 2, ScreenHeight * 0.17, 100, 118)];
    if (self.pass) {
        backgroundImgae.image = [UIImage imageNamed:@"challenge_success"];
    } else {
        backgroundImgae.image = [UIImage imageNamed:@"challenge_failed"];

    }
    [self.view addSubview:backgroundImgae];
    
    
    CGFloat levelY = backgroundImgae.frame.size.height + backgroundImgae.frame.origin.y + 20;
    
    UILabel *level = [[UILabel alloc] initWithFrame:CGRectMake(0, levelY, ScreenWidth, 20)];
    level.text = [NSString stringWithFormat:@"第%ld关",(long)self.currentLevel];
    level.textColor = [UIColor blackColor];
    level.textAlignment = NSTextAlignmentCenter;
    level.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:level];
    
    CGFloat resultY = levelY + level.frame.size.height + 15;
    UILabel *result = [[UILabel alloc] initWithFrame:CGRectMake(0, resultY, ScreenWidth, 30)];
    result.text = [NSString stringWithFormat:@"正确率 %.0f%%",self.accuracy * 100];
    
    if (self.pass) {
        result.textColor = [UIColor colorwithHexString:@"#FACD1D"];
    } else {
        result.textColor = [UIColor colorwithHexString:@"#33A990"];
    }
    result.textAlignment = NSTextAlignmentCenter;
    result.font = [UIFont systemFontOfSize:18];
    
    result.attributedText = [QuanUtils formatText:result.text withAttributedText:@"正确率" color:[UIColor blackColor] font:[UIFont systemFontOfSize:18]];
    
    [self.view addSubview:result];
    
    CGFloat messageY = resultY + result.frame.size.height + 15;
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, messageY, ScreenWidth, 30)];
    
    if (self.pass) {
        if (self.accuracy >= 0.9) {
            self.message = @"完美";
        } else if (self.accuracy >= 0.8){
            self.message = @"优秀";
        } else if (self.accuracy >= 0.7){
            self.message = @"很赞";
        } else if (self.accuracy >= 0.6){
            self.message = @"不错";
        } else {
            self.message = @"闯关成功";
        }
        message.textColor = [UIColor colorwithHexString:@"#FACD1D"];
    } else {
        
        self.message = @"闯关失败";
        message.textColor = [UIColor colorwithHexString:@"#33A990"];
        
    }
    
    
    
    message.text = self.message;

    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:message];
    
    CGFloat btnW = ScreenWidth * 0.8 ;
    CGFloat btnH = btnW / 6.67;
    CGFloat btnX = (ScreenWidth - btnW) / 2;
    CGFloat nextBtnY = messageY + message.frame.size.height + ScreenHeight * 0.052;
    
    MainGreenButton *nextLevel = [[MainGreenButton alloc] initWithFrame:CGRectMake(btnX, nextBtnY, btnW, btnH)];
    if (self.pass) {
        [nextLevel setTitle:@"继续闯关" forState:UIControlStateNormal];
        [nextLevel addTarget:self action:@selector(nextLevel:) forControlEvents:UIControlEventTouchUpInside];

    } else {
        [nextLevel setTitle:@"再来一次" forState:UIControlStateNormal];
        [nextLevel addTarget:self action:@selector(currentLevel:) forControlEvents:UIControlEventTouchUpInside];

    }
    [self.view addSubview:nextLevel];
    
    CGFloat analysisBtnY = nextBtnY + btnH + 10;
    
    UIButton *showAnalysis = [[UIButton alloc] initWithFrame:CGRectMake(btnX, analysisBtnY, btnW, btnH)];
    [showAnalysis setTitle:@"查看解析" forState:UIControlStateNormal];
    [showAnalysis setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showAnalysis addTarget:self action:@selector(showAnalysis:) forControlEvents:UIControlEventTouchUpInside];
    showAnalysis.layer.cornerRadius = 5;
    showAnalysis.layer.borderWidth = 1;
    showAnalysis.layer.borderColor = [UIColor colorwithHexString:@"#555555"].CGColor;
    
    [self.view addSubview:showAnalysis];
    
    if (self.allErrorQues.count == 0) {
        showAnalysis.userInteractionEnabled = NO;
        showAnalysis.alpha = 0.4;
    }
    
}

#pragma mark - Button Action
-(void)nextLevel:(UIButton *)button{

    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
    
    NSString *levelString = [NSString stringWithFormat:@"%ld",(self.currentLevel + 1)];
    
    [ChallengeAPI fetchChallengeQuesWithUID:USERUID courseID:USERCOURSE level:levelString callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            ChallengeExerciseViewController *challengeExerciseVC = [[ChallengeExerciseViewController alloc] init];
            challengeExerciseVC.allQues = dict[LIST];
            challengeExerciseVC.currentLevel = levelString;
            challengeExerciseVC.challengeModels = self.challengeModels;
            challengeExerciseVC.challenge = self.challengeModels[self.currentLevel + 1];
            [self hideHUD];
            [self.navigationController pushViewController:challengeExerciseVC animated:YES];
        } else {
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];

}


-(void)currentLevel:(UIButton *)button{
    
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
    
    NSString *levelString = [NSString stringWithFormat:@"%ld",(long)self.currentLevel];
    
    [ChallengeAPI fetchChallengeQuesWithUID:USERUID courseID:USERCOURSE level:levelString callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            ChallengeExerciseViewController *challengeExerciseVC = [[ChallengeExerciseViewController alloc] init];
            challengeExerciseVC.allQues = dict[LIST];
            challengeExerciseVC.currentLevel = levelString;
            challengeExerciseVC.challengeModels = self.challengeModels;
            challengeExerciseVC.challenge = self.challenge;
            [self hideHUD];
            [self.navigationController pushViewController:challengeExerciseVC animated:YES];
        } else {
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

-(void)showAnalysis:(UIButton *)button{

    ChallengeAnalysisViewController *challengeAnalysisVC = [[ChallengeAnalysisViewController alloc] init];
    challengeAnalysisVC.allErrorQues = self.allErrorQues;
    challengeAnalysisVC.userAnswers = self.userAnswers;
    [self.navigationController pushViewController:challengeAnalysisVC animated:YES];
}

-(void)popToMainVC{
    
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
    
}

-(void)shareResult{
    // 设置分享内容
    
    
    self.shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    [self.navigationController.view addSubview:self.shareView];

    NSString *path = [SEVER_QUAN_API stringByAppendingString:@"hcxl/shareMark/detail.html"];
    
    NSString *urlString = [path stringByAppendingString:[NSString stringWithFormat:@"?number=%ld&accuracy=%.0f%%",(long)self.currentLevel,self.accuracy * 100]];
    
    
    NSString *courseName = @"";
    
    NSString *text = [NSString stringWithFormat:@"信心满满 建议开启【%@】刷题闯关模式!",courseName];
    
    UIImage *image = [UIImage imageNamed:@"圈圈icon"];
    
    self.shareView.platformView.shareTitle = text;
    self.shareView.platformView.shareSubTitle = @"每日一关 登顶学霸";
    self.shareView.platformView.shareIcon = image;
    self.shareView.platformView.shareURL = urlString;
    self.shareView.platformView.currentVC = self;
}


@end
