//
//  BannerCVCell.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/10.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BannerCVCell.h"

@interface BannerCVCell ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation BannerCVCell

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.imageView];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

-(void)setImagePath:(NSString *)imagePath{
    _imagePath = imagePath;
    [self.imageView sd_setImageWithURL:[QuanUtils fullImagePath:imagePath] placeholderImage:[UIImage imageNamed:@"default_home_banner"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}

@end
