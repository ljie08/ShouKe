//
//  VideoNodeModel.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/25.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface VideoNodeModel : BasicModel

@property (nonatomic, assign) NSInteger nodeid;/**< 节点id */
@property (nonatomic, copy) NSString *nodeDesc;/**< 描述 */
@property (nonatomic, copy) NSString *time_node;/**< 时间 */
@property (nonatomic, copy) NSString *video_id;/**< 视频id */

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
