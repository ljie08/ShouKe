//
//  LivePlayerFastView.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/21.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FastType) {
    FastForward,//快进
    FastBack,//快进快退
};

@interface LivePlayerFastView : UIView

@property (nonatomic, assign) FastType fastType;/**< 滑动类型 */
@property (nonatomic, strong) NSString *timeStr;/**< 时间 */
//- (void)setFastImageWithFastType:(FastType)type;

//- (void)updateTimeWithTime:(NSString *)time;

@end
