//
//  PackageDetailViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "PackageDetailViewController.h"
#import "CardViewController.h"
#import "CardPackageViewController.h"
#import "PackageDetailCell.h"

#import "QuanIAPManager.h"
#import "CardPackageAPI.h"
#import "CardPackagePayAPI.h"

#import "ShareView.h"

#import "CardPackageDetailModel.h"
#import "CardPackageModel.h"

@interface PackageDetailViewController ()<UITableViewDelegate,UITableViewDataSource,IAPRequestResultsDelegate,SharePlatformViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *cardPackageImage;

@property (weak, nonatomic) IBOutlet UILabel *cardPackageCourseName;

@property (weak, nonatomic) IBOutlet UILabel *cardPackageCourseLevel;

@property (weak, nonatomic) IBOutlet UIView *cardPackageDetailView;

@property (weak, nonatomic) IBOutlet UITableView *cardPackageTableView;

@property (strong, nonatomic) MainGreenButton *free;

@property (strong, nonatomic) MainGreenButton *paid;

@property (strong, nonatomic) CardPackageDetailModel *cpDetailModel;


@property (strong, nonatomic) NSArray *items;

@property (strong, nonatomic) NSArray *contents;

/* ViewConstraints */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseT;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpViewH;

@end

@implementation PackageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchCardPackageDetail];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.courseT.constant = ScreenHeight * 0.048;
    
    if (IS_IPHONE4S) {
        self.cpViewH.constant = ScreenHeight * 0.5;
    } else {
        self.cpViewH.constant = ScreenHeight * 0.42;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)becomeActive{
    if (self.cpDetailModel.cpType == CP_Share) {
        [self fetchCardPackageDetail];
    }
}

