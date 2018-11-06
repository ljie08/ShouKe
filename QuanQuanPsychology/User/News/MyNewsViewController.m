//
//  MyNewsViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/25.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "MyNewsViewController.h"
#import "NewsDetailViewController.h"

#import "NewsNotificationAPI.h"

#import "BlankView.h"


@interface MyNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *newsList;

@property (strong, nonatomic) BlankView *blankView;


@end

@implementation MyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMessageReadTime];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self fetchNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
-(void)fetchNews{
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在加载"];
    
    [NewsNotificationAPI fetchMyNewsWithUID:USERUID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            [self hideHUD];
            NSDictionary *dict = (NSDictionary *)data;
            self.newsList = dict[LIST];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        } else if (state == API_NODATA){
            [self hideHUD];
            [self initBlankView];
            self.tableView.hidden = YES;
        } else {
            
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];

        }
    }];
}

-(void)setMessageReadTime{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *timeCode = [NSDate creatTimeCode];
    
    [userDefaults setObject:timeCode forKey:UDNEWSREADTIME];
    
    [userDefaults synchronize];
}

#pragma mark - UI
-(void)initBlankView{
    
    self.blankView = [[BlankView alloc] initWithFrame:self.view.bounds];
    [self.blankView updateImage:[UIImage imageNamed:@"blank"]
                    imageCenter:CGPointMake(self.view.center.x, self.view.center.y - 20)
                        content:@"最近没有新消息"];
    [self.view addSubview:self.blankView];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"MyNewsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.imageView.layer.cornerRadius = 5;
    
    cell.textLabel.text = [self.newsList[indexPath.row] valueForKey:@"head"];
    cell.detailTextLabel.text = [self.newsList[indexPath.row] valueForKey:@"content"];
    
    NSString *newsID = [NSString stringWithFormat:@"%@",[self.newsList[indexPath.row] valueForKey:@"id"]];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *newsIDs = [userDefaults valueForKey:@"newsIDs"];
    
    if ([newsIDs containsObject:newsID]) {
        cell.textLabel.textColor = [[UIColor colorwithHexString:@"#666666"] colorWithAlphaComponent:0.8];
        cell.detailTextLabel.textColor = [UIColor colorwithHexString:@"#999999"];
    } else {
        cell.textLabel.textColor = [UIColor customisDarkGreyColor];
        cell.detailTextLabel.textColor = [UIColor colorwithHexString:@"#666666"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *recordNews = [userDefaults valueForKey:@"newsIDs"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (recordNews.count != 0) {
        [array addObjectsFromArray:recordNews];
    }
    
    NSString *newsID = [NSString stringWithFormat:@"%@",[self.newsList[indexPath.row] valueForKey:@"id"]];
    
    if (![array containsObject:newsID]) {
        [array addObject:newsID];
    }
    
    NSArray *newRecord = [array copy];
    
    [userDefaults setObject:newRecord forKey:@"newsIDs"];
    
    [userDefaults synchronize];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    
    NewsDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
    
    detailVC.titleString = cell.textLabel.text;
    detailVC.contentString = cell.detailTextLabel.text;
    detailVC.timeString = [self.newsList[indexPath.row] valueForKey:CREATEDATE];
    detailVC.imagePath = [self.newsList[indexPath.row] valueForKey:PICPATH];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

@end
