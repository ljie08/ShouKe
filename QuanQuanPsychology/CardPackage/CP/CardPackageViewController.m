//
//  CardPackageViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardPackageViewController.h"
#import "CardViewController.h"
#import "CPCollectionView.h"

#import "CardPackageModel.h"

#import "BlankView.h"
#import "CardPackageAPI.h"

@interface CardPackageViewController ()

@property (weak, nonatomic) IBOutlet CPCollectionView *collectionView;

@property (strong, nonatomic) NSArray *cardPackageList;

@property (strong, nonatomic) BlankView *blankView;

@end

@implementation CardPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self loadData];

}

-(void)initBlankView{
    self.blankView = [[BlankView alloc] initWithFrame:self.collectionView.frame];
    [self.blankView updateImage:[UIImage imageNamed:@"没有待激活卡包"]
                    imageCenter:CGPointMake(self.view.center.x, self.view.center.y - NavHeight - StatusHeight - 41)
                        content:@"暂时没有待激活卡包～"];
    [self.view addSubview:self.blankView];
}

-(void)updateUI{
    
    __weak CardPackageViewController *weakSelf = self;
    
    self.collectionView.didSelectItemAtIndexPath = ^(UICollectionView *collectionView, NSIndexPath *indexPath, CardPackageModel *cp) {
        
        UIStoryboard *study = [UIStoryboard storyboardWithName:@"Study" bundle:[NSBundle mainBundle]];
        
        CardViewController *card = [study instantiateViewControllerWithIdentifier:@"CardViewController"];
        
        card.cp = cp;
        
        [weakSelf.navigationController pushViewController:card animated:YES];
    };
    
}

#pragma mark - Data
-(void)loadData{
    
    [CardPackageAPI fetchCardPackageWithUID:USERUID cpID:self.cp.cpID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSArray *list = dict[LIST];
            
            [self saveToCardPackageModel:list];
            self.collectionView.cpLists = self.cardPackageList;
            
            [self.collectionView reloadData];
            
            if (self.blankView) {
                [self.blankView removeFromSuperview];
            }
        } else if (state == API_NODATA) {
            [self initBlankView];
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
    
    self.cardPackageList = [cardPackageList copy];
}

@end
