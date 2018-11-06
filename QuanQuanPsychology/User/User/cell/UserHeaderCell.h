//
//  UserHeaderCell.h
//  QuanQuanPsychology
//
//  Created by user on 2018/9/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserHeaderCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithModel:(UserModel *)model;

@end
