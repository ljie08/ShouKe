//
//  KeyboardTextView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/8.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardTextView : UIView

@property (strong, nonatomic) UIView *basicView;

@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) UILabel *wordCount;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UIButton *doneBtn;

@property (assign, nonatomic) NSInteger maxWordCount;

@end
