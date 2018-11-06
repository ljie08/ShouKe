//
//  FullImageView.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/22.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "FullImageView.h"


@implementation FullImageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor customisDarkGreyColor] colorWithAlphaComponent:0.7];
        
    }
    
    return self;
}

-(void)showBigPicWithImage:(UIImage *)image{
    
    CGRect rect = [self imageRectWithImage:image withIndex:0];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBigPicture:)];
    [self addGestureRecognizer:dismiss];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [imageView addGestureRecognizer:pinchGestureRecognizer];
}

-(CGRect)imageRectWithImage:(UIImage *)image withIndex:(NSInteger)index{
    
    CGSize size = image.size;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat widthScale =  size.width / w;
    CGFloat heightScale = size.width / size.height;
    
    CGFloat width = size.width / widthScale;
    CGFloat height = width / heightScale;
    CGFloat y = (h - height) / 2;
    CGFloat x = index * w;
    
    return CGRectMake(x, y, width, height);
}

#pragma mark - Gesture
-(void)hideBigPicture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

-(void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}



@end
