//
//  RequestQAView.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/2.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"

@protocol RequestQADelegate <NSObject>

-(void)cancelButtonClicked:(UIButton *)button;

-(void)requestButtonClicked:(UIButton *)button;

-(void)dismissButtonClicked:(UIButton *)button;

@end

@interface RequestQAView : UIView

@property (weak, nonatomic) IBOutlet UIView *basicView;

@property (weak, nonatomic) IBOutlet UIView *qBasicView;/* 问题说明底图 */

@property (weak, nonatomic) IBOutlet UILabel *qLabel;/* 问题说明 */

@property (weak, nonatomic) IBOutlet UIView *qline;/* 横线 */

@property (weak, nonatomic) IBOutlet UITextView *qContent;/* 问题说明输入框 */

@property (weak, nonatomic) IBOutlet UILabel *qPlaceholder;/* 问题说明placeholder */

@property (weak, nonatomic) IBOutlet UILabel *wordCount;


@property (weak, nonatomic) IBOutlet PhotoView *photoOne;

@property (weak, nonatomic) IBOutlet PhotoView *photoTwo;

@property (weak, nonatomic) IBOutlet PhotoView *photoThree;

@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;


- (IBAction)cancel:(MainGreenButton *)sender;

- (IBAction)requestQA:(MainGreenButton *)sender;

- (IBAction)dismiss:(UIButton *)sender;

@property (weak, nonatomic) id<RequestQADelegate>delegate;

@end
