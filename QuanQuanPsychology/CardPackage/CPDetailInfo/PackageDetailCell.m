//
//  PackageDetailCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "PackageDetailCell.h"

@implementation PackageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItem:(NSString *)item content:(NSString *)content{
    self.item.text = item;
    self.content.text = content;
}

@end
