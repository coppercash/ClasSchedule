//
//  ScheduleFormCell.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFFormViewCell.h"
@class Course;
@interface ScheduleFormCell : DFFormViewCell{
    Course* course;
    
    /*Views*/
    UILabel* courseName;
}
@property(nonatomic,retain)Course* course;
@property(nonatomic,retain)UILabel* courseName;
#pragma mark - Frame
- (CGRect)topAreaFrame;
- (CGRect)effectiveBounds;
- (void)configureCourseName:(UILabel*)aCourseName;
- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations count:(int)count;
- (void)drawGradientBackground:(CGRect)aRect;
- (CGRect)locateCourseName;
@end