#pragma mark - Data
-(void)fetchCardPackageDetail{
    
    
    
    [CardPackageAPI fetchCardPackageDetailWithUID:USERUID courseID:USERCOURSE packageID:self.cp.cpID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSDictionary *detail = dict[@"cardPackage"];
            
            self.cpDetailModel = [self saveToCardPackageDetailModel:detail];
            
            [self initData];
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
    
}

-(CardPackageDetailModel *)saveToCardPackageDetailModel:(NSDictionary *)dict{
    
    CardPackageDetailModel *model = [[CardPackageDetailModel alloc] initWithDict:dict];
    
    return model;
}

-(void)initData{
    
    [self updateUI];
    
    self.items = @[@"教材：",@"卡包介绍：",@"考题年份：",@"针对考生："];
    self.contents = @[self.cpDetailModel.subjectName,self.cpDetailModel.cpDescription,self.cpDetailModel.examQuesTime,self.cpDetailModel.targetPerson];

    
    [self.cardPackageImage sd_setImageWithURL:[QuanUtils fullImagePath:self.cpDetailModel.cpBackgroundPic] placeholderImage:[UIImage imageNamed:@"default_cp_detail"]];
    
    self.cardPackageCourseName.text = self.cpDetailModel.courseName;
    self.cardPackageCourseLevel.text = self.cpDetailModel.courseLevel;
    
    [self.cardPackageTableView reloadData];

}

#pragma mark - UI
-(void)updateUI{
    
    self.title = self.cpDetailModel.cpTitle;
    
    [self.cardPackageImage shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.12 shadowRadius:14 shadowOpacity:1];
    
    [self.cardPackageDetailView shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.12 shadowRadius:14 shadowOpacity:1];
    
    self.cardPackageDetailView.layer.cornerRadius = 6;
    
    if (self.cpDetailModel.ownCardPackage) {
        [self initButtonWithTitle:@"开始学习" forType:0];
    } else {
        
        switch (self.cpDetailModel.cpType) {
            case CP_Free:
                [self initButtonWithTitle:@"免费获取" forType:CP_Free];
                break;
                
            case CP_Paid:
                [self initButtonWithTitle:[NSString stringWithFormat:@"¥ %@",self.cpDetailModel.cpAmount] forType:CP_Paid];
                break;
                
            case CP_Share:
                [self initButtonWithTitle:@"分享获取卡包" forType:CP_Share];
                break;
                
            
        }
        
        
        
    }

}

-(void)initButtonWithTitle:(NSString *)title forType:(CardPackageType)type{
    
    CGFloat x = 22.5;
    CGFloat width = ScreenWidth - 15 * 2 * 2 - x * 2;
    CGFloat height = width / 6;
    CGFloat y = self.cpViewH.constant -  ScreenHeight * 0.54 * 0.11 - height;
    
    MainGreenButton *first = [[MainGreenButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [first setTitle:title forState:UIControlStateNormal];
    [first addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cardPackageDetailView addSubview:first];
    
//    if (type == CP_Paid) {
//        width = width / 2 - 15;
//    }
//
//    CGFloat paidX = (ScreenWidth - 15 * 2 * 2) - x  - width;
    
//    if (type == CP_Paid) {
//
//        UIButton *try = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
//        [try setTitle:@"试看" forState:UIControlStateNormal];
//        [try setTitleColor:[UIColor customisDarkGreyColor] forState:UIControlStateNormal];
//        [try addTarget:self action:@selector(try:) forControlEvents:UIControlEventTouchUpInside];
//        try.layer.borderColor = [UIColor blackColor].CGColor;
//        try.layer.borderWidth = 1;
//        try.layer.cornerRadius = 5;
//        [self.cardPackageDetailView addSubview:try];
//
//
//        MainGreenButton *pay = [[MainGreenButton alloc] initWithFrame:CGRectMake(paidX, y, width, height)];
//        [pay setTitle:title forState:UIControlStateNormal];
//        [pay addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.cardPackageDetailView addSubview:pay];
//    } else {
//
//
//    }
}


#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.items.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"PackageDetailCell";
    
    PackageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [cell setItem:self.items[indexPath.section]
          content:self.contents[indexPath.section]];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>


#pragma mark - Button Action
-(void)beginStudy:(MainGreenButton *)button{
    
    UIStoryboard *cardPackage = [UIStoryboard storyboardWithName:@"CardPackage" bundle:[NSBundle mainBundle]];

    CardPackageViewController *cpVC = [cardPackage instantiateViewControllerWithIdentifier:@"CardPackageViewController"];
    
    cpVC.cp = self.cp;
    
    [self.navigationController pushViewController:cpVC animated:YES];
    
}

//-(void)try:(UIButton *)button{
//    
//    UIStoryboard *study = [UIStoryboard storyboardWithName:@"Study" bundle:[NSBundle mainBundle]];
//    
//    CardViewController *card = [study instantiateViewControllerWithIdentifier:@"CardViewController"];
//    
//    card.cpDetailModel = self.cpDetailModel;
//    
//    [self.navigationController pushViewController:card animated:YES];
//    
//}

-(void)btnAction:(MainGreenButton *)button{
    
    if (self.cpDetailModel.ownCardPackage) {
        [self beginStudy:button];
    } else {
        [self preOrderCardPackage];
        
        if (self.cpDetailModel.cpType == CP_Share){
            
            ShareView *shareView = [[ShareView alloc] initWithFrame:self.view.bounds];
            
            
            [self.navigationController.view addSubview:shareView];
            
            UIImage *image = [UIImage imageNamed:@"圈圈icon"];
            
            NSString *path = [SEVER_QUAN_API stringByAppendingString:@"hcxl/sharePackage/detail.html"];

            NSString *sharePath = [path stringByAppendingString:[NSString stringWithFormat:@"?cp_id=%@&uid=%@&exam_id=%@",self.cpDetailModel.cpID,USERUID,USERCOURSE]];

            NSString *courseName = @"";
            
            NSString *text = [NSString stringWithFormat:@"背起卡包 走进心理世界【%@】卡包模式",courseName];
            
            shareView.platformView.shareTitle = text;
            shareView.platformView.shareSubTitle = @"收集了最全面的心理知识";
            shareView.platformView.shareIcon = image;
            shareView.platformView.shareURL = sharePath;
            shareView.platformView.currentVC = self;
            shareView.platformView.delegate = self;
            
        }
    }
    
    
}


-(void)preOrderCardPackage{
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在处理"];
    
    [CardPackagePayAPI preOrderWithUID:USERUID packageID:self.cpDetailModel.cpID callback:^(APIReturnState state, id data, NSString *message) {
        
        if (state == API_SUCCESS) {
            
            if (self.cpDetailModel.cpType == CP_Free) {
                [self hideHUD];

                [self fetchCardPackageDetail];
            } else if (self.cpDetailModel.cpType == CP_Paid){
                
                [self updateHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在处理"];

                [QuanIAPManager sharedInstance].delegate = self;
                
                [[QuanIAPManager sharedInstance] requestProductWithId:self.cpDetailModel.cpProductID andOrderID:self.cpDetailModel.cpID];
            }
            
        } else {
            [self updateHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

#pragma mark - <SharePlatformViewDelegate>
-(void)shareSuccess{
    
    [self fetchCardPackageDetail];
}

#pragma mark - <IApRequestResultsDelegate>
- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error {
    
    NSString *message = @"";
    
    switch (errorCode) {
        case IAP_FILEDCOED_APPLECODE:
            NSLog(@"用户禁止应用内付费购买:%@",error);
            message = error;
            break;
            
        case IAP_FILEDCOED_NORIGHT:
            NSLog(@"用户禁止应用内付费购买");
            message = @"您的设备没有开启内置购买";
            break;
            
        case IAP_FILEDCOED_EMPTYGOODS:
            NSLog(@"商品为空");
            message = @"商品为空";
            break;
            
        case IAP_FILEDCOED_CANNOTGETINFORMATION:
            NSLog(@"无法获取产品信息，请重试");
            message = @"无法获取产品信息，请重试";
            break;
            
        case IAP_FILEDCOED_BUYFILED:
            NSLog(@"购买失败，请重试");
            message = @"购买失败，请重试";
            break;
            
        case IAP_FILEDCOED_USERCANCEL:
            NSLog(@"用户取消交易");
            message = @"您已取消交易";
            break;
            
        default:
            break;
    }
    
    [self updateHUDWithMode:MBProgressHUDModeText message:message];
    
    [self hideHUDAfter:1];

}

-(void)transactionSuccess{
    
    [CardPackagePayAPI payOrderWithUID:USERUID packageID:self.cpDetailModel.cpID callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            [self hideHUDAfter:1];
            
            [self.paid removeFromSuperview];
            [self.free removeFromSuperview];
            [self fetchCardPackageDetail];
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

@end
