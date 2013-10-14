//
//  ClassesNvCon.h
//  ClasSchedule
//
//  Created by Remaerd on 11-10-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface CoursesNvCon : UINavigationController{
    UIImageView* background;
}
@property(nonatomic,retain)UIImageView* background;
#pragma mark - Push & Pop
- (void)pushCourseConWithCourse:(Course*)aCourse animated:(BOOL)animated;
- (void)pushCourseIconConWithCourse:(Course*)aCourse animated:(BOOL)animated;
- (void)pushCourseTableConAnimated:(BOOL)animated;
@end
