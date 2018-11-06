//
//  NoticeView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/27.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NoticeViewType) {
    NoticeViewTypeText,
    NoticeViewTypeIndicatorText,
    NoticeViewTypeTextButton
};

typedef NS_ENUM(NSUInteger, NoticeButtonAction) {
    ButtonContinue,
    ButtonRestart,
    ButtonRefresh
};


@interface NoticeView : UIView

@property (assign, nonatomic) CGRect reviseRect;

@property (assign, nonatomic) BOOL success;

@property (copy, nonatomic) void(^completionHandler)(UIButton *button,NoticeButtonAction action);

-(void)dismissViewAfterDelay:(NSTimeInterval)time;

-(void)setNoticeWithType:(NoticeViewType)type
                  notice:(NSString *)notice
               btnTitles:(NSArray *)titles
               btnAction:(NoticeButtonAction)action;

@end
