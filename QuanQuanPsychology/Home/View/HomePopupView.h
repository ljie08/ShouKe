//
//  HomePopupView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/16.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePopupView : UIView

@property (strong, nonatomic) NSString *imagePath;//弹窗图片路径

@property (copy, nonatomic) void(^popupLink)(void);

@end
