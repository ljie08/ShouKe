//
//  LivePlayerDefine.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/26.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#ifndef LivePlayerDefine_h
#define LivePlayerDefine_h

typedef NS_ENUM(NSUInteger, LiveCourseStatus) {
    CourseHasNotStart,
    CourseLiving,
    CoursePlayBack,
};

typedef NS_ENUM(NSUInteger, LiveAdvancePlayerViewState) {
    LiveAdvancePlayerViewStateSmall,
    LiveAdvancePlayerViewStateAnimating,
    LiveAdvancePlayerViewStateFullscreen,
};

typedef NS_ENUM(NSUInteger, PlayMethod) {
    PlayURL,
    PlaySTS
};


#endif /* LivePlayerDefine_h */
