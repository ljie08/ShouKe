//
//  MoreNoteActionCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/8.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "NoteDelegate.h"

@interface MoreNoteActionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)moreAction:(UIButton *)sender;

//@property (weak, nonatomic) id<NoteDelegate>delegate;

-(void)updateBtnStatus:(BOOL)hasNote;


@end
