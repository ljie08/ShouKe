//
//  PhotoView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/2.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewDelegate<NSObject>

-(void)addNewPhoto:(UIImage *)image andPlaceholderForIndex:(NSInteger)index;
-(void)deletePhoto:(NSInteger)index;

@end

@interface PhotoView : UIView

@property (strong, nonatomic) UIImageView *image;

@property (strong, nonatomic) UIButton *deleteBtn;

@property (assign, nonatomic) NSInteger index;//图片标记位置

@property (weak, nonatomic) UIViewController *viewController;

@property (weak, nonatomic) id<PhotoViewDelegate>delegate;

@end
