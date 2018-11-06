//
//  CourseSelectionViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/18.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CourseSelectionViewController.h"

#import "MainViewController.h"

#import "CourseAPI.h"

#import "BasicCourseTVCell.h"
#import "DetailCourseCVCell.h"

#import "CourseGeneralModel.h"
#import "CourseModel.h"

#import "ArchiveHelper.h"

@interface CourseSelectionViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *courseName;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *courses;/* 科目 */

@property (strong, nonatomic) NSArray *courseGrades;/* 科目等级 */

@property (assign, nonatomic) NSInteger selectedRow;/* 选中的主科目 */

@property (strong, nonatomic) CourseGeneralModel *currentCourse;


@property (strong, nonatomic) NSArray *coursesIDs;

@end

@implementation CourseSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self fetchCourses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)selectedRow{
    if (!_selectedRow) {
        _selectedRow = 0;
    }
    
    return _selectedRow;
}

#pragma mark - UI
-(void)updateUI{
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Data
-(void)fetchCourses{
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
    
    [CourseAPI fetchCourseNameWithCallback:^(APIReturnState state, id data, NSString *message) {
        
        if (state == API_SUCCESS) {
            
            [self hideHUD];

            NSDictionary *dict = (NSDictionary *)data;
            
            NSArray *list = dict[LIST];
            
            [self saveToGeneralCourseModelWithList:list];
            
            [self.tableView reloadData];
            [self.collectionView reloadData];
            
            NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:defaultIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            CourseGeneralModel *model = self.courses[0];
            
            self.courseName.text = model.courseGeneralName;
            
            
        } else {
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

-(void)saveToGeneralCourseModelWithList:(NSArray *)list{
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *ids = [NSMutableArray array];

    for (int i = 0; i < list.count; i++) {
        NSDictionary *dict = list[i];
        CourseGeneralModel *generalCourse = [[CourseGeneralModel alloc] init];
        [generalCourse setModelWithDict:dict];
        [array addObject:generalCourse];
        
        for (int j = 0;  j < generalCourse.detailCourse.count; j++) {
            CourseGradeModel *grade = generalCourse.detailCourse[j];
            [ids addObject:grade.courseID];
        }
    }
    
    self.courses = [array copy];
    self.coursesIDs = [ids copy];
    
}

-(NSArray *)getDetailCourseWithSelectedRow:(NSInteger)row{
    
    CourseGeneralModel *model = self.courses[row];
    
    NSArray *courseGrades = model.detailCourse;
    
    return courseGrades;
}

-(void)saveUserCourseWithID:(NSString *)courseID{
    
    [CourseAPI sendCourseID:courseID uid:USERUID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            
            if (self.fromHome) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                MainViewController *mainVC = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                
                [self.navigationController pushViewController:mainVC animated:YES];
            }
            
        } else {
            [self presentAlertWithTitle:message message:@"请稍后再试" actionTitle:@"好的"];
        }
    }];
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"BasicCourseTVCell";
    
    BasicCourseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    CourseGeneralModel *model = self.courses[indexPath.row];

    cell.courseName.text = model.courseGeneralName;
    
//    if (USERCOURSE) {
//        
//        NSArray *courseGrades = [self getDetailCourseWithSelectedRow:indexPath.row];
//
//        for (int i = 0; i < courseGrades.count; i++) {
//            CourseGradeModel *grade = courseGrades[i];
//            
//        }
//
//    } else {
//        cell.updateIcon.hidden = YES;
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedRow = indexPath.row;
    
    CourseGeneralModel *model = self.courses[indexPath.row];

    self.courseName.text = model.courseGeneralName;
    
    [self.collectionView reloadData];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray *courseGrades =  [self getDetailCourseWithSelectedRow:self.selectedRow];
    return courseGrades.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"DetailCourseCVCell";
    
    DetailCourseCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSArray *courseGrades =  [self getDetailCourseWithSelectedRow:self.selectedRow];

    CourseGradeModel *grade = courseGrades[indexPath.row];
    
    cell.courseLevel.text = grade.courseGrade;
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCourseCVCell *cell = (DetailCourseCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.updateIcon.hidden = YES;
    
    NSArray *courseGrades = [self getDetailCourseWithSelectedRow:self.selectedRow];

    CourseGradeModel *grade = courseGrades[indexPath.row];
    
    NSString *courseID = grade.courseID;
    
    NSString *courseGrade =  grade.courseGrade;
    
    NSString *courseName = self.courseName.text;
    
    if (![courseID isEqualToString:USERCOURSE]) {
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        [[SDImageCache sharedImageCache] clearMemory];//可不写
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:courseID forKey:UDCOURSEID];
    [userDefaults synchronize];
    
    CourseModel *course = [ArchiveHelper unarchiveModelWithKey:@"course" docePath:@"course"];
    course.course = courseName;
    course.courseID = courseID;
    course.courseGrade = courseGrade;
    [ArchiveHelper archiveModel:course forKey:@"course" docePath:@"course"];
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"renewVC" object:nil];

    [self saveUserCourseWithID:courseID];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width * 0.45, 94);
    
}

//设置每个item cell spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 16;
}

//设置每个item line spaceing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 20;
}


@end
