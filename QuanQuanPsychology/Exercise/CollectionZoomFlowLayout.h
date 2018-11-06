//
//  CollectionZoomFlowLayout.h
//  QuanQuan
//
//  Created by Jocelyn on 16/8/5.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionZoomFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat move_x;
@property (assign, nonatomic) BOOL isPagingEnabled;
@property (assign, nonatomic) CGFloat scaleFactor;
-(void)setPagingEnabled:(BOOL)isPagingEnabled;

@end
