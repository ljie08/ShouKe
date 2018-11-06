//
//  ChangeUserIntroduceViewController.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/8.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "ChangeUserIntroduceViewController.h"
#import "UserInfoAPI.h"
#import "ArchiveHelper.h"

@interface ChangeUserIntroduceViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *introduceText;

@property (nonatomic, strong) UITextView *iTextview;/**< <#注释#> */

@end

@implementation ChangeUserIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改我的简介";
    self.introduceText.delegate = self;
    self.introduceText.textColor = [UIColor customisLightGreyColor];
    self.introduceText.text = @"请输入我的简介";
    self.introduceText.hidden = YES;
    self.introduceText.userInteractionEnabled = NO;
    [self initTextView];
    
    /* 添加导航栏按钮 */
    UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem = finish;
}

#pragma mark - Button Action
-(void)finishAction{
    if (self.iTextview.text.length != 0) {
            [UserInfoAPI changeUserIntroduce:self.iTextview.text uid:USERUID callback:^(APIReturnState state, id data, NSString *message) {
                if (state == API_SUCCESS) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RenewUserIntroduce" object:self.iTextview];
                    UserModel *user = [ArchiveHelper unarchiveModelWithKey:@"userInfo" docePath:@"userInfo"];
                    user.userName = self.iTextview.text;
                    [ArchiveHelper archiveModel:user forKey:@"userInfo" docePath:@"userInfo"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self presentAlertWithTitle:message message:@"请稍后再试" actionTitle:@"确定"];
                }
            }];
    }
    
}

#pragma mark - textview
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.text.length) {
        textView.text = nil;
        
        textView.textColor = [UIColor customisDarkGreyColor];
    } else {
        textView.text = @"请输入简介";
        textView.textColor = [UIColor grayColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
//    CGFloat width = CGRectGetWidth(textView.frame);
//    CGFloat height = CGRectGetHeight(textView.frame);
//    //高度自适应
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
//    textView.frame= newFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTextView {
    UIView *whiteview = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 100)];
    whiteview.backgroundColor = [UIColor clearColor];
    
    self.iTextview = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 90)];
    self.iTextview.backgroundColor = [UIColor clearColor];
    self.iTextview.text = @"请输入简介";
    self.iTextview.textColor = [UIColor grayColor];
    self.iTextview.delegate = self;
//    self.iTextview.textContainer.lineFragmentPadding = 0;
//    self.iTextview.textContainerInset = UIEdgeInsetsZero;
    self.iTextview.showsVerticalScrollIndicator = NO;
    self.iTextview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:whiteview];
    [whiteview addSubview:self.iTextview];
}

@end
