//
//  CardViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardViewController.h"
#import "ExerciseViewController.h"
#import "CardOverviewViewController.h"

#import "CardCVCell.h"
#import "CardImageCVCell.h"

#import "ShareView.h"
#import "BarProgressView.h"
//#import "ActivationCodeView.h"

#import "ShareModel.h"
#import "CardPackageModel.h"
#import "CPStudyRecordModel.h"

#import "ArchiveHelper.h"

#import "UserStudyInfoAPI.h"
#import "CardAPI.h"
#import "CardPackageAPI.h"
#import "UserRightsAPI.h"

#import "QuanIAPManager.h"
#import "CardPackagePayAPI.h"

#define CARDCELLWIDTH ScreenWidth * 0.92
#define CARDCELLHEIGHT ScreenHeight * 0.84


static NSString * const cellID = @"CardCVCell";
static NSString * const imageCellID = @"CardImageCVCell";


@interface CardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,CardDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) ShareView *shareView;

@property (strong, nonatomic) BarProgressView *cardProgressView;

@property (strong, nonatomic) NSMutableDictionary *cardsIsFrontDict;/* 卡片是否已翻页 */

@property (assign, nonatomic) BOOL isFront;/* 卡片是否是正面 */

@property (assign, nonatomic) NSInteger currentCard;

@property (strong, nonatomic) NSArray *cards;/* 卡片 */

@property (assign, nonatomic) BOOL seletedCard;/* 跳转到已选择的卡片 */


@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self updateUI];
    [self addNotification];
    [self fetchCards];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
-(void)fetchCards{
    
//    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
    
    [CardAPI fetchCardsWithID:self.cp.cpID uid:USERUID callback:^(APIReturnState state, id data, NSString *message) {
        
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSArray *list = dict[LIST];
            
            [self saveToCardModel:list];
            
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
}

-(void)initData{
    
    self.currentCard = 0;
    
    self.cardsIsFrontDict = [NSMutableDictionary dictionary];
    
}

-(void)saveToCardModel:(NSArray *)cards{
    
    NSInteger page = 0;
    
    NSMutableArray *cardModels = [NSMutableArray array];
    
    for (int i = 0; i < cards.count; i++) {
        NSDictionary *dict = cards[i];
        
        CardModel *card = [[CardModel alloc] initWithDict:dict];
                
        if ([self.lastCardRecord isEqualToString:card.cardID]){
            page = i;
        }
        
        [cardModels addObject:card];
    }
    
    self.cards = [cardModels copy];
    
    if (self.seletedCard) {
        [self.collectionView setContentOffset:CGPointMake(self.currentCard * ScreenWidth, 0) animated:YES];
        self.cardProgressView.progressValue = (CGFloat)(self.currentCard + 1) / self.cards.count * ScreenWidth;
    } else {
        [self.collectionView setContentOffset:CGPointMake(page * ScreenWidth, 0) animated:YES];
        self.cardProgressView.progressValue = (CGFloat)(page + 1) / self.cards.count * ScreenWidth;
    }
    
    
    [self.collectionView reloadData];
    
    self.title = [NSString stringWithFormat:@"知识卡（%ld/%lu）",self.currentCard + 1,(unsigned long)self.cards.count];
}

#pragma mark - UI
-(void)updateUI{
    
    self.title = @"卡片";
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.cardProgressView = [[BarProgressView alloc] initWithFrame:CGRectMake(0, NavHeight + StatusHeight, ScreenWidth, 5)];
    self.cardProgressView.progressTintColor = [UIColor colorwithHexString:@"#e8e8e8"];
    self.cardProgressView.trackTintColor = [UIColor customisMainGreen];
    [self.view addSubview:self.cardProgressView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerNib:[UINib nibWithNibName:imageCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:imageCellID];
    
}

#pragma mark - Notification
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCard:) name:@"JumpToSelectedCard" object:nil];
}

