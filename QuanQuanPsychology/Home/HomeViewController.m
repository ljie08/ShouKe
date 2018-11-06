//
//  HomeViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/5.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "JPUSHService.h"

#import "HomeViewController.h"
#import "MyNewsViewController.h"
#import "CPListViewController.h"
#import "PackageDetailViewController.h"
#import "ChallengeViewController.h"
#import "CourseSelectionViewController.h"
#import "CardPackageViewController.h"

#import "HomeView.h"
#import "NewVersionGuideView.h"
#import "HomePopupView.h"
#import "HomeHeaderView.h"


#import "PopupModel.h"
#import "CardPackageModel.h"
#import "VideoCourseModel.h"

#import "LoginAPI.h"
#import "UserStudyInfoAPI.h"
#import "NewsNotificationAPI.h"
#import "SecurityAPI.h"
#import "UserRightsAPI.h"
#import "EventAPI.h"
#import "HomeAPI.h"

#import "ArchiveHelper.h"

#import "BannerPageView.h"
#import "HomeCourseCollectionView.h"
#import "CPBasicListCollectionView.h"

#import "DiscoveryDetailViewController.h"
#import "LiveViewController.h"
#import "PunchCardView.h"
#import "PunchCardModel.h"
#import "HomeCourseCVCell.h"

#import "WSPageView.h"
#import "WSIndexBanner.h"

@interface HomeViewController ()<NewVersionGuideViewDelegate,BannerPageViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, WSPageViewDelegate, WSPageViewDataSource>

/* ViewConstraints */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollH;//页面高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseCollectionH;//精选好课高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH;//精选卡包高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classR;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exerciseR;

//-----------
@property (weak, nonatomic) IBOutlet BannerPageView *banner;

@property (weak, nonatomic) IBOutlet UIView *tabView;

@property (weak, nonatomic) IBOutlet HomeView *courseTab;

@property (weak, nonatomic) IBOutlet HomeView *cpTab;

@property (weak, nonatomic) IBOutlet HomeView *exerciseTab;

@property (weak, nonatomic) IBOutlet HomeView *classTab;

@property (weak, nonatomic) IBOutlet HomeHeaderView *courseHeader;

@property (weak, nonatomic) IBOutlet HomeCourseCollectionView *courseCollectionView;
@property (weak, nonatomic) IBOutlet UIView *courseBgView;

@property (weak, nonatomic) IBOutlet CPBasicListCollectionView *cpCollectionView;
@property (nonatomic, strong) NSMutableArray *courseArr;/**< <#注释#> */

/*  */
@property (strong, nonatomic) NSArray *bannerLinks;

@property (nonatomic, strong) PunchCardView *cardView;/**< <#注释#> */

