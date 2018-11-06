//
//  FeedbackViewController.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/10.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UserInfoAPI.h"

@interface FeedbackViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *notice;
@property (weak, nonatomic) IBOutlet UITextView *feedback;
@property (weak, nonatomic) IBOutlet UIView *basicView;
@property (weak, nonatomic) IBOutlet UILabel *customisePlaceholder;
@property (weak, nonatomic) IBOutlet UIButton *image;

//
@property (strong, nonatomic) UIImage *feedbackImage;/* 反馈图片 */

/* ViewConstraints */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedH;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.feedback.delegate = self;
    [self.image setAdjustsImageWhenHighlighted:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.baseH.constant = ScreenHeight * 0.262;
    self.feedH.constant = self.baseH.constant * 0.634;
}

- (IBAction)addImage:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *chooseFromLibrary = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:takePicture];
    [alert addAction:chooseFromLibrary];
    [alert addAction:cancel];
    
    alert.view.tintColor = [UIColor customisDarkGreyColor];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)sendFeed:(id)sender {
    if (self.feedback.text.length == 0) {
        [self presentAlertWithTitle:@"问题描述未填写" message:@"请填写您要提交的问题" actionTitle:@"确定"];
        
    } else {
        
        [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在提交"];
        
        [UserInfoAPI sendFeedbackWithUID:USERUID courseID:USERCOURSE content:self.feedback.text image:self.feedbackImage callback:^(APIReturnState state, id data, NSString *message) {
            if (state == API_SUCCESS) {
                [self hideHUD];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self updateHUDWithMode:MBProgressHUDModeText message:message];
                [self hideHUDAfter:1];
            }
        }];
        
    }
}

#pragma mark - <UIImagePickerControllerDelegate>
/* 上传选择的图片 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.feedbackImage = image;
    
    [self.image setImage:image forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - <UITextViewDelegate>
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length != 0) {
        self.customisePlaceholder.text = @"";
    } else {
        self.customisePlaceholder.text = @"请输入...";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
