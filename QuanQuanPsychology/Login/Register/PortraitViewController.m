//
//  PortraitViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/17.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "PortraitViewController.h"
#import "EnterAppHelper.h"
#import "LoginAPI.h"

@interface PortraitViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *registerLabel;

@property (weak, nonatomic) IBOutlet UIView *portraitBasicView;

@property (weak, nonatomic) IBOutlet UIImageView *portrait;

@property (weak, nonatomic) IBOutlet UILabel *portraitLabel;

@property (weak, nonatomic) IBOutlet UIImageView *nameIcon;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UIView *nameLine;

@property (weak, nonatomic) IBOutlet UILabel *nameWarning;

@property (weak, nonatomic) IBOutlet UILabel *checkWarning;

@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

@property (strong, nonatomic) UIImage *portraitImage;



@end

@implementation PortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)updateUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.enterBtn.enabled = NO;
    
    [self.enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.enterBtn setTitleColor:[UIColor colorwithHexString:@"8D8D8D"] forState:UIControlStateDisabled];
    self.enterBtn.layer.cornerRadius = 6;
    
    self.checkWarning.hidden = YES;
    self.nameTF.delegate = self;
    
    self.portraitBasicView.layer.cornerRadius = self.portraitBasicView.frame.size.height / 2;
    self.portraitBasicView.clipsToBounds = YES;
    self.portraitBasicView.layer.borderWidth = 1.0;
    self.portraitBasicView.layer.borderColor = [UIColor colorwithHexString:@"#E4E4E4"].CGColor;
    
    [self.portrait sd_setImageWithURL:[QuanUtils fullImagePath:self.portraitPath]];
    
    self.portrait.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadNewPortrait:)];
    [self.portraitBasicView addGestureRecognizer:tap];
}

-(void)updateNameView{
    self.nameIcon.image = [UIImage imageNamed:@"login_user_action"];
    self.nameLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
}

-(void)updateCheckWarning:(NSString *)string{
    self.checkWarning.text = string;
    self.checkWarning.hidden = NO;
}

#pragma mark - <UITextFieldDelegate>
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self updateNameView];
    self.enterBtn.enabled = YES;
    self.enterBtn.backgroundColor = [UIColor customisMainColor];
}

/* 当用户按下return键或者按回车键，keyboard消失 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Gesture
-(void)uploadNewPortrait:(UITapGestureRecognizer *)tap{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    
    [alert addAction:takePhoto];
    [alert addAction:chooseFromLibrary];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.portraitImage = image;
    
    self.portrait.image = image;
    
    self.portraitLabel.hidden = YES;
    self.portraitBasicView.layer.borderWidth = 0;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button Action
- (IBAction)enterApp:(UIButton *)sender {
    
    NSString *msg = [self.nameTF.text isNamingStyle];

    if ([NSString stringIsNull:msg]) {

        [self uploadUserInfoWithName:YES];


    } else {
        self.checkWarning.hidden = NO;
        self.checkWarning.text = msg;
    }
    
}

- (IBAction)skip:(UIButton *)sender {
    
    [self uploadUserInfoWithName:NO];
    
}

-(void)uploadUserInfoWithName:(BOOL)hasName{
    
    NSString *userName;
    
    if (hasName) {
        userName = self.nameTF.text;
    } else {
        userName = [self.phone hidePhoneNumber];
    }
    
    
    [LoginAPI uploadUserPortraitWithUID:self.uid image:self.portraitImage andUserName:userName callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            NSDictionary *userInfo = dict[USERINFO];
            
            EnterAppHelper *helper = [[EnterAppHelper alloc] init];
            helper.password = self.password;
            [helper setUserDefaultsAndSaveUserInfo:userInfo withPhone:self.phone currentVC:self];
            
        } else {
            [self updateCheckWarning:message];
            
        }
    }];
    
}

@end
