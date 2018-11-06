//
//  CustomizePageControl.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/26.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CustomizePageControl.h"

@implementation CustomizePageControl

- (void)setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIView *subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 10;
        size.width = 10;
        [subview setFrame:CGRectMake(subview.frame.origin.x,subview.frame.origin.y,
                                     size.width,size.height)];
        
        subview.layer.cornerRadius = 5;
        
        if (subviewIndex == page) {
            subview.layer.borderWidth = 0;
            subview.layer.borderColor = [UIColor clearColor].CGColor;
            
        } else {
            subview.layer.borderWidth = 0.2;
            subview.layer.borderColor = [UIColor blackColor].CGColor;
        }
    }

}
@end
