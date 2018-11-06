//
//  HomeCourseCollectionView.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "HomeCourseCollectionView.h"
#import "HomeCourseCVCell.h"
#import "VideoCourseModel.h"

static NSString * const cellID = @"HomeCourseCVCell";

@interface HomeCourseCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation HomeCourseCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicSetting];
    }
    
    return self;
}

//- (void)setFrame:(CGRect)frame {
//    self.frame = frame;
//
//    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
//    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//
//    flow.minimumLineSpacing = 0;
//    flow.minimumInteritemSpacing = 0;
//
//    flow.itemSize = CGSizeMake(ScreenWidth-30, 200-30);
//    self.collectionViewLayout = flow;
//}

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
    self.alwaysBounceHorizontal = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    [self registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
//    self.collectionViewLayout = layout;
//    self.itemWidth = ScreenWidth * 0.346;
//    self.itemHeight = self.itemWidth * 1.3;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.courseLists.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCourseCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    VideoCourseModel *model = self.courseLists[indexPath.row];
    
    [cell configureCellForIndex:indexPath withModel:model];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoCourseModel *model = self.courseLists[indexPath.row];
    
    self.didSelectItemAtIndexPath(collectionView, indexPath, model);
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth, 120);
}

////设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    CGFloat size = (collectionView.frame.size.width - self.itemWidth * 2) / 3;
//    return UIEdgeInsetsMake(10, size,10, size);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    //    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.269) * 3) / 4;
//
//    return 10;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    //    CGFloat size = (collectionView.frame.size.width - (collectionView.frame.size.width * 0.269) * 3) / 4;
//
//    return 20;
//}

@end
