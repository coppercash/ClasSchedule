//
//  ColsInfo.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule;

@interface ColsInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * colIndex;
@property (nonatomic, retain) NSSet *schedules;
@end

@interface ColsInfo (CoreDataGeneratedAccessors)

- (void)addSchedulesObject:(Schedule *)value;
- (void)removeSchedulesObject:(Schedule *)value;
- (void)addSchedules:(NSSet *)values;
- (void)removeSchedules:(NSSet *)values;
@end
