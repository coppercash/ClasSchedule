//
//  ScheduleNvCon.h
//  ClasSchedule
//
//  Created by Remaerd on 11-10-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface ScheduleNvCon : UINavigationController{
    UIImageView* background;
}

#pragma mark - Push & Pop
- (void)pushDayControllerWithWeekday:(NSInteger)aWeekday focused:(BOOL)aFocused animated:(BOOL)animated;
- (void)pushWeekControllerAnimated:(BOOL)animated;
- (void)pushCourseConWithCourse:(Course*)aCourse animated:(BOOL)animated;
- (void)pushCourseIconConWithCourse:(Course*)aCourse animated:(BOOL)animated;
@end
