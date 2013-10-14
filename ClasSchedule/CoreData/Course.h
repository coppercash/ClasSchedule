//
//  Course.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseExtension, Note, Schedule;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) CourseExtension *courseExtension;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *schedules;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;
- (void)addSchedulesObject:(Schedule *)value;
- (void)removeSchedulesObject:(Schedule *)value;
- (void)addSchedules:(NSSet *)values;
- (void)removeSchedules:(NSSet *)values;
@end
