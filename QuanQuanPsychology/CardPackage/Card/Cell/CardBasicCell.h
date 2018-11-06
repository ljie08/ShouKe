//
//  CardBasicCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/28.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol CardDelegate <NSObject>

-(void)doCardExercise:(UIButton *)button;

@end

@interface CardBasicCell : UICollectionViewCell

@property (strong, nonatomic) WKWebView *cardWeb;

@property (strong, nonatomic) UIImageView *webMask;

@property (strong, nonatomic) MainGreenButton *exerciseBtn;

@property (weak, nonatomic) id<CardDelegate>delegate;


-(void)setValueWithModel:(CardModel *)card front:(BOOL)isFront;
-(void)setUIStatus:(BOOL)isFront;
-(UIImage *)switchStarToAppropriateImage:(NSString *)star;

@end
