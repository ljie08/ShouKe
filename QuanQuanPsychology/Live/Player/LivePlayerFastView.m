//
//  LivePlayerFastView.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/21.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "LivePlayerFastView.h"

@interface LivePlayerFastView()

@property (nonatomic, strong) UIImageView *fastImgView;/**< 快进/快退图 */
@property (nonatomic, strong) UILabel *timeLab;/**< 时间 */
@property (nonatomic, assign) CGFloat frameWidth;/**< <#注释#> */

@end

@implementation LivePlayerFastView

//130 83
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _fastImgView = [[UIImageView alloc] init];
        [self addSubview:_fastImgView];
        
        _timeLab = [[UILabel alloc] init];
        [self addSubview:_timeLab];
        
        _frameWidth = frame.size.width;
        
        self.backgroundColor = [[UIColor colorwithHexString:@"#000000"] colorWithAlphaComponent:0.41];
    }
    return self;
}

- (void)layoutSubviews {
    self.fastImgView.frame = CGRectMake((self.frameWidth-30)/2, 15, 24, 20);
    
    self.timeLab.frame = CGRectMake(0, CGRectGetMaxY(self.fastImgView.frame)+10, self.frameWidth, 22);
    self.timeLab.textColor = [UIColor whiteColor];
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    self.timeLab.font = [UIFont systemFontOfSize:13];
    
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
}

- (void)setFastType:(FastType)fastType {
    _fastType = fastType;
    switch (fastType) {
        case FastForward:
            self.fastImgView.image = [UIImage imageNamed:@"v_ff"];
            break;
        case FastBack:
            self.fastImgView.image = [UIImage imageNamed:@"v_fb"];
            break;
            
        default:
            break;
    }
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeStr = timeStr;
    self.timeLab.text = timeStr;
}

@end
