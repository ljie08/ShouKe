//
//  PackageDetailCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *item;

@property (weak, nonatomic) IBOutlet UILabel *content;

-(void)setItem:(NSString *)item content:(NSString *)content;

@end
