//
//  CPListViewController.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/18.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CPListViewController.h"

#import "CPListCollectionReusableView.h"
#import "CPListCollectionView.h"

#import "PackageDetailViewController.h"
#import "CardViewController.h"

#import "CardPackageViewController.h"

#import "CardPackageAPI.h"
#import "CardPackageModel.h"
#import "CPStudyRecordModel.h"

#import "ArchiveHelper.h"

@interface CPListViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet CPListCollectionView *collectionView;

/*  */
@property (strong, nonatomic) NSArray *cpLists;

/*  */
@property (strong, nonatomic) CPStudyRecordModel *studyRecord;

/*  */
@property (strong, nonatomic) CardPackageModel *recordCP;

@end

@implementation CPListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    UIColor *titleColor;
    UIColor *navColor;
    
    if (self.hideTab) {
        titleColor = [UIColor blackColor];
        navColor = [UIColor whiteColor];
    } else {
        titleColor = [UIColor whiteColor];
        navColor = [UIColor clearColor];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:titleColor}];
    [self setBackButton:NO isBlackColor:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:navColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.tabBarController.tabBar.hidden = self.hideTab;
}

#pragma mark - UI
-(void)updateUI{
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(ScreenWidth * 0.946, 185);
//    layout.sectionInset = UIEdgeInsetsMake(10, 0, 15, 0);
//    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 134);
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
//    self.collectionView.collectionViewLayout = layout;
    
    if (self.hideTab) {
        self.backgroundImage.hidden = YES;
    } else {
        self.backgroundImage.hidden = NO;
    }
    
    __weak CPListViewController *weakSelf = self;
    
    self.collectionView.didSelectItemAtIndexPath = ^(UICollectionView *collectionView, NSIndexPath *indexPath, CardPackageModel *cp) {
        
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
    
    self.collectionView.lastCardButtonClickForRecordCp = ^(UIButton *button) {
        
        UIStoryboard *cardPackage = [UIStoryboard storyboardWithName:@"Study" bundle:[NSBundle mainBundle]];

        CardViewController *cardVC = [cardPackage instantiateViewControllerWithIdentifier:@"CardViewController"];

        cardVC.cp = weakSelf.studyRecord.cp;

        cardVC.lastCardRecord = weakSelf.studyRecord.cardID;

        [weakSelf.navigationController pushViewController:cardVC animated:YES];
        
    };
    
}

#pragma mark - Data
-(void)loadData{
    
    if (!self.hideTab) {
        self.studyRecord = [ArchiveHelper unarchiveListWithKey:@"CPStudyRecordModel" docePath:@"CPStudyRecordModel"].lastObject;
    }
    
    [CardPackageAPI fetchCPTotalListWithUID:USERUID courseID:USERCOURSE type:@"1" callback:^(APIReturnState state, id data, NSString *message) {
        
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSArray *list = dict[LIST];
            
            [self saveToCardPackageModel:list];
            
            self.collectionView.cpLists = self.cpLists;
            self.collectionView.recordCP = self.studyRecord.cp;
            [self.collectionView reloadData];
            
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
    
    [self updateUI];

}

-(void)saveToCardPackageModel:(NSArray *)list{
    
    NSMutableArray *cardPackageList = [NSMutableArray array];
    
    for (int i = 0; i < list.count; i++) {
        NSDictionary *dict = list[i];
        
        CardPackageModel *model = [[CardPackageModel alloc] initWithDict:dict];
        
        [cardPackageList addObject:model];
    
    }
    
    self.cpLists = [cardPackageList copy];
    
}



@end
