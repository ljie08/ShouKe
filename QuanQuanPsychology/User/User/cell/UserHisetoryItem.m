//
//  UserHisetoryItem.m
//  QuanQuanPsychology
//
//  Created by user on 2018/9/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "UserHisetoryItem.h"

@interface UserHisetoryItem()

@property (weak, nonatomic) IBOutlet UIImageView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation UserHisetoryItem

- (void)setDataWithModel:(VideoRecordModel *)model {
    self.titleLab.text = [NSString stringWithFormat:@"%@ %@", model.p_name, model.NAME];
    [self.videoView sd_setImageWithURL:[QuanUtils fullImagePath:model.play_background_pic_url] placeholderImage:[UIImage imageNamed:@"default_course_selection"] completed:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
