//
//  NewVersionGuideView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/2/1.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewVersionGuideViewDelegate<NSObject>

@optional
-(void)removeVersionGuide;

@end

@interface NewVersionGuideView : UIView

@property (strong, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) id<NewVersionGuideViewDelegate>delegate;

@end
