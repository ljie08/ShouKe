//
//  ChallengeViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/11/1.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ChallengeViewController.h"
#import "ChallengeExerciseViewController.h"
#import "ChallengeStartView.h"
#import "ChallengeCollectionView.h"

#import "ChallengeAPI.h"

#import "ChallengeModel.h"

#import "WaterWaveView.h"

@interface ChallengeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;/* 背景图 */
@property (weak, nonatomic) IBOutlet UIImageView *homeCBG;
@property (weak, nonatomic) IBOutlet UIView *homeBg;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIImageView *infoBackgroundImage;

@property (weak, nonatomic) IBOutlet UILabel *completionPercentage;

@property (weak, nonatomic) IBOutlet UIImageView *progressIcon;

@property (weak, nonatomic) IBOutlet UILabel *progress;

@property (weak, nonatomic) IBOutlet UIImageView *rightRateIcon;

@property (weak, nonatomic) IBOutlet UILabel *rightRate;

@property (weak, nonatomic) IBOutlet UIView *dataBgView;

@property (weak, nonatomic) IBOutlet ChallengeCollectionView *collectionView;

/*  */
@property (strong, nonatomic) NSArray *challengeModels;

/*  */
@property (strong, nonatomic) ChallengeModel *current;

/*  */
@property (assign, nonatomic) NSInteger passCount;

@property (nonatomic, strong) WaterWaveView *wave;/**< <#注释#> */

@end

@implementation ChallengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.dataBgView shadowOffset:CGSizeMake(0, 1) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:3 shadowOpacity:1];
    
    [self initWaveView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self fetchChallengeLevel];
    
    [self setBackButton:NO isBlackColor:YES];

    self.tabBarController.tabBar.hidden = self.hideTab;
    self.navigationController.navigationBarHidden = NO;

    UIColor *titleColor;
    UIColor *navColor;
    
    if (self.hideTab) {
        titleColor = [UIColor blackColor];
        navColor = [UIColor whiteColor];
        self.homeCBG.image = [UIImage imageNamed:@"challenge_homechallenge_bg"];
        self.homeBg.hidden = NO;
        self.infoView.hidden = YES;
        self.backgroundImage.hidden = YES;
        self.dataBgView.hidden = YES;
        self.wave.hidden = YES;
        [self setBackButton:YES isBlackColor:YES];
    } else {
        titleColor = [UIColor whiteColor];
        navColor = [UIColor clearColor];
        self.homeCBG.hidden = YES;
        self.homeBg.hidden = YES;
        self.wave.hidden = NO;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:titleColor}];
    
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:navColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
-(void)fetchChallengeLevel{
    
    self.passCount = 0;
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
    
    [ChallengeAPI fetchUserChallengeLevelWithUID:USERUID courseID:USERCOURSE callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            [self hideHUD];

            NSDictionary *dict = (NSDictionary *)data;
            
            [self saveToChallengeModel:dict];

            [self updateUI];
            self.collectionView.challenges = self.challengeModels;
            [self.collectionView reloadData];
        } else {
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
    
}

-(void)fetchChallengeQuestionForLevel:(NSString *)level{
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
    
    [ChallengeAPI fetchChallengeQuesWithUID:USERUID courseID:USERCOURSE level:level callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            ChallengeExerciseViewController *challengeExerciseVC = [[ChallengeExerciseViewController alloc] init];
            challengeExerciseVC.allQues = dict[LIST];
            challengeExerciseVC.challenge = self.current;
            challengeExerciseVC.challengeModels = self.challengeModels;
            challengeExerciseVC.currentLevel = self.current.currentLevel;
            [self hideHUD];
            
            [self.navigationController pushViewController:challengeExerciseVC animated:YES];
        } else {
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

-(void)saveToChallengeModel:(NSDictionary *)dict{
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *total = dict[@"max_chapter_num"];
    
    NSArray *list = dict[LIST];
    
    for (int i = 0; i < list.count; i++) {
        NSDictionary *level = list[i];
        ChallengeModel *challenge = [[ChallengeModel alloc] initWithDict:level andMaxLevel:total];
        if (![NSString stringIsNull:challenge.accuracy] && [challenge.accuracy doubleValue] >= [challenge.passingRate doubleValue]) {
            self.passCount ++;
        }
        [array addObject:challenge];
    }
    
    self.challengeModels = [array mutableCopy];
    
}

#pragma mark - UI
-(void)updateUI{
    
    NSInteger totalLevel = 0;
    CGFloat topAccuary = 0.0;
    CGFloat accuary = 0.0;
    
    for (int i = 0; i < self.challengeModels.count; i++) {
        ChallengeModel *challenge = self.challengeModels[i];
        
        
        totalLevel = [challenge.totalLevel integerValue];
        
        accuary = [challenge.accuracy doubleValue];
        
        if (accuary > topAccuary) {
            topAccuary = accuary;
        }
        
        challenge.passedLevel = [NSString stringWithFormat:@"%ld",self.passCount];
    }
    
    if (self.hideTab) {
        
//        self.homeCBG.image = [UIImage imageNamed:@"challenge_homechallenge_bg"];
//        self.homeBg.hidden = NO;
//        self.infoView.hidden = YES;
//        self.backgroundImage.hidden = YES;
//        self.dataBgView.hidden = YES;
    } else {
        
//        self.homeCBG.hidden = YES;
//        self.homeBg.hidden = YES;
        
        self.progress.text = [NSString stringWithFormat:@"进度:%ld/%ld",self.passCount,totalLevel];
        
        CGFloat percentage = (CGFloat)self.passCount / totalLevel;
        self.completionPercentage.text = [NSString stringWithFormat:@"%.0f%%",percentage * 100];
        
        self.rightRate.text = [NSString stringWithFormat:@"最高正确率:%.0f%%",topAccuary * 100];
    }
    
    
    
    __weak ChallengeViewController *weakSelf = self;
    
    self.collectionView.didSelectItemAtIndexPath = ^(UICollectionView *collectionView, NSIndexPath *indexPath, ChallengeModel *challenge) {
        
        NSInteger level = indexPath.row;
        
        weakSelf.current = challenge;
        
        if (level <= [challenge.passedLevel integerValue]) {
            
            [weakSelf initChallengeStartView];
            
        } else {
            [weakSelf showHUDWithMode:MBProgressHUDModeText message:@"该关未解锁"];
            [weakSelf hideHUDAfter:1];
        }
    };

}

-(void)initChallengeStartView{
    
    ChallengeStartView *challengeStartView = [[[NSBundle mainBundle] loadNibNamed:@"ChallengeStartView" owner:nil options:nil] lastObject];
    
    challengeStartView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    challengeStartView.tag = 100;
    
    [challengeStartView updateUIWithModel:self.current];
    
    
    challengeStartView.startToPlay = ^(UIButton *button) {
        [self fetchChallengeQuestionForLevel:self.current.currentLevel];
    };
    
    [self.navigationController.view addSubview:challengeStartView];
}

- (void)initWaveView {
    if (!self.wave) {
        self.wave = [[WaterWaveView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
        self.wave.backgroundColor = [UIColor colorwithHexString:@"#ff9a11"];
        [self.wave startWaveAnimation];
    }
    [self.view addSubview:self.wave];
    [self.view bringSubviewToFront:self.infoView];
}

@end
