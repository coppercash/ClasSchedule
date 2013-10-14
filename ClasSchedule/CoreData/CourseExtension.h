//
//  CourseExtension.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface CourseExtension : NSManagedObject

@property (nonatomic, retain) NSString * iconPath;
@property (nonatomic, retain) NSNumber * red;
@property (nonatomic, retain) NSNumber * blue;
@property (nonatomic, retain) NSNumber * green;
@property (nonatomic, retain) Course *course;

@end