-(void)selectedCard:(NSNotification *)noti{
    
    NSDictionary *dict = noti.userInfo;
    
    NSString *cardID = dict[@"cardID"];
    
    BOOL isNext = NO;
    
    if (dict[@"isNext"]) {
        isNext = [dict[@"isNext"] boolValue];
    }
    
    self.seletedCard = YES;
    
    for (int i = 0; i < self.cards.count; i++) {
        CardModel *card = self.cards[i];
        if ([card.cardID isEqualToString:cardID]) {
            if (isNext) {
                [self.collectionView setContentOffset:CGPointMake((i + 1) * ScreenWidth, 0) animated:YES];
                self.currentCard = i + 1;
            } else {
                [self.collectionView setContentOffset:CGPointMake(i * ScreenWidth, 0) animated:YES];
                self.currentCard = i;
            }
        }
    }
    
    self.cardProgressView.progressValue = (CGFloat)(self.currentCard + 1) / self.cards.count * ScreenWidth;
    
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cards.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *value = [self.cardsIsFrontDict valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    self.isFront = [value boolValue];

    CardModel *card = self.cards[indexPath.row];
    
    
    if (![NSString stringIsNull:card.cardPic]) {

        CardImageCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellID forIndexPath:indexPath];
    

        [cell setValueWithModel:card front:self.isFront];
        cell.delegate = self;

        return cell;

    } else {

        CardCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.delegate = self;
        
        [cell setValueWithModel:card front:self.isFront];
        
        return cell;
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CardModel *card = self.cards[indexPath.row];
    
    BOOL hasRecord = NO;
    
    NSArray *studyRecords = [ArchiveHelper unarchiveListWithKey:@"CPStudyRecordModel" docePath:@"CPStudyRecordModel"];
    
    for (int i = 0; i < studyRecords.count; i++) {
        
        CPStudyRecordModel *record = studyRecords[i];
        
        if (record.cp.cpID == self.cp.cpID) {
            hasRecord = YES;
            record.cp = self.cp;
            record.cardID = card.cardID;
            [ArchiveHelper archiveList:studyRecords forKey:@"CPStudyRecordModel" docePath:@"CPStudyRecordModel"];
            break;
        } else {
            hasRecord = NO;
        }
    }
    
    if (!hasRecord) {
        NSMutableArray *updateRecords = [NSMutableArray arrayWithArray:studyRecords];
        
        CPStudyRecordModel *record = [[CPStudyRecordModel alloc] init];
        record.cp = self.cp;
        record.cardID = card.cardID;
        [updateRecords addObject:record];
        
        [ArchiveHelper archiveList:updateRecords forKey:@"CPStudyRecordModel" docePath:@"CPStudyRecordModel"];
    }
    

    
    NSNumber *value = [self.cardsIsFrontDict valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    self.isFront = [value boolValue];
    
    self.isFront = self.isFront ? NO : YES;
    [self.cardsIsFrontDict setValue:[NSNumber numberWithBool:self.isFront] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[CardCVCell class]]) {
        
        CardCVCell *card = (CardCVCell *)cell;
        [UIView transitionWithView:cell duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [card setUIStatus:self.isFront];
            
        } completion:^(BOOL finished) {

        }];
        
    } else if ([cell isKindOfClass:[CardImageCVCell class]]){
        
        CardImageCVCell *card = (CardImageCVCell *)cell;
        [UIView transitionWithView:cell duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [card setUIStatus:self.isFront];
            
        } completion:^(BOOL finished) {

            
        }];
        
    }
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CARDCELLWIDTH,CARDCELLHEIGHT);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, (ScreenWidth - CARDCELLWIDTH ) / 2, 0, (ScreenWidth - CARDCELLWIDTH ) / 2);
}

//设置每个item line spaceing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return ScreenWidth * 0.04 * 2;
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetX = scrollView.contentOffset.x;
    
    
    self.currentCard = offsetX / ScreenWidth;
    
    self.cardProgressView.progressValue = (CGFloat)(self.currentCard + 1) / self.cards.count * ScreenWidth;
    self.collectionView.scrollEnabled = YES;

    self.title = [NSString stringWithFormat:@"知识卡（%ld/%lu）",self.currentCard + 1,(unsigned long)self.cards.count];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    

}

