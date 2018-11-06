//
//  SubmitTVCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExerciseSubmitDelegate <NSObject>

-(void)submitButtonClicked:(UIButton *)button;

@end

@interface SubmitTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)submitAnswer:(UIButton *)sender;

@property (weak, nonatomic) id<ExerciseSubmitDelegate>delegate;

@end