@property (nonatomic, strong) WSPageView *pageBanner;/**< <#注释#> */
@property (nonatomic, strong) NSMutableArray *imgArr;/**< banner图片 */

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    /* 导航栏字体颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self updateUI];

    [self addJPushAlias];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedNews:) name:@"UPDATEDNEWS" object:nil];
    
    NSDictionary *remoteNotification = [[NSUserDefaults standardUserDefaults] valueForKey:UDREMOTENOTIFICATION];
    
    if (remoteNotification) {
        [self updatedNews:nil];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UDREMOTENOTIFICATION];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    /* 导航栏字体颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor customisMainColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self fetAllAPI];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.courseCollectionH.constant = 150;
    
    self.collectionH.constant = 40 + 200 * ceilf(self.cpCollectionView.cpLists.count / 2);
    self.scrollH.constant = self.courseCollectionH.constant + self.collectionH.constant + 40 + ScreenWidth * 0.5 + 25;
    
    self.courseL.constant = self.cpL.constant = self.exerciseR.constant = self.classR.constant = (ScreenWidth - 45 * 4) / 5;
    
}

- (void )setBannerView {
    if (!self.pageBanner) {
        self.pageBanner = [[WSPageView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 180*Width_Scale-20)];
        self.pageBanner.delegate = self;
        self.pageBanner.dataSource = self;
        self.pageBanner.minimumPageAlpha = 0.5;   //非当前页的透明比例
        self.pageBanner.minimumPageScale = 0.94;  //非当前页的缩放比例
        self.pageBanner.orginPageCount = self.imgArr.count; //原始页数
        self.pageBanner.autoTime = 3;    //自动切换视图的时间,默认是5.0
        [self.pageBanner startTimer];
        [self.banner addSubview:self.pageBanner];
    }
    
//    //初始化pageControl
//    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageView.frame.size.height - 8 - 10, ScreenWidth, 8)];
//    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
//    pageView.pageControl = pageControl;
//    [pageView addSubview:pageControl];
}

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(WSPageView *)flowView {
    return CGSizeMake(ScreenWidth - 30, 180*Width_Scale-20);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    if (self.bannerLinks.count != 0) {
        
        NSString *url = self.bannerLinks[subIndex];
        
        if ([url containsString:@"is_player"]) {
            LiveViewController *liveVC = [[LiveViewController alloc] init];
            liveVC.urlRequest = url;
            [self.navigationController pushViewController:liveVC animated:YES];
            
        } else {
            DiscoveryDetailViewController *detailVC = [[DiscoveryDetailViewController alloc] init];
            detailVC.urlRequest = url;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(WSPageView *)flowView {
    return self.imgArr.count;
}

- (UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index{
    WSIndexBanner *bannerView = (WSIndexBanner *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth - 30, 180*Width_Scale-20)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    NSURL *url = [QuanUtils fullImagePath:self.imgArr[index]];
    [bannerView.mainImageView sd_setImageWithURL:url];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WSPageView *)flowView {
    NSLog(@"滚动到了第%ld页",pageNumber);
}

#pragma mark - --
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Update APP
-(void)updateAPP{
    
//    [QQUpdateApp updateWithAPPID:@"1256372985" withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
//        if (isUpdate) {
//
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            NSString *appStoreVersion = [userDefaults valueForKey:UDAPPVERSION];
//
//            if (![appStoreVersion isEqualToString:storeVersion]) {
//
//                [userDefaults setValue:storeVersion forKey:UDAPPVERSION];
//                [userDefaults synchronize];
//
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"检测到新版本，是否更新？" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//                }];
//
//                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                    [QuanUtils openScheme:openUrl];
//
//                }];
//
//                alert.view.tintColor = [UIColor customisDarkGreyColor];
//                [alert addAction:cancel];
//                [alert addAction:sure];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
//
//
//        }else{
//            NSLog(@"当前版本%@,商店版本%@，不需要更新",currentVersion,storeVersion);
//        }
//
//    }];
}

#pragma mark - JPush
-(void)addJPushAlias{
    
    if (![NSString stringIsNull:USERUID]) {
        [JPUSHService setAlias:USERUID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"设置结果:%li,用户别名:%@,序列号:%ld",(long)iResCode,iAlias,(long)seq);
        } seq:0];
    }
    
}

#pragma mark - Data
-(void)fetAllAPI{
    
    NSString *date = [NSDate currentDateString];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *loginDate = [userDefaults valueForKey:UDLOGINDATE];
    
    if (![loginDate isEqualToString:date]) {
        if (![NSString stringIsNull:USERUID]) {
            [self updateAPP];
        }
    }
    
    [self fetchBannerImages];
    [self fetchRecommendCourse];
    [self fetchRecommendCP];
    [self checkSingleSignOn];
//    [self checkPopup];

}

-(void)fetchBannerImages{
    
    [HomeAPI fetchBannerImagesWithUID:USERUID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSArray *list = dict[LIST];
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *links = [NSMutableArray array];
            for (int i = 0 ; i < list.count; i++) {
                NSDictionary *info = list[i];
                NSString *path = info[PICPATH];
                NSString *link = info[@"link"];
                [array addObject:path];
                [links addObject:link];
            }
            if (self.imgArr.count) {
                [self.imgArr removeAllObjects];
            }
            [self.imgArr addObjectsFromArray:array];
//            [self.banner images:[array mutableCopy]];
            self.bannerLinks = [links mutableCopy];
            
            [self setBannerView];
        }
    }];
}

-(void)fetchRecommendCourse{
    weakSelf(self);
    [HomeAPI fetchHomeRecommendCourseWithCourseID:USERCOURSE callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            
            NSDictionary *dict = (NSDictionary *)data;
            NSArray *list = dict[LIST];
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0 ; i < list.count; i++) {
                NSDictionary *info = list[i];
                VideoCourseModel *course = [[VideoCourseModel alloc] initWithDict:info];
                [array addObject:course];
            }
            
            if (weakSelf.courseArr.count) {
                [weakSelf.courseArr removeAllObjects];
            }
            [weakSelf.courseArr addObjectsFromArray:array];
            
            self.courseCollectionView.courseLists = [array mutableCopy];
            
            [self.courseCollectionView reloadData];
            
            [self updateViewConstraints];
        }
    }];
}

-(void)fetchRecommendCP{
    
    [HomeAPI fetchHomeRecommendCPWithUID:USERUID courseID:USERCOURSE callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSArray *list = dict[LIST];
            
            NSMutableArray *cardPackageList = [NSMutableArray array];
            
            for (int i = 0; i < list.count; i++) {
                NSDictionary *dict = list[i];
                
                CardPackageModel *model = [[CardPackageModel alloc] initWithDict:dict];
                
                [cardPackageList addObject:model];
                
            }
            
            self.cpCollectionView.cpLists = [cardPackageList copy];
            
            [self.cpCollectionView reloadData];
            [self updateViewConstraints];
            
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

-(void)checkSingleSignOn{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *identification = [userDefaults valueForKey:UDSINGLESIGNONUUID];
    
    if ([NSString stringIsNull:identification]) {
        identification = @"";
    }
    
    [SecurityAPI checkSingleSignOnWithUID:USERUID identification:identification callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSString *uuid = dict[@"identification"];
            
            if (![NSString stringIsNull:uuid]) {
                [userDefaults setValue:uuid forKey:UDSINGLESIGNONUUID];
                [userDefaults synchronize];
            }
            
        }
    }];
}

-(void)checkPopup{
    
    [EventAPI checkPopupwithCourseID:USERCOURSE callback:^(APIReturnState state, id data, NSString *message) {
        
        if (state == API_SUCCESS) {

            NSDictionary *dict = (NSDictionary *)data;
            
            id list = dict[LIST];
            
            if ([list isKindOfClass:[NSArray class]]) {
                
                [self savePopupInfo:list];
            }
        }
    }];
}

-(void)savePopupInfo:(NSArray *)list{
    
    BOOL navGuide = NO;
//    [UIView hasShowFeatureGuideWithKey:@"HomeStudyGuidecase" version:nil];
    
    if (navGuide) {
        
        NSString *docPath = [NSString stringWithFormat:@"homepopup%@.plist",USERCOURSE];
        
        NSDictionary *popupInfo = [ArchiveHelper unarchiveDictWithDocePath:docPath];
        NSString *popDate = popupInfo[USERCOURSE];
        
        for (int i = 0; i < list.count; i++) {
            
            NSDictionary *dict = list[i];
            
            PopupModel *popup = [[PopupModel alloc] initWithDict:dict];
            
            NSDate *startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
            
            NSInteger todayStart = [[NSDate creatTimeCodeWithDate:startOfToday] integerValue];
            NSInteger startTime = [[NSDate creatTimeCodeWithString:popup.popupStartTime] integerValue];
            NSInteger endTime = [[NSDate creatTimeCodeWithString:popup.popupEndTime] integerValue];
            NSString *currentTimeCode = [NSDate creatTimeCode];
            NSInteger currentTime = [currentTimeCode integerValue];
        
            NSInteger popTime = [popDate integerValue];
            
            if (popDate == nil || popTime < todayStart) {
                
                if (currentTime >= startTime && currentTime <= endTime) {
                    
                    [self creatPopupView:popup];
                    
                    NSDictionary *popupInfo = [NSDictionary dictionaryWithObjectsAndKeys:currentTimeCode,USERCOURSE, nil];
                    [ArchiveHelper archiveDict:popupInfo docePath:docPath];
                    
                    break;
                }
                
            }
            
        }
        
    }
    
}

- (void)fetchPunchCardData {
    weakSelf(self);
    [HomeAPI fetchPunchCardWithUID:USERUID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSDictionary *signDic = [dict objectForKey:@"data"];
            PunchCardModel *model = [[PunchCardModel alloc] init];
            model.signs = [[signDic objectForKey:@"signs"] integerValue];
            model.mySignFlag = [[signDic objectForKey:@"mySignFlag"] boolValue];
            
            [weakSelf initCardViewWithCard:model];
        }
    }];
}

- (void)funchCard {
    weakSelf(self);
    
    [HomeAPI savePunchCardWithUID:USERUID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
//            NSDictionary *dict = (NSDictionary *)data;
            [weakSelf.cardView updateCardBtnEnabeld:NO];
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

#pragma mark - UI
-(void)initUI{
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *value = [USERDEFAULTS valueForKey:[NSString stringWithFormat:@"App新版本引导%@",version]];
    
    if ([NSString stringIsNull:value]) {

        NewVersionGuideView *guide = [[NewVersionGuideView alloc] initWithFrame:self.view.bounds];
        guide.delegate = self;
        [[[UIApplication sharedApplication] keyWindow] addSubview:guide];

        [USERDEFAULTS setObject:@"show" forKey:[NSString stringWithFormat:@"App新版本引导%@",version]];
        [USERDEFAULTS synchronize];
    }
    
}

-(void)updateUI{
    self.view.backgroundColor = [UIColor colorwithHexString:@"#fafafa"];
    
    [self.courseTab updateIcon:[UIImage imageNamed:@"h_class"] item:@"报班"];
    [self.cpTab updateIcon:[UIImage imageNamed:@"h_course"] item:@"上课"];
    [self.exerciseTab updateIcon:[UIImage imageNamed:@"h_test"] item:@"刷题"];
    [self.classTab updateIcon:[UIImage imageNamed:@"h_daka"] item:@"打卡"];
    
    
    __weak HomeViewController *weakSelf = self;
    
    
//    self.banner.delegate = self;
//    self.banner.duringTime = 2.0;
    
    self.cpCollectionView.hasHeaderView = YES;
    self.cpCollectionView.didClickMoreCPButton = ^(UIButton *button) {
        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        CPListViewController *cpVC = [main instantiateViewControllerWithIdentifier:@"CPListViewController"];
        
        cpVC.hideTab = YES;
        
        [weakSelf.navigationController pushViewController:cpVC animated:YES];
        
    };
    
    self.courseHeader.didClickMoreCourseButton = ^(UIButton *button) {
        
        DiscoveryDetailViewController *detailVC = [[DiscoveryDetailViewController alloc] init];
        
        detailVC.urlRequest = [SEVER_QUAN_API stringByAppendingString:@"hcxl/course/course_all.html"];
        
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
        
    };
    
    self.cpCollectionView.didSelectItemAtIndexPath = ^(UICollectionView *collectionView, NSIndexPath *indexPath, CardPackageModel *cp) {
        
        UIStoryboard *cardPackage = [UIStoryboard storyboardWithName:@"CardPackage" bundle:[NSBundle mainBundle]];
        
        if (cp.ownCardPackage) {
            
            CardPackageViewController *cpVC = [cardPackage instantiateViewControllerWithIdentifier:@"CardPackageViewController"];
            
            cpVC.cp = cp;
            
            [weakSelf.navigationController pushViewController:cpVC animated:YES];
            
        } else {
            
            PackageDetailViewController *detailVC = [cardPackage instantiateViewControllerWithIdentifier:@"PackageDetailViewController"];
            
            detailVC.cp = cp;
            
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }
    };


    
    
    self.courseCollectionView.didSelectItemAtIndexPath = ^(UICollectionView *collectionView, NSIndexPath *indexPath, VideoCourseModel *course) {
        NSString *courseID = course.courseID;
        
        LiveViewController *liveVC = [[LiveViewController alloc] init];
        
        NSString *path = [SEVER_QUAN_API stringByAppendingString:@"hcxl/course/course_detail.html?id="];
        
        liveVC.urlRequest = [path stringByAppendingString:courseID];
        
        [weakSelf.navigationController pushViewController:liveVC animated:YES];
    };

}



-(void)creatPopupView:(PopupModel *)popup{
    
    HomePopupView *popupView = [[HomePopupView alloc] initWithFrame:self.view.bounds];
    popupView.imagePath = popup.imagePath;
    
    popupView.popupLink = ^{
                
        if ([popup.url containsString:@"is_player"]) {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Discovery" bundle:[NSBundle mainBundle]];
//
//            LiveViewController *liveVC = [storyboard instantiateViewControllerWithIdentifier:@"LiveViewController"];
//
//            liveVC.urlRequest = popup.url;
//
//            [self.navigationController pushViewController:liveVC animated:YES];
        } else if ([NSString stringIsNull:popup.url]) {
            NSLog(@"关闭首页弹窗");
        } else {
//            DiscoveryDetailViewController *detailVC = [[DiscoveryDetailViewController alloc] init];
//            detailVC.urlRequest = popup.url;
//            
//            [self.navigationController pushViewController:detailVC animated:YES];
        }
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:popupView];
}

#pragma mark - BannerPageViewDelegate
-(void)didClickImageAtIndex:(NSInteger)index scrollView:(BannerPageView *)scrollView{
    
    if (self.bannerLinks.count != 0) {
        
        NSString *url = self.bannerLinks[index];
        
        if ([url containsString:@"is_player"]) {
            LiveViewController *liveVC = [[LiveViewController alloc] init];
            
            liveVC.urlRequest = url;
            
            [self.navigationController pushViewController:liveVC animated:YES];
            
        } else {
            
            DiscoveryDetailViewController *detailVC = [[DiscoveryDetailViewController alloc] init];
            
            detailVC.urlRequest = url;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }

    }
    
  
}

#pragma mark - Button Action

- (IBAction)changeCourse:(UIBarButtonItem *)sender {
    
    UIStoryboard *registerSB = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];
    
    CourseSelectionViewController *courseVC = [registerSB instantiateViewControllerWithIdentifier:@"CourseSelectionViewController"];
    
    courseVC.fromHome = YES;
    
    [self.navigationController pushViewController:courseVC animated:YES];
    
}

- (IBAction)newsDetail:(UIBarButtonItem *)sender {
    
    UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    
    MyNewsViewController *newsVC = [user instantiateViewControllerWithIdentifier:@"MyNewsViewController"];
    
    [self.navigationController pushViewController:newsVC animated:YES];
    
}


#pragma mark - Gesture

- (IBAction)homeViewTap:(UITapGestureRecognizer *)sender {
    
    NSInteger tag = sender.view.tag;
    
    switch (tag) {
        case 0://报班
        {
            DiscoveryDetailViewController *detailVC = [[DiscoveryDetailViewController alloc] init];
            
            detailVC.urlRequest = [SEVER_QUAN_API stringByAppendingString:@"hcxl/enroll/enroll_list.html?flag=3"];
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
            
        case 1://上课
        {
            DiscoveryDetailViewController *detailVC = [[DiscoveryDetailViewController alloc] init];
            
            detailVC.urlRequest = [SEVER_QUAN_API stringByAppendingString:@"hcxl/course/course_list.html"];
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
        case 2://刷题
        {
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

            ChallengeViewController *challengeVC = [main instantiateViewControllerWithIdentifier:@"ChallengeViewController"];
            challengeVC.hideTab = YES;
            [self.navigationController pushViewController:challengeVC animated:YES];

        }
            break;
            
        case 3://打卡
        {
            [self fetchPunchCardData];
        }
            break;
        
    }
}

- (void)initCardViewWithCard:(PunchCardModel *)card {
    if (!self.cardView) {
        self.cardView = [[NSBundle mainBundle] loadNibNamed:@"PunchCardView" owner:self options:nil].firstObject;
        self.cardView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    [self.cardView setViewsWithCard:card];

    weakSelf(self);
    self.cardView.cardBlock = ^{
        [weakSelf funchCard];
    };
    self.cardView.closeBlock = ^{
        [UIView animateWithDuration:1 animations:^{
            [weakSelf.cardView removeFromSuperview];
        }];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.cardView];
}

#pragma mark - Notification
-(void)updatedNews:(NSNotification *)noti{
    NSLog(@"推送");
    
    UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    
    MyNewsViewController *newsVC = [user instantiateViewControllerWithIdentifier:@"MyNewsViewController"];
    
    [self.navigationController pushViewController:newsVC animated:YES];
}

@end
