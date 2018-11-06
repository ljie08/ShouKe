//
//  UIView+Layer.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/12.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "UIView+Layer.h"

@implementation UIView (Layer)

-(void)shadowOffset:(CGSize)size
        shadowColor:(UIColor *)color
              alpha:(CGFloat)alpha
       shadowRadius:(CGFloat)raduis
      shadowOpacity:(CGFloat)opactity{
    
    self.layer.shadowOffset = size;
    self.layer.shadowColor = [color colorWithAlphaComponent:alpha].CGColor;
    self.layer.shadowRadius = raduis;
    self.layer.shadowOpacity = opactity;
}

-(void)gradientBorderWithRect:(CGRect)rect cornerRadius:(CGFloat)radius{
    
    self.layer.masksToBounds = YES;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    gradientLayer.colors = @[(__bridge id)[UIColor colorwithHexString:@"#662D8C"].CGColor, (__bridge id)[UIColor colorwithHexString:@"#E51F7A"].CGColor];
    //startPoint和endPoint属性，他们决定了渐变的方向。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1}
    //startPoint和pointEnd 分别指定颜色变换的起始位置和结束位置.
    //当开始和结束的点的x值相同时, 颜色渐变的方向为纵向变化
    //当开始和结束的点的y值相同时, 颜色渐变的方向为横向变化
    //其余的 颜色沿着对角线方向变化
    //    [gradientLayer setLocations:@[@0.3, @0.8,@1]];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    [self.layer addSublayer:gradientLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame = rect;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.lineWidth = 1;
    progressLayer.path = path.CGPath;
    gradientLayer.mask = progressLayer;
}

@end
