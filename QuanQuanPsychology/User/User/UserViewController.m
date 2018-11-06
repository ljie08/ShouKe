//
//  UserViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/12.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "UserViewController.h"
#import "UserListCell.h"

#import "UserInfoViewController.h"

#import "SettingViewController.h"
#import "MyErrorExerciseVC.h"
#import "MyNewsViewController.h"
#import "MyLiveCourseViewController.h"
#import "UserCPViewController.h"

#import "UserModel.h"
#import "ArchiveHelper.h"

//#import "UIView+EAFeatureGuideView.h"

#import "UserHeaderCell.h"
#import "UserTypeCell.h"
#import "UserHistoryCell.h"
#import "AboutAppViewController.h"
#import "UserHistoryAPI.h"
#import "FeedbackViewController.h"
#import "VideoRecordModel.h"
#import "LiveViewController.h"
#import "PlayRecordModel.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *userView;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *historyArr;/**< <#注释#> */

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [self setBackButton:NO isBlackColor:YES];
    [self featchHistorys];
    [self updateUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    
    [super updateViewConstraints];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    [self initGuideView]; 2.1版本失效
    [self initLiveCourseGuide];
    
//    [self gradient];
}

#pragma mark - action
- (IBAction)settingAction:(id)sender {
    UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    SettingViewController *settingVC = [user instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - data
- (void)featchHistorys {
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
    weakSelf(self);
    [UserHistoryAPI fetchUserHistoryWithUID:USERUID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            [self hideHUD];
            if (weakSelf.historyArr.count) {
                [weakSelf.historyArr removeAllObjects];
            }
            NSDictionary *dict = (NSDictionary *)data;
            NSArray *arr = [dict objectForKey:@"user_history"];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *d = arr[i];
                VideoRecordModel *model = [[VideoRecordModel alloc] initWithDict:d];
                [weakSelf.historyArr addObject:model];
            }
        } else {
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - UI
-(void)updateUI{
    self.tableView.backgroundView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    //导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    //加阴影
    [self.userView shadowOffset:CGSizeMake(0, 0.5) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:3 shadowOpacity:1];
    
    self.view.backgroundColor = [UIColor colorwithHexString:@"#fafafa"];
    
    [QuanUtils clipViewCornerRadius:self.avatar.frame.size.height / 2 withImage:self.avatar.image andImageView:self.avatar];
    
//    self.userView.layer.cornerRadius = 7.5;
//    self.userView.layer.masksToBounds = YES;
    
    
    UserModel *user = [ArchiveHelper unarchiveModelWithKey:@"userInfo" docePath:@"userInfo"];
    
    [self.avatar sd_setImageWithURL:[QuanUtils fullImagePath:user.portrait] placeholderImage:[UIImage imageNamed:@"default_avater"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [QuanUtils clipViewCornerRadius:self.avatar.frame.size.height / 2 withImage:self.avatar.image andImageView:self.avatar];
    }];

    self.userName.text = user.userName;

}

-(void)gradient{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.userView.bounds;
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)[UIColor colorwithHexString:@"58c6e7"].CGColor,
                             (__bridge id)[UIColor colorwithHexString:@"55ecb7"].CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.5f), @(1.0f)];
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.userView.layer addSublayer:gradientLayer];
    [self.userView bringSubviewToFront:self.userName];
    [self.userView bringSubviewToFront:self.avatar];
    
}


-(void)initGuideView __attribute__((deprecated("UserCENGuide1 2.1 版本已过期"))){
    
//    CGRect tableRect = [self.tableView convertRect:self.tableView.bounds toView:self.view];
//
//    CGRect rect = CGRectMake(tableRect.origin.x, tableRect.origin.y, 150, 90);
//    EAFeatureItem *news = [[EAFeatureItem alloc] initWithFocusRect:rect focusCornerRadius:0 focusInsets:UIEdgeInsetsZero];
//    news.introduce = @"刷题法宝.png";
//    news.indicatorImageName = @"引导箭头";
//
//    CGRect noteRect = [self.noteView convertRect:self.noteView.bounds toView:self.view];
//
//    EAFeatureItem *note = [[EAFeatureItem alloc] initWithFocusRect:noteRect focusCornerRadius:0 focusInsets:UIEdgeInsetsZero];
//    note.introduce = @"你写的所有笔记全部在这儿.png";
//    note.indicatorImageName = @"引导箭头";
//    note.buttonBackgroundImageName = @"朕知道了";
//    note.action = ^(id sender){
//
//    };
//
//    [self.navigationController.view showWithFeatureItems:@[note,news] saveKeyName:@"UserCENGuide1" inVersion:nil];
}

-(void)initLiveCourseGuide{
    
//    CGRect liveCourseRect = [self.courseView convertRect:self.courseView.bounds toView:self.view];
//
//    EAFeatureItem *liveCourse = [[EAFeatureItem alloc] initWithFocusRect:liveCourseRect focusCornerRadius:0 focusInsets:UIEdgeInsetsZero];
//    liveCourse.introduce = @"你的课程在这儿.png";
////    liveCourse.indicatorImageName = @"引导箭头";
//    liveCourse.buttonBackgroundImageName = @"朕知道了";
//    liveCourse.action = ^(id sender){
//
//    };
//
//    [self.navigationController.view showWithFeatureItems:@[liveCourse] saveKeyName:@"UserLiveCourseGuide" inVersion:nil];
}

