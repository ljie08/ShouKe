//
//  UserListCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/12.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "UserListCell.h"

@interface UserListCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *item;

@property (strong, nonatomic) NSArray *icons;

@property (strong, nonatomic) NSArray *items;

@end

@implementation UserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - lazy load
-(NSArray *)icons{
    if (!_icons) {
        _icons = @[[UIImage imageNamed:@"yijianfankui"],
                   [UIImage imageNamed:@"guanyu"]
                   ];
    }
    
    return _icons;
}

-(NSArray *)items{
    if (!_items) {
        _items = @[@"意见反馈",@"关于知邻"];
    }
    
    return _items;
}

#pragma mark - configure cell
-(void)configureCellWithIndex:(NSIndexPath *)indexPath{
    
    self.icon.image = self.icons[indexPath.row];
    self.item.text = self.items[indexPath.row];
}

@end
