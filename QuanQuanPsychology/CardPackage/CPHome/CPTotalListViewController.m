//
//  CPTotalListViewController.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/19.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CPTotalListViewController.h"
#import "CPBasicListCollectionView.h"
#import "PackageDetailViewController.h"

#import "CardPackageAPI.h"
#import "CardPackageModel.h"

@interface CPTotalListViewController ()

@property (strong, nonatomic) CPBasicListCollectionView *collectionView;

@property (strong, nonatomic) NSArray *cpList;


@end

@implementation CPTotalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    
    self.title = @"全部卡包";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    self.collectionView = [[CPBasicListCollectionView alloc] initWithFrame:CGRectMake(0, NavHeight + StatusHeight, ScreenWidth, ScreenHeight - NavHeight - StatusHeight) collectionViewLayout:layout];
    
    __weak CPTotalListViewController *weakSelf = self;
    
    self.collectionView.didSelectItemAtIndexPath = ^(UICollectionView *collectionView, NSIndexPath *indexPath ,CardPackageModel *cp) {
        
        UIStoryboard *cardPackage = [UIStoryboard storyboardWithName:@"CardPackage" bundle:[NSBundle mainBundle]];
        
        PackageDetailViewController *detailVC = [cardPackage instantiateViewControllerWithIdentifier:@"PackageDetailViewController"];
        
        detailVC.cp = cp;
        
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
        
    };
    
    [self.view addSubview:self.collectionView];
    
}

-(void)loadData{
    
//    [CardPackageAPI fetchCardPackageWithUID:@"" courseID:USERCOURSE callback:^(APIReturnState state, id data, NSString *message) {
//        if (state == API_SUCCESS) {
//            NSDictionary *dict = (NSDictionary *)data;
//            NSArray *list = dict[LIST];
//            
//            [self saveToCardPackageModel:list];
//            
//            [self.collectionView reloadData];
//            
//        } else {
//            [self showHUDWithMode:MBProgressHUDModeText message:message];
//            [self hideHUDAfter:1];
//        }
//        
//    }];
}

-(void)saveToCardPackageModel:(NSArray *)list{
    
    NSMutableArray *cardPackageList = [NSMutableArray array];
    
    for (int i = 0; i < list.count; i++) {
        NSDictionary *dict = list[i];
        
        CardPackageModel *model = [[CardPackageModel alloc] initWithDict:dict];
        
        [cardPackageList addObject:model];
    }
    
    self.collectionView.cpLists = [cardPackageList copy];
    
}

@end
