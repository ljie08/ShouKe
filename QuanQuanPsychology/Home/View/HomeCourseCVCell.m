//
//  HomeCourseCVCell.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "HomeCourseCVCell.h"
#import "VideoCourseModel.h"

@interface HomeCourseCVCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end


@implementation HomeCourseCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellForIndex:(NSIndexPath *)indexPath withModel:(VideoCourseModel *)model{
    
    [self.image sd_setImageWithURL:[QuanUtils fullImagePath:model.imagePath] placeholderImage:[UIImage imageNamed:@"default_home_banner"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
}

@end
