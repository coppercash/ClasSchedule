//
//  Course.h
//  ClasSchedule
//
//  Created by Remaerd on 12-1-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Schedule;

@interface Course :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSSet* schedules;

@end


@interface Course (CoreDataGeneratedAccessors)
- (void)addSchedulesObject:(Schedule *)value;
- (void)removeSchedulesObject:(Schedule *)value;
- (void)addSchedules:(NSSet *)value;
- (void)removeSchedules:(NSSet *)value;

@end

