//
//  SharePlatformView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/27.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharePlatformViewDelegate <NSObject>

@optional
-(void)shareSuccess;

- (void)getShareSucessScore;

@end

@interface SharePlatformView : UIView

@property (strong, nonatomic) NSString *shareTitle;

@property (strong, nonatomic) NSString *shareSubTitle;

@property (strong, nonatomic) UIImage *shareIcon;

@property (strong, nonatomic) NSString *shareURL;

@property (weak, nonatomic) UIViewController *currentVC;

@property (assign, nonatomic) BOOL shareMaterialDifferent;

@property (strong, nonatomic) NSArray *materials;

@property (weak, nonatomic) id<SharePlatformViewDelegate>delegate;

@property (copy, nonatomic) void(^sharePlatformSeleted)(void);

@end
