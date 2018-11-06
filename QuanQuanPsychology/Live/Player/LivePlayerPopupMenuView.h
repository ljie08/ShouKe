//
//  LivePlayerPopupMenuView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/25.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LivePlayerPopupMenuView;
@protocol LivePlayerPopupMenuViewDelegate <NSObject>

-(void)popupMenu:(LivePlayerPopupMenuView *)menu onMenuClick:(UIButton *)button;

@end

@interface LivePlayerPopupMenuView : UIView

@property (weak, nonatomic) id<LivePlayerPopupMenuViewDelegate>delegate;

-(void)creatPopupWithTitles:(NSArray *)titles
                     screen:(BOOL)fullScreen;

@end


