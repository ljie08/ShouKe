//
//  CardOverviewViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/22.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardOverviewViewController.h"
#import "CardViewController.h"

#import "CardOverviewCVCell.h"
#import "CardOverviewImageCVCell.h"
#import "CardPackageOverviewCVC.h"
#import "CardOverviewFooterView.h"

//#import "SSCardTransitionAnimation.h"

//#import "RuleView.h"

static NSString * const cellID = @"CardOverviewCVCell";
static NSString * const imageCellID = @"CardOverviewImageCVCell";
static NSString * const cpCellID = @"CardPackageOverviewCVC";

@interface CardOverviewViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *basicView;/* 知识卡选择器底图 */

@property (weak, nonatomic) IBOutlet UIButton *starSelection;

@property (weak, nonatomic) IBOutlet UISwitch *isFinished;/* 未完成学习 */

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;/* 知识卡 */

//@property (strong, nonatomic) RuleView *ruleView;

@property (strong, nonatomic) UIView *shadowView;/* 选星级view */

@property (strong, nonatomic) NSMutableArray *cards;

@property (strong, nonatomic) NSString *currentStar;


@end

@implementation CardOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cards = [self.allCards mutableCopy];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)updateUI{
    
    self.basicView.layer.shadowOffset = CGSizeMake(0, 1);
    self.basicView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.12].CGColor;
    self.basicView.layer.shadowRadius = 0;
    self.basicView.layer.shadowOpacity = 1;
    
    self.starSelection.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.starSelection.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.isFinished.on = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerNib:[UINib nibWithNibName:imageCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:imageCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:cpCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cpCellID];
    
}

-(void)initRuleView{
    
//    self.ruleView = [[RuleView alloc] initWithFrame:self.view.bounds];
//    self.ruleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.ruleView];
//
//    [self.ruleView updateRuleImage:[UIImage imageNamed:@"知识卡规则说明"]];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeRules)];
//    [self.ruleView addGestureRecognizer:tap];
    
}

-(void)initStarView{
    
    self.shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:self.shadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadowView)];
    [self.shadowView addGestureRecognizer:tap];
    
    CGFloat x = ScreenWidth * 0.08;
    CGFloat y = ScreenHeight * 0.159;
    CGFloat width = ScreenWidth * 0.4;
    CGFloat height = ScreenHeight * 0.273;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    background.image = [UIImage imageNamed:@"star背景"];
    background.userInteractionEnabled = YES;
    [self.shadowView addSubview:background];
    
    CGFloat top = height * 0.145;
    CGFloat btnW = width * 0.7;
    CGFloat btnH = btnW / 7;
    CGFloat btnX = (width - btnW) / 2;
    for (int i = 0; i < 6; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(btnX, top + i * (btnH +10), btnW, btnH)];
        button.tag = 100 + i;
        
        switch (i) {
            case 0:
                [button setTitle:@"全部知识卡" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor customisDarkGreyColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                break;
                
            case 1:
                [button setImage:[UIImage imageNamed:@"star5"] forState:UIControlStateNormal];
                break;
            
            case 2:
                [button setImage:[UIImage imageNamed:@"star4"] forState:UIControlStateNormal];
                break;
                
            case 3:
                [button setImage:[UIImage imageNamed:@"star3"] forState:UIControlStateNormal];
                break;
                
            case 4:
                [button setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
                break;
                
            case 5:
                [button setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
                break;
        }
        
        [button addTarget:self action:@selector(chooseStarForCards:) forControlEvents:UIControlEventTouchUpInside];
        
        [background addSubview:button];
        
    }
    

}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cards.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CardModel *card = self.cards[indexPath.row];
    
    if (![NSString stringIsNull:card.cardPic]) {
        
        CardOverviewImageCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellID forIndexPath:indexPath];
        
        [cell setValueWithModel:card];
        
        return cell;

    } else {
        CardOverviewCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        [cell setValueWithModel:card];

        return cell;
    }
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cardIsComplete = %@",@"0"];
    NSArray *unfinished = [self.allCards filteredArrayUsingPredicate:predicate];
    
    CardOverviewFooterView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CardOverviewFooterView" forIndexPath:indexPath];
    footerview.unfinishedNotice.text = [NSString stringWithFormat:@"本单元未完成知识卡%ld张",unfinished.count];
    
    return footerview;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CardModel *card = self.cards[indexPath.row];
    
    NSDictionary *dict = @{@"cardID":card.cardID};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JumpToSelectedCard" object:nil userInfo:dict];
    
    [self.navigationController popViewControllerAnimated:YES];


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width * 0.267, collectionView.frame.size.width * 0.267 * 1.3);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.267) * 3) / 4;
    return UIEdgeInsetsMake(size, size, size, size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.267) * 3) / 4;

    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.267) * 3) / 4;

    return size;
}

