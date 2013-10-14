//
//  Schedule.h
//  ClasSchedule
//
//  Created by Remaerd on 12-1-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Course;

@interface Schedule :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * seq_day;
@property (nonatomic, retain) NSNumber * seq_week;
@property (nonatomic, retain) Course * course;

@end



