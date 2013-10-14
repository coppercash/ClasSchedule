//
//  CourceTableCell.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayCell.h"

#define COURSE_TABLE_CELL_HEIGHT 150.0f

#define ICON_BACK_SIZE 60.0f
#define ICON_FRAME_SIZE 3.0f

#define COURSE_NAME_HEIGHT 30.0f
#define COURSE_NAME_WIDTH 170.0f

#define TEACHER_ICON_SIZE 20.0f
#define TEACHER_NAME_WIDTH 70.0f

#define ROOM_ICON_SIZE 20.0f
#define ROOM_LABEL_WIDTH 70.0f

@class Course,CourseTableCon;

@interface CourseTableCell : DayCell
{
    CourseTableCon* superController;
    Course* _course;
}
@property(nonatomic,assign)CourseTableCon* superController;
@property(nonatomic,retain)Course* course;

#pragma mark - Frames
- (void)loadSubviews;
@end
