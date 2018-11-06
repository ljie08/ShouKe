//
//  CollectionZoomFlowLayout.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/5.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "CollectionZoomFlowLayout.h"

#define SCREENWITH   [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@implementation CollectionZoomFlowLayout


-(id)init{
    self = [super init];
    if (self) {
        _move_x = 0.0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        self.minimumLineSpacing = 16.0;
//        self.sectionInset = UIEdgeInsetsMake(0,28, 0,28);
        
    }
    return self;
}

/**
 *  控制最后UICollectionView的最后去哪里，我们这里需要做的吸附效果的逻辑代码就需要在这里完成。
 *
 *  @param proposedContentOffset 原本UICollectionView停止滚动那一刻的位置
 *  @param velocity              滚动速度
 *
 *  @return
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    proposedContentOffset.y = 0.0;
    if (_isPagingEnabled) {
        proposedContentOffset.x = [self PageMove:proposedContentOffset];
    }else{
        proposedContentOffset.x = [self SMove:proposedContentOffset velocity:velocity];
    }
    return proposedContentOffset;
}


-(CGFloat)PageMove:(CGPoint)proposedContentOffset{
    CGFloat set_x =  proposedContentOffset.x;
    
    if (set_x > _move_x) {
        _move_x += SCREENWITH - self.minimumLineSpacing * 2;
    }else if(set_x < _move_x){
        _move_x -= SCREENWITH - self.minimumLineSpacing * 2;
    }
    set_x = _move_x;

    return set_x;
}

-(CGFloat)SMove:(CGPoint)proposedContentOffset velocity :(CGPoint)velocity{
    
    CGFloat offSetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = (CGFloat) (proposedContentOffset.x + (self.collectionView.bounds.size.width / 2.0));
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    
    UICollectionViewLayoutAttributes *currentAttributes;
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array)
    {
        if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            CGFloat itemHorizontalCenter = layoutAttributes.center.x;
            if (ABS(itemHorizontalCenter - horizontalCenter) <  ABS(offSetAdjustment))
            {
                currentAttributes   = layoutAttributes;
                offSetAdjustment    = itemHorizontalCenter - horizontalCenter;
            }
        }
    }
    
    CGFloat nextOffset          = proposedContentOffset.x + offSetAdjustment;
    
    proposedContentOffset.x     = nextOffset;
    
    CGFloat deltaX              = proposedContentOffset.x - self.collectionView.contentOffset.x;
    CGFloat velX                = velocity.x;
    
    if(deltaX == 0.0 || velX == 0 || (velX >  0.0  &&  deltaX >  0.0) || (velX <  0.0 &&  deltaX <  0.0)) {
        
    } else if(velocity.x >  0.0) {
        for (UICollectionViewLayoutAttributes *layoutAttributes in array)
        {
            if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
            {
                CGFloat itemHorizontalCenter = layoutAttributes.center.x;
                if (itemHorizontalCenter >  proposedContentOffset.x) {
                    proposedContentOffset.x = nextOffset + (currentAttributes.frame.size.width / 2) + (layoutAttributes.frame.size.width / 2);
                    break;
                }
            }
        }
    } else if(velocity.x <=  0.0) {
        for (UICollectionViewLayoutAttributes *layoutAttributes in array)
        {
            if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
            {
                CGFloat itemHorizontalCenter = layoutAttributes.center.x;
                if (itemHorizontalCenter >  proposedContentOffset.x) {
                    proposedContentOffset.x = nextOffset - ((currentAttributes.frame.size.width / 2) + (layoutAttributes.frame.size.width / 2));
                    break;
                }
            }
        }
    }
    
    if (proposedContentOffset.x == -0.0) {
        proposedContentOffset.x = 0.0;
        
    }
    return proposedContentOffset.x;
    
}

-(void)setPagingEnabled:(BOOL)isPagingEnabled{
    _isPagingEnabled = isPagingEnabled;
}


static CGFloat const ActiveDistance = 100;
//static CGFloat const ScaleFactor = 0.05;


/**
 *  返回所有cell的布局属性
 */
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    //    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    //需要把[super layoutAttributesForElementsInRect:rect]数组的拷贝一份出来
    NSArray *array = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        CGFloat normalizedDistance = distance / ActiveDistance;
        CGFloat zoom = 1 + self.scaleFactor * (1 - ABS(normalizedDistance));
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        attributes.zIndex = 1;
    }
    
    return array;
}

/**
 *  边界发生改变时，是否需要重新布局，返回YES就需要重新布局(会自动调用layoutAttributesForElementsInRect方法，获得所有cell的布局属性)
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
