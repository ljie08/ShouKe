//
//  ShareView.h
//  QuanQuan
//
//  Created by Jocelyn on 2016/12/26.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharePlatformView.h"

//@protocol ShareViewDelegate <NSObject>
//
//@optional
//-(void)shareSuccess;
//
//@end


@interface ShareView : UIView

//@property (strong, nonatomic) NSString *shareTitle;
//
//@property (strong, nonatomic) NSString *shareSubTitle;
//
//@property (strong, nonatomic) UIImage *shareIcon;
//
//@property (strong, nonatomic) NSString *shareURL;
//
//@property (weak, nonatomic) UIViewController *currentVC;
//
//@property (assign, nonatomic) BOOL shareMaterialDifferent;
//
//@property (strong, nonatomic) NSArray *materials;

@property (strong, nonatomic) SharePlatformView *platformView;

//@property (weak, nonatomic) id<ShareViewDelegate> delegate;

@end
