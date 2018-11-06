//
//  PhotoView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/2.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation PhotoView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat size = 22;
    CGFloat bX = self.frame.size.width - size;
    
    self.deleteBtn.frame = CGRectMake(bX, 0, size, size);
    
    CGFloat pSize = self.frame.size.width * 0.893;
    CGFloat pY = self.frame.size.height - pSize;
    
    self.image.frame = CGRectMake(0, pY, pSize, pSize);
    
}

#pragma mark - UI
-(void)initUI{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNew:)];
    [self addGestureRecognizer:tap];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.image.image = [UIImage imageNamed:@"添加照片"];
    [self addSubview:self.image];
    
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.deleteBtn setImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteAPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
    self.deleteBtn.hidden = YES;
}

#pragma mark - Gesture
-(void)addNew:(UITapGestureRecognizer *)tap{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self.viewController presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *chooseFromLibrary = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self.viewController presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:takePicture];
    [alert addAction:chooseFromLibrary];
    [alert addAction:cancel];
    
    alert.view.tintColor = [UIColor colorwithHexString:@"#333333"];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - <UIImagePickerControllerDelegate>
/* 上传选择的图片 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.image.image = image;
    
    if ([self.delegate respondsToSelector:@selector(addNewPhoto:andPlaceholderForIndex:)]) {
        [self.delegate addNewPhoto:image andPlaceholderForIndex:(self.index + 1)];
    }
    
    self.deleteBtn.hidden = NO;
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Button Action
-(void)deleteAPhoto:(UIButton *)button{
    
    self.image.image = [UIImage imageNamed:@"添加照片"];
    
    if ([self.delegate respondsToSelector:@selector(deletePhoto:)]) {
        [self.delegate deletePhoto:self.index];
    }
}

@end