#pragma mark - <CardDelegate>
-(void)doCardExercise:(UIButton *)button{
    
    CardModel *card = self.cards[self.currentCard];
    CardModel *lastCard = self.cards.lastObject;
    
    if (card.hasQuestion) {
        
        [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
        
        [CardAPI fetchQuesWithCardID:card.cardID uid:USERUID callback:^(APIReturnState state, id data, NSString *message) {
            if (state == API_SUCCESS) {
                [self hideHUD];
                NSDictionary *dict = (NSDictionary *)data;
                [self pushToExerciseVCWithQues:dict[LIST] cardID:card.cardID lastCardID:lastCard.cardID];
            } else {
                [self updateHUDWithMode:MBProgressHUDModeText message:message];
                [self hideHUDAfter:1];
            }
        }];
        
        
        
    } else {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *noQustReminder = [userDefaults valueForKey:UDNOQUESREMINDER];
        
        if ([NSString stringIsNull:noQustReminder]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该知识卡没有练习题，点击已掌握来完成知识卡。" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                [self sendUserExerciseToSeverWithCardID:card.cardID];
                
                [userDefaults setValue:@"noQuesTip" forKey:UDNOQUESREMINDER];
                [userDefaults synchronize];
            }];
            
            [alert addAction:confirm];
            
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self sendUserExerciseToSeverWithCardID:card.cardID];
        }
        
    }
}

#pragma mark - Button Actions
-(void)popToUnitVC{
    
    
}

- (IBAction)showAllCards:(UIBarButtonItem *)sender {
    
    UIStoryboard *study = [UIStoryboard storyboardWithName:@"Study" bundle:[NSBundle mainBundle]];
    
    CardOverviewViewController *overviewVC = [study instantiateViewControllerWithIdentifier:@"CardOverviewViewController"];
    
    overviewVC.allCards = self.cards;
        
    [self.navigationController pushViewController:overviewVC animated:YES];
}

- (IBAction)share:(UIBarButtonItem *)sender {
    
    
//    [self getAlreadyCards];

    [self initShareData];

}

-(void)initShareData{
    
    self.shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    [self.navigationController.view addSubview:self.shareView];
    
    NSString *path = [SEVER_QUAN_API stringByAppendingString:@"hcxl/shareCard/card.html?id="];
        
    CardModel *card = self.cards[self.currentCard];
    
    NSString *urlString = [path stringByAppendingString:card.cardID];
    
//    [[DataManager shareDataMangaer] fetchCourseInfoWithCourseID:USERCOURSE];
    NSString *courseName = @"";
    
    UIImage *image = [UIImage imageNamed:@"分享小人"];
    
    self.shareView.platformView.shareIcon = image;
    self.shareView.platformView.shareURL = urlString;
    self.shareView.platformView.shareMaterialDifferent = YES;
    self.shareView.platformView.shareTitle = @"手握这张卡，逢考必过";
    self.shareView.platformView.shareSubTitle = [NSString stringWithFormat:@"%@学生专属APP！",courseName];
    self.shareView.platformView.currentVC = self;
    
}


-(void)pushToExerciseVCWithQues:(NSArray *)questions cardID:(NSString *)cardID lastCardID:(NSString *)lastCardID{
    
    UIStoryboard *study = [UIStoryboard storyboardWithName:@"Study" bundle:[NSBundle mainBundle]];
    ExerciseViewController *exerciseVC = [study instantiateViewControllerWithIdentifier:@"ExerciseViewController"];
    exerciseVC.allQues = questions;
    exerciseVC.cardID = cardID;
    exerciseVC.lastCardID = lastCardID;

    [self.navigationController pushViewController:exerciseVC animated:YES];
}

-(void)sendUserExerciseToSeverWithCardID:(NSString *)cardID{
    
    [CardPackageAPI sendCardPackageExerciseQuestionWithUID:USERUID cardID:cardID quesList:@[] callback:^(APIReturnState state, id data, NSString *message) {
        NSLog(@"%@卡包卡片练习问题提交-%@",cardID,message);
        [self fetchCards];
    }];
    
}

@end
