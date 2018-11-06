//
//  CPBasicListCollectionView.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/19.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CPBasicListCollectionView.h"
#import "CPBaiscCVCell.h"

static NSString * const cellID = @"CPBaiscCVCell";
static NSString * const headerViewID = @"CPBasicListHeaderView";
static NSInteger const headerHeight = 40;


@interface CPBasicListCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

/*  */
@property (assign, nonatomic) NSInteger itemWidth;

@property (assign, nonatomic) NSInteger itemHeight;


@end

@implementation CPBasicListCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicSetting];
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self basicSetting];
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        [self basicSetting];
    }
    
    return self;
}

-(void)basicSetting{
    self.delegate = self;
    self.dataSource = self;
    
    self.backgroundColor = [UIColor whiteColor];
    [self registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID];
    
    self.itemWidth = (ScreenWidth - 45)/2.0;
    self.itemHeight = self.itemWidth * 110.0/165.0;
}

-(void)setHasHeaderView:(BOOL)hasHeaderView{
    _hasHeaderView = hasHeaderView;
    
    if (hasHeaderView) {
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.cpLists.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CPBaiscCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    CardPackageModel *model = self.cpLists[indexPath.row];
    
    [cell configureCellForIndex:indexPath withModel:model];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CardPackageModel *model = self.cpLists[indexPath.row];
    
    self.didSelectItemAtIndexPath(collectionView, indexPath, model);
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.hasHeaderView) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor clearColor];
        
        UIView *color = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth, headerHeight)];
        color.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:color];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, (headerHeight-14)/2, 15, 14)];
        img.image = [UIImage imageNamed:@"zuanshi"];
        [color addSubview:img];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 60, headerHeight)];
        label.text = @"精选卡包";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor customisDarkGreyColor];
//        if (@available(iOS 8.2, *)) {
//            label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
//        } else {
//        }
        label.font = [UIFont systemFontOfSize:13];
        [color addSubview:label];
        
//        UIView *left = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame)-45, headerHeight/2-0.5, 35, 1)];
//        left.backgroundColor = [UIColor colorwithHexString:@"#979797"];
//        [headerView addSubview:left];
//        
//        UIView *right = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, headerHeight/2-0.5, 35, 1)];
//        right.backgroundColor = [UIColor colorwithHexString:@"#979797"];
//        [headerView addSubview:right];
        
       UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-115, 0, 100, headerHeight)];
        [more setTitle:@"更多" forState:UIControlStateNormal];
        [more setTitleColor:[UIColor customisDarkGreyColor] forState:UIControlStateNormal];
        more.titleLabel.font = [UIFont systemFontOfSize:10];
        more.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        more.titleLabel.textAlignment = NSTextAlignmentRight;
        more.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        [more setImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
        more.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
        [more addTarget:self action:@selector(moreCourse:) forControlEvents:UIControlEventTouchUpInside];
        [color addSubview:more];
        
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.hasHeaderView) {
        return CGSizeMake(self.frame.size.width, headerHeight);
    }
    
    return CGSizeZero;
}

#pragma mark - button action
-(void)moreCourse:(UIButton *)button{
    self.didClickMoreCPButton(button);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.itemWidth, self.itemHeight);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat size = (collectionView.frame.size.width - self.itemWidth * 2) / 3;
    return UIEdgeInsetsMake(0, size,0, size);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
////    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.269) * 3) / 4;
//
//    return 10;
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
////    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.269) * 3) / 4;
//
//    return 20;
//}

@end