-(void)addCardViewShadow:(UIView *)view{
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowColor = [UIColor colorwithHexString:@"#c8c8c8"].CGColor;
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 1;
    view.layer.masksToBounds = NO;
}

#pragma mark - Actions
- (IBAction)showDifferentStar:(UIButton *)sender {
    [self initStarView];
}

-(void)chooseStarForCards:(UIButton *)button{
    
    NSInteger index = button.tag - 100;
    
    switch (index) {
        case 0:
            self.currentStar = @"0";
            [self.starSelection setTitle:@"全部知识卡" forState:UIControlStateNormal];
            [self.starSelection setTitleColor:[UIColor customisDarkGreyColor] forState:UIControlStateNormal];
            self.starSelection.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.starSelection setImage:nil forState:UIControlStateNormal];

            break;
            
        case 1:
            self.currentStar = @"5";
            [self.starSelection setImage:[UIImage imageNamed:@"star5"] forState:UIControlStateNormal];
            [self.starSelection setTitle:@"" forState:UIControlStateNormal];

            break;
            
        case 2:
            self.currentStar = @"4";
            [self.starSelection setImage:[UIImage imageNamed:@"star4"] forState:UIControlStateNormal];
            [self.starSelection setTitle:@"" forState:UIControlStateNormal];
            break;
            
        case 3:
            self.currentStar = @"3";
            [self.starSelection setImage:[UIImage imageNamed:@"star3"] forState:UIControlStateNormal];
            [self.starSelection setTitle:@"" forState:UIControlStateNormal];
            break;
            
        case 4:
            self.currentStar = @"2";
            [self.starSelection setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
            [self.starSelection setTitle:@"" forState:UIControlStateNormal];
            break;
            
        case 5:
            self.currentStar = @"1";
            [self.starSelection setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
            [self.starSelection setTitle:@"" forState:UIControlStateNormal];
            break;
    }
    
    if ([self.currentStar integerValue] == 0) {
        self.cards = [self.allCards mutableCopy];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cardStar = %@",self.currentStar];
        self.cards = [[self.allCards filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    

    
    [self.shadowView removeFromSuperview];
    [self.collectionView reloadData];
}

- (IBAction)studyStatus:(UISwitch *)sender {
    
    if (sender.isOn) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cardIsComplete = %@",@"0"];
        
        self.cards = [[self.cards filteredArrayUsingPredicate:predicate] mutableCopy];
    } else {
        
        if (self.currentStar) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cardStar = %@",self.currentStar];
            self.cards = [[self.cards filteredArrayUsingPredicate:predicate] mutableCopy];
        } else {
            self.cards = [self.allCards mutableCopy];
        }
    }
    
    [self.collectionView reloadData];
}

- (IBAction)showRules:(UIBarButtonItem *)sender {
    
    [self initRuleView];

}

-(void)removeRules{
//    [self.ruleView removeFromSuperview];
}

#pragma mark - Gesture
-(void)removeShadowView{
    [self.shadowView removeFromSuperview];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
