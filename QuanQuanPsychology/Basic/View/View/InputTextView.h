//
//  InputTextView.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/7.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTextView : UIView

@property (weak, nonatomic) IBOutlet UITextView *content;

@property (weak, nonatomic) IBOutlet UILabel *contentPlaceholder;

@property (weak, nonatomic) IBOutlet UILabel *wordCount;

@end
