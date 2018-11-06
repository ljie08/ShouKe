//
//  UserCPViewController.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "UserCPViewController.h"

#import "CardPackageViewController.h"
#import "CardPackageModel.h"
#import "CPListCollectionView.h"
#import "BlankView.h"
#import "CardPackageAPI.h"
#import "ArchiveHelper.h"

@interface UserCPViewController ()

/*  */
@property (strong, nonatomic) CPListCollectionView *collectionView;

/*  */
@property (strong, nonatomic) NSArray *cpLists;

@property (strong, nonatomic) BlankView *blankView;


@end

@implementation UserCPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self loadData];
    
    [self.navigationController.navigationBar setBackgroundImage:[QuanUtils imageWithColor:[UIColor customisMainColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    /* 导航栏字体颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setBackButton:YES isBlackColor:NO];
}

-(void)initBlankView{
    self.blankView = [[BlankView alloc] initWithFrame:self.collectionView.frame];
    [self.blankView updateImage:[UIImage imageNamed:@"没有待激活卡包"]
                    imageCenter:CGPointMake(self.view.center.x, self.view.center.y - NavHeight - StatusHeight - 41)
                        content:@"暂时没有待激活卡包～"];
    [self.view addSubview:self.blankView];
}

-(void)initUI{
    
    self.title = @"我的卡包";
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 117, ScreenWidth, 38)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [whiteView shadowOffset:CGSizeMake(0, 1) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:3 shadowOpacity:1];
    [self.view addSubview:whiteView];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    bgview.backgroundColor = [UIColor customisMainColor];
    [self.view addSubview:bgview];
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-76)/2, 68, 76, 76)];
    
    UserModel *user = [ArchiveHelper unarchiveModelWithKey:@"userInfo" docePath:@"userInfo"];
    
    [header sd_setImageWithURL:[QuanUtils fullImagePath:user.portrait] placeholderImage:[UIImage imageNamed:@"default_avater"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [QuanUtils clipViewCornerRadius:38 withImage:header.image andImageView:header];
    }];
    [self.view addSubview:header];

    __weak UserCPViewController *weakSelf = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[CPListCollectionView alloc] initWithFrame:CGRectMake(0, 155, ScreenWidth, ScreenHeight - NavHeight - StatusHeight) collectionViewLayout:layout];
    
    
    self.collectionView.didSelectItemAtIndexPath = ^(UICollectionView *collectionView, NSIndexPath *indexPath, CardPackageModel *cp) {
        
        UIStoryboard *cardPackage = [UIStoryboard storyboardWithName:@"CardPackage" bundle:[NSBundle mainBundle]];
        
        CardPackageViewController *cpVC = [cardPackage instantiateViewControllerWithIdentifier:@"CardPackageViewController"];
        
        cpVC.cp = cp;
        
        [weakSelf.navigationController pushViewController:cpVC animated:YES
         ];
    };
    
    [self.view addSubview:self.collectionView];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    
}

#pragma mark - Data
-(void)loadData{
    
    [CardPackageAPI fetchCPTotalListWithUID:USERUID courseID:USERCOURSE type:@"2" callback:^(APIReturnState state, id data, NSString *message) {
        
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSArray *list = dict[LIST];
            
            [self saveToCardPackageModel:list];
            
            self.collectionView.cpLists = self.cpLists;
            [self.collectionView reloadData];
            
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
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
