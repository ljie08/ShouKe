//
//  UIView+Layer.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/12.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layer)

-(void)shadowOffset:(CGSize)size
        shadowColor:(UIColor *)color
              alpha:(CGFloat)alpha
       shadowRadius:(CGFloat)raduis
      shadowOpacity:(CGFloat)opactity;

-(void)gradientBorderWithRect:(CGRect)rect cornerRadius:(CGFloat)radius;

@end
