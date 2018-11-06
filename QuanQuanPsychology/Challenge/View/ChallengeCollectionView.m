//
//  ChallengeCollectionView.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "ChallengeCollectionView.h"
#import "ChallengeLevelCVCell.h"

static NSString * const cellID = @"ChallengeLevelCVCell";


@interface ChallengeCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ChallengeCollectionView

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


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.challenges.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ChallengeLevelCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    ChallengeModel *model = self.challenges[indexPath.row];
    
    [cell configureCellWithModel:model forIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChallengeModel *model = self.challenges[indexPath.row];

    self.didSelectItemAtIndexPath(collectionView, indexPath, model);
    
}


#pragma mark - button action
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width * 0.155, collectionView.frame.size.width * 0.155);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.155) * 4) / 5 - 5;
    return UIEdgeInsetsMake(size, size,size, size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.155) * 4) / 5;

    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.155) * 4) / 5;
    
    return size;
}



@end
