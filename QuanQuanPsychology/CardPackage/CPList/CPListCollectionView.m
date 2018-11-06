//
//  CPListCollectionView.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CPListCollectionView.h"
#import "CPListCollectionReusableView.h"

#import "CPListCVCell.h"

static NSString * const cellID = @"CPListCVCell";
static NSString * const headerViewID = @"CPListCollectionReusableView";
static NSInteger const headerHeight = 110;

@interface CPListCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

@implementation CPListCollectionView

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
    
    self.backgroundColor = [UIColor clearColor];
    [self registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID];
}

-(void)setRecordCP:(CardPackageModel *)recordCP{
    _recordCP = recordCP;
    if (recordCP != nil) {        
        [self registerNib:[UINib nibWithNibName:headerViewID bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.cpLists.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CPListCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    CardPackageModel *model = self.cpLists[indexPath.row];
    
    [cell configureCellForIndex:indexPath withModel:model];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CardPackageModel *model = self.cpLists[indexPath.row];
    
    self.didSelectItemAtIndexPath(collectionView, indexPath, model);
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.recordCP == nil) {
        
        return nil;
    } else {
        
        CPListCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        
        [headerView configureReusableViewWithModel:self.recordCP];
        
        headerView.lastCardButtonClick = ^(UIButton *button) {
            
            self.lastCardButtonClickForRecordCp(button);
            
        };
        
        return headerView;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.recordCP != nil) {
        return CGSizeMake(self.frame.size.width, headerHeight);
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(collectionView.frame.size.width * 0.946, 120);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 0,15, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.269) * 3) / 4;
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.269) * 3) / 4;
    
    return 10;
}


@end