#pragma mark - Gesture

- (IBAction)userInfo:(UITapGestureRecognizer *)sender {
    
    UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    
    UserInfoViewController *userInfoVC = [user instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!indexPath.section) {
        UserHeaderCell *cell = [UserHeaderCell myCellWithTableview:tableView];
        UserModel *user = [ArchiveHelper unarchiveModelWithKey:@"userInfo" docePath:@"userInfo"];
        [cell setDataWithModel:user];
        
        return cell;
    } else if (indexPath.section == 1) {
        weakSelf(self);
        UserTypeCell *cell = [UserTypeCell myCellWithTableview:tableView];
        cell.cardBlock = ^{
            UserCPViewController *userCPVC = [[UserCPViewController alloc] init];
            [weakSelf.navigationController pushViewController:userCPVC animated:YES];
        };
        cell.courseBlock = ^{
            MyLiveCourseViewController *liveCourseVC = [[MyLiveCourseViewController alloc] init];
            liveCourseVC.urlRequest = [SEVER_QUAN_API stringByAppendingString:@"hcxl/myCourse/myCourse_list.html?flag=4"];
            [weakSelf.navigationController pushViewController:liveCourseVC animated:YES];
        };
        cell.misstakeBlock = ^{
            MyErrorExerciseVC *errorVC = [[MyErrorExerciseVC alloc] init];
            [weakSelf.navigationController pushViewController:errorVC animated:YES];
        };
        
        return cell;
    } else if (indexPath.section == 2) {
        
        UserHistoryCell *cell = [UserHistoryCell myCellWithTableview:tableView historyArr:self.historyArr];
        
        cell.block = ^(NSInteger index) {
            NSLog(@"%ld", index);
            //videovc
            VideoRecordModel *model = self.historyArr[indexPath.row];
            
            LiveViewController *liveVC = [[LiveViewController alloc] init];
            
            NSString *path = [SEVER_QUAN_API stringByAppendingString:@"hcxl/course/course_detail.html?is_record&id="];
            
            liveVC.urlRequest = [NSString stringWithFormat:@"%@%@", path, model.course_id];
            PlayRecordModel *record = [[PlayRecordModel alloc] init];
            record.cousre_id = model.course_id;
            record.playtime = [model.complete_time doubleValue];
            record.video_id = model.v_id;
            liveVC.record = record;
            
            [self.navigationController pushViewController:liveVC animated:YES];
        };
        
        [cell.historyCollectionview reloadData];
        
        return cell;
    }
    static NSString *ID = @"UserListCell";
    UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    [cell configureCellWithIndex:indexPath];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 133;
    } else if (indexPath.section == 1) {
        return 85;
    } else if (indexPath.section == 2) {
        return self.historyArr.count ? 170 : 40;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    if (!indexPath.section) {
        UserInfoViewController *userInfoVC = [user instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    } else if (indexPath.section == 3) {
        if (!indexPath.row) {
            //意见反馈
            FeedbackViewController *feedVC = [user instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
            feedVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedVC animated:YES];
        } else {
            //关于
            AboutAppViewController *aboutVC = [user instantiateViewControllerWithIdentifier:@"AboutAppViewController"];
            aboutVC.navTitle = @"关于知邻";
            aboutVC.content = @"“知邻”APP 是华东人才教育集团独创的在线心理学习平台，继承了集团在传统教 育行业长达十五年的心理培训经验和授课精华。\n“知邻”APP 具备自主题库研发团队，使用题库知识卡片式学习和预估考分模型， 改进传统枯燥的线性学习方法，以自适应学习结合人工智能开启了全新的学习体验！\n无需万元学费，无需大量时间，更不要堆聚如山教辅资料；有效利用碎片化时间，聚沙成塔， 打造更强大的记忆方式，开启更高效的学习模式。不论学生、家长、职场白领，0 基础或者 专业人士均可轻松在线学习心理学！";
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
//    switch (indexPath.row) {
//        case 0:
//            {
//                MyNewsViewController *newsVC = [user instantiateViewControllerWithIdentifier:@"MyNewsViewController"];
//                [self.navigationController pushViewController:newsVC animated:YES];
//            }
//            break;
//
//        case 1:
//            {
//
//            }
//            break;
//
//        case 2:
//        {
//            MyLiveCourseViewController *liveCourseVC = [[MyLiveCourseViewController alloc] init];
//            liveCourseVC.urlRequest = [SEVER_QUAN_API stringByAppendingString:@"hcxl/myCourse/myCourse_list.html"];
//            [self.navigationController pushViewController:liveCourseVC animated:YES];
//        }
//            break;
//
//        case 3:
//        {
//            UserCPViewController *userCPVC = [[UserCPViewController alloc] init];
//
//            [self.navigationController pushViewController:userCPVC animated:YES];
//        }
//            break;
//
//        case 4:
//        {
//            SettingViewController *settingVC = [user instantiateViewControllerWithIdentifier:@"SettingViewController"];
//            [self.navigationController pushViewController:settingVC animated:YES];
//        }
//            break;
//
//        default:
//            break;
//    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (NSMutableArray *)historyArr {
    if (!_historyArr) {
        _historyArr = [NSMutableArray array];
    }
    return _historyArr;
}

@end
