//
//  BlankView.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/30.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BlankView.h"

@interface BlankView()

@property (strong, nonatomic) UIImageView *image;

@property (strong, nonatomic) UILabel *label;

@end

@implementation BlankView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI:frame];
    }
    return self;
}

-(void)initUI:(CGRect)frame{
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = width / 2.68;
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self addSubview:self.image];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.image.frame.origin.y + self.image.frame.size.height, self.frame.size.width, 30)];
    self.label.textColor = [UIColor colorwithHexString:@"#c9c9c9"];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.label];
}

-(void)updateImage:(UIImage *)image imageCenter:(CGPoint)center content:(NSString *)content{
    self.image.image = image;
    self.label.text = content;
    self.image.center = center;
    self.label.frame = CGRectMake(0, self.image.frame.origin.y + self.image.frame.size.height, self.frame.size.width, 30);

}


@end
