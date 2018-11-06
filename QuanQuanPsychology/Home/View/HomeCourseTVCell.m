//
//  HomeCourseTVCell.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/20.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "HomeCourseTVCell.h"

#import "VideoCourseModel.h"

@interface HomeCourseTVCell()

@property (weak, nonatomic) IBOutlet UIImageView *courseImage;

@property (weak, nonatomic) IBOutlet UILabel *courseName;

@property (weak, nonatomic) IBOutlet UILabel *courseTeacher;

@property (weak, nonatomic) IBOutlet UILabel *coursePrice;

@property (weak, nonatomic) IBOutlet UILabel *courseOwners;


@end

@implementation HomeCourseTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithModel:(VideoCourseModel *)model{
    
    [self.courseImage sd_setImageWithURL:[QuanUtils fullImagePath:model.imagePath] placeholderImage:[UIImage imageNamed:@"default_home_course"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.courseImage.layer.cornerRadius = 5;
        self.courseImage.layer.masksToBounds = YES;
    }];
    
    [self.courseImage shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.2 shadowRadius:6 shadowOpacity:1];
    
    self.courseName.text = model.courseName;
    self.courseTeacher.text = [NSString stringWithFormat:@"讲师：%@", model.courseTeacher];
    self.coursePrice.text = [NSString stringWithFormat:@"¥ %@", model.coursePrice];
    self.courseOwners.text = [NSString stringWithFormat:@"%@人已报名", model.courseOwners];
}

@end
