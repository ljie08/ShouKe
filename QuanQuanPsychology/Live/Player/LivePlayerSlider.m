//
//  LivePlayerSlider.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/7.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "LivePlayerSlider.h"

@implementation LivePlayerSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{//返回滑块大小
    rect.origin.x = rect.origin.x - 3 ;
    rect.size.width = rect.size.width + 10;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 0 , 0);
}

@end
