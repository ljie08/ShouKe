//
//  NewsDetailViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/25.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "FullImageView.h"

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *newsTitle;

@property (weak, nonatomic) IBOutlet UILabel *newsTime;

@property (weak, nonatomic) IBOutlet UILabel *newsContent;

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;

@property (strong, nonatomic) FullImageView *fullImage;

/* ViewConstraints */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;



@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    
    [super updateViewConstraints];
    
    CGFloat exist = 0;
    
    if ([NSString stringIsNull:self.imagePath]) {
        exist = 12 + 9 + 12 + 14 + 213;
    } else {
        exist = 12 + 9 + 12 + 14;
    }
    
    CGFloat rest = ScreenHeight - NavHeight - StatusHeight - exist;
    
    CGFloat titleH = [QuanUtils caculateLabelHeightWithText:self.titleString lineSpacing:6 andFont:[UIFont systemFontOfSize:20] andViewSize:CGSizeMake(ScreenWidth - 15*2, MAXFLOAT)];
    
    CGFloat contentH = [QuanUtils caculateLabelHeightWithText:self.contentString lineSpacing:6 andFont:[UIFont systemFontOfSize:15] andViewSize:CGSizeMake(ScreenWidth - 15*2, MAXFLOAT)];
    
    if ((titleH + contentH) <= rest) {
        self.scrollHeight.constant = ScreenHeight - NavHeight - StatusHeight;
    } else {
        self.scrollHeight.constant = exist + titleH + contentH + 100;
    }
    

}

#pragma mark - Data
-(void)loadData{
    self.newsTitle.text = self.titleString;
    self.newsContent.text = self.contentString;
    self.newsTime.text = self.timeString;
    if (![NSString stringIsNull:self.imagePath]) {
        [self.newsImage sd_setImageWithURL:[QuanUtils fullImagePath:self.imagePath] placeholderImage:[UIImage imageNamed:@"推送消息详情默认图"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.newsImage.layer.cornerRadius = 4;
            
            self.newsImage.contentMode = UIViewContentModeCenter;
            if (self.newsImage.image.size.height >= 213) {
                self.newsImage.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullImage:)];
        self.newsImage.userInteractionEnabled = YES;
        [self.newsImage addGestureRecognizer:tap];
    }
}

#pragma mark - Gesture
-(void)showFullImage:(UITapGestureRecognizer *)tap{
    self.fullImage = [[FullImageView alloc] initWithFrame:self.view.bounds];
    [self.navigationController.view addSubview:self.fullImage];
    [self.fullImage showBigPicWithImage:self.newsImage.image];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
