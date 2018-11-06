//
//  BannerPageView.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/19.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BannerPageView.h"
#import "BannerCVCell.h"

@interface BannerPageView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *images;              // 图片数组
@property (assign, nonatomic) NSInteger imageCount;         // 图片数量
@property (strong, nonatomic) NSMutableArray *cellData;     // 模型数组
// 模型数组开 100 组, 每组 n 张图片id, NSInteger 8 字节, 总大小 800n 个字节
// collectionView 停留在第 50 组模型那, 每次动画停止, 手动设置回第 50 组

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSLock *mLock;

@end

@implementation BannerPageView

static NSString *CollectionCellID = @"BannerCVCell";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.collectionView.frame = self.bounds;
}

-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    // 初始化 collectionView
    CGSize size = CGSizeMake(ScreenWidth-10, self.frame.size.height-10);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, self.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[BannerCVCell class] forCellWithReuseIdentifier:CollectionCellID];
    [self addSubview:self.collectionView];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
    self.pageControl.tag = 100;
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    [self bringSubviewToFront:self.pageControl];
    
    self.mLock = [[NSLock alloc] init];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BannerCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellID forIndexPath:indexPath];
    NSInteger index = [_cellData[indexPath.row] integerValue];
    cell.imagePath = _images[index];
    cell.index = index;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth-10, self.frame.size.height-10);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 动画停止, 重新定位到第 50 组模型
    int inc = ((int)(scrollView.contentOffset.x / scrollView.frame.size.width)) % _imageCount;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 * _imageCount + inc inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置 PageControl
    self.pageControl.currentPage = inc;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BannerCVCell *cell = (BannerCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(didClickImageAtIndex:scrollView:)]) {
        [self.delegate didClickImageAtIndex:cell.index scrollView:self];
    }
}

- (void)setDuringTime:(NSTimeInterval)duringTime {
    _duringTime = duringTime;
    if (duringTime < 0.001) {
        return ;
    }
    [self closeTimer];
    [self openTimer];
}

- (void)images:(NSArray *)images {
    [self.mLock lock];
    [self closeTimer];
    
    _images = images;
    _imageCount = images.count;
    
    // 生成数据源
    self.cellData = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        for (int j=0; j<_imageCount; j++) {
            [self.cellData addObject:@(j)];
        }
    }
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 * _imageCount inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置 PageControl
    self.pageControl.hidden = _imageCount > 1 ? NO : YES;
    self.pageControl.numberOfPages = _imageCount;
    self.pageControl.currentPage = 0;
    
    [self openTimer];
    [self.mLock unlock];
}

- (void)closeTimer {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)openTimer {
    if (_duringTime > 0.8) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_duringTime target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}

- (void)onTimer {
    if (self.cellData.count > 0) {
        NSArray *array = [self.collectionView indexPathsForVisibleItems];
        if (array.count == 0) return ;
        
        NSIndexPath *indexPath = array[0];
        NSInteger row = indexPath.row;
        
        if (row % _imageCount == 0) {
            row = 50 * _imageCount;         // 重新定位
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        self.pageControl.currentPage = (row + 1) % _imageCount;
    }
}

@end
