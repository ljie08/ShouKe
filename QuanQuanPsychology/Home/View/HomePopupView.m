//
//  HomePopupView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/16.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "HomePopupView.h"

@interface HomePopupView()

@property (strong, nonatomic) UIImageView *image;

@end

@implementation HomePopupView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self creatUI];
    }
    
    return self;
}

-(void)creatUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    CGFloat imageW = ScreenWidth * 0.86;
    CGFloat imageX = ScreenWidth * (1 - 0.86) / 2;
    CGFloat imageY = ScreenHeight * 0.243;
    CGFloat imageH = imageW * 0.855;
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    self.image.userInteractionEnabled = YES;
    [self addSubview:self.image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popupTap:)];
    [self.image addGestureRecognizer:tap];
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 26) / 2, imageY + imageH, 26, 42)];
    [close setImage:[UIImage imageNamed:@"活动分享取消"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close];
    
}

-(void)closePopup:(UIButton *)button{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)setImagePath:(NSString *)imagePath{
    [self.image sd_setImageWithURL:[QuanUtils fullImagePath:imagePath] placeholderImage:[UIImage imageNamed:@"弹窗默认图"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

-(void)popupTap:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
    self.popupLink();
}



@end
