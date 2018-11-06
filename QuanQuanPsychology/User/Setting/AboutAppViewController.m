//
//  AboutAppViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 16/8/12.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUI{
    self.title = self.navTitle;
    self.textView.text = self.content;
}

@end
