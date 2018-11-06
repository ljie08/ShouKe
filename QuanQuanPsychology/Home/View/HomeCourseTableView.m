//
//  HomeCourseTableView.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/20.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "HomeCourseTableView.h"
#import "HomeCourseTVCell.h"
#import "VideoCourseModel.h"

static NSString * const cellID = @"HomeCourseTVCell";
static NSInteger const headerHeight = 50;

@interface HomeCourseTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HomeCourseTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicSetting];
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self basicSetting];
}

-(void)basicSetting{
    self.delegate = self;
    self.dataSource = self;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    
    
    self.backgroundColor = [UIColor clearColor];
    [self registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    return self.courseLists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCourseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    VideoCourseModel *course = self.courseLists[indexPath.row];
    
    [cell configureCellWithModel:course];
    
    return cell;
}


#pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCourseModel *course = self.courseLists[indexPath.row];

    self.didSelectRowAtIndexPath(tableView, indexPath, course);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, headerHeight)];
    
    UIView *color = [[UIView alloc] initWithFrame:CGRectMake(15, (headerHeight - 20) / 2 , 5, 20)];
    color.backgroundColor = [UIColor customisMainGreen];
    [view addSubview:color];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(color.frame.origin.x + 5 + 3, 0, tableView.frame.size.width / 2 - 15 - 8, headerHeight)];
    label.text = @"精选好课";
    label.textColor = [UIColor blackColor];
    if (@available(iOS 8.2, *)) {
        label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    } else {
        label.font = [UIFont systemFontOfSize:18];
    }
    [view addSubview:label];
    
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 2, 0, tableView.frame.size.width / 2 - 15, headerHeight)];
    [more setTitle:@"更多" forState:UIControlStateNormal];
    [more setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    more.titleLabel.font = [UIFont systemFontOfSize:12];
    more.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    more.titleLabel.textAlignment = NSTextAlignmentRight;
    [more addTarget:self action:@selector(moreCourse:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:more];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(void)moreCourse:(UIButton *)button{
    self.didClickMoreCourseButton(button);
}

@end
